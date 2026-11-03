---
title: "Rebuilding Linear’s delta sync read path"
source_url: "https://linear.app/now/rebuilding-delta-sync-read-path"
fetched_at: "2026-10-27T08:17:41.028425+00:00"
---



1. [Now](https://linear.app/now.html)
2. [From the team](https://linear.app/now/team.html)

# Rebuilding Linear’s delta sync read path

![Abstract dark graphic with three horizontal rows of vertical tick marks, with the middle row extending into a thin horizontal line to the right.](https://webassets.linear.app/images/ornj730p/production/977b879d2afb57c6a555af1cd994e35e35351144-3904x1920.png?q=95&auto=format&dpr=2)

![Abstract dark graphic with three horizontal rows of vertical tick marks, with the middle row extending into a thin horizontal line to the right.](https://webassets.linear.app/images/ornj730p/production/f72a0d1e1603fab3d676b914cd6bfedacc90ea47-2352x1280.png?q=95&auto=format&dpr=2)

[Peter Travers](https://linear.app/now/author/peter-travers.html)·August 18, 2026

Linear is a local-first application. Each client maintains a local database so that creating an issue, changing its status, or navigating a workspace doesn’t require a network round trip. That makes the app feel immediate, but the tradeoff is that a client returning online needs a way to catch up, *fast*.

Rather than download the entire workspace again, the client sends a checkpoint containing the ID of the last change it applied. Delta sync uses that checkpoint to retrieve only what has changed in the meantime.

![Flow diagram showing a client database checkpoint at 420 and a workspace log feeding into a delta sync, which identifies relevant actions 421–500 and updates the client database checkpoint to 500.](https://webassets.linear.app/images/ornj730p/production/96ea842071a31e517faa95414b67ebd93473246c-3904x1352.png?q=95&auto=format&dpr=2)

![Flow diagram showing a client database checkpoint at 420 and a workspace log feeding into a delta sync, which identifies relevant actions 421–500 and updates the client database checkpoint to 500.](https://webassets.linear.app/images/ornj730p/production/84657b8ba0a62bfba4dafa220c96c27fe94fdf7c-2352x2572.png?q=95&auto=format&dpr=2)

Some of our largest workspaces produce close to one million sync actions per day, and a client that’s been offline for only a few hours can return hundreds of thousands of sync actions behind. Those results must also be filtered by what the user can access and has subscribed to. Across more than 20 TB of sync actions, delta sync becomes a large, permission-aware set intersection that is increasingly difficult to serve. We built a new read path with [turbopuffer](https://turbopuffer.com/) to keep that query fast and predictable, even as our biggest workspaces continue to grow.

### What a delta sync query actually does[⁠](https://linear.app/now/rebuilding-delta-sync-read-path.html#what-a-delta-sync-query-actually-does)

In practice, every change that Linear clients are concerned with creates a sync action. Each sync action has an ordered ID, the affected model, the type of change, routing metadata, and the data a client must apply.

These sync actions form an application-level log that clients replay into their local databases. It operates at a level of abstraction higher than the Postgres write-ahead log and describes changes in terms the client understands, such as updating an issue, deleting a comment, or archiving a project. Each workspace has its own immutable ordered sync action log where new sync actions are appended.

Linear filters the log by what the user can access and has subscribed to before returning the relevant sync actions.

A simplified delta-sync query looks like this:

![Flow diagram showing four action filters intersecting to produce an ordered list of action IDs for a client.](https://webassets.linear.app/images/ornj730p/production/d14235fb1f604e40b91d79d7a6cf32470b654d4b-3904x1617.png?q=95&auto=format&dpr=2)

![Flow diagram showing four action filters intersecting to produce an ordered list of action IDs for a client.](https://webassets.linear.app/images/ornj730p/production/f3777930107b261568550c20f5ba69553461b687-2352x2300.png?q=95&auto=format&dpr=2)

For context, sync groups encode access to parts of a workspace, and sync subscriptions narrow that further to the models and views the client currently needs.

### Why the Postgres read path stopped scaling[⁠](https://linear.app/now/rebuilding-delta-sync-read-path.html#why-the-postgres-read-path-stopped-scaling)

Our previous delta sync serving path used a second Postgres table designed for these reads. As workspaces began producing thousands of sync actions between client checkpoints, each request combined widening ID range with array-overlap predicates for access and subscriptions, and Postgres spent a growing amount of CPU testing and discarding irrelevant rows.

This caused four problems:

* Tail latency became increasingly volatile, even when median latency remained healthy.
* Adding read replicas did not reduce the amount of intersection work required per request.
* Database maintenance and replica lag could delay how quickly a returning client caught up.
* Extending the query with additional filtering dimensions made an already CPU-intensive path even more expensive.

We could continue tuning indexes and adding replicas, but neither would change the fundamental shape of the query. We needed a serving index designed to combine very large sets with low latency and cost that remained predictable for our largest workspaces. While we investigated using a Postgres GIN index, the cost at write for our scale didn’t make sense.

### Changing the shape of the query[⁠](https://linear.app/now/rebuilding-delta-sync-read-path.html#changing-the-shape-of-the-query)

turbopuffer is [designed around inverted indexes](https://turbopuffer.com/blog/fts-v2-postings) that can [efficiently evaluate large filter intersections](https://turbopuffer.com/docs/permissions). For each filterable attribute, it maintains a mapping from an attribute value to the sorted IDs of documents that contain it. That sorted set of IDs is called a posting list.

For delta sync, each document represents the metadata for a sync action, and its document ID is the sync action ID itself. A sync group, therefore, has a posting list containing every sync action routed to that group. A sync subscription has another, containing every sync action relevant to that subscription.

When a client requests a delta, ContainsAny unions the posting lists for the user’s sync groups. It does the same for the client’s sync subscriptions. turbopuffer then intersects those sets with the requested sync action ID range and any remaining filters.

In the Postgres path, the database examined candidate rows from a potentially large range and repeatedly tested them against the request’s permission and subscription arrays. With inverted indexes, those filters are already represented as sorted sets of matching sync action IDs. The query can combine those sets directly and narrow in on the small intersection the client needs.

The surrounding workload also aligns well with turbopuffer’s architecture:

* Sync actions are immutable, so the index is dominated by appends rather than updates.
* Each workspace maps to its own turbopuffer namespace, keeping tenant data and query work isolated.
* Only fields used for filtering are indexed, while large sync action payloads remain in Postgres.
* turbopuffer’s object-storage architecture allows the index to grow without requiring the full dataset to remain in memory.

### Putting turbopuffer in the read path[⁠](https://linear.app/now/rebuilding-delta-sync-read-path.html#putting-turbopuffer-in-the-read-path)

We built a custom change-data-capture pipeline that reads committed sync actions from a Postgres publication and writes their metadata to turbopuffer. From the moment a sync action commits in Postgres to the moment it becomes available in turbopuffer, replication latency is roughly one second at p50 and a few seconds at p95.

On the read side, we re-designed sync as a two-stage pipeline that includes a metadata scan followed by late enrichment.

The metadata scan returns only the ordered IDs and routing fields needed to decide whether a sync action belongs in the response. While the actions are still represented by this lightweight metadata, the server applies access checks, subscription filters, packet transformations, and deduplication. Only after that filtering is complete do we fetch the full payloads. The server batches the surviving sync action IDs, retrieves their data from Postgres, and streams the enriched sync actions to the client.

![System architecture diagram showing an application write flowing through a Postgres transaction, logical replication, Turbopuffer metadata indexing, filtering and de-duplication, payload enrichment, and an ordered delta returned to the client.](https://webassets.linear.app/images/ornj730p/production/f647caa4320fd1df9599af42b585d94c56dc6123-3904x4455.png?q=95&auto=format&dpr=2)

![System architecture diagram showing an application write flowing through a Postgres transaction, logical replication, Turbopuffer metadata indexing, filtering and de-duplication, payload enrichment, and an ordered delta returned to the client.](https://webassets.linear.app/images/ornj730p/production/0813f73a57c4aaac8f0a6c4ca5482d49dcbc6fb8-1176x1847.png?q=95&auto=format&dpr=2)

Late enrichment is an important part of the design. In the old path, Postgres could read and decode large JSON payloads for candidate sync actions that were later rejected by an access or subscription check. The new path carries compact metadata through most of the server process and enriches only the sync actions that are about to leave for the client.

This keeps the expensive part of the pipeline focused on the sync actions the client will actually receive. As a result, we reduce Postgres I/O, JSON processing, and memory use while preserving an ordered streaming response.

#### Handling replication lag safely[⁠](https://linear.app/now/rebuilding-delta-sync-read-path.html#handling-replication-lag-safely)

Moving reads to a secondary index raises the question of what happens to sync actions that have been committed in Postgres but are not yet visible in turbopuffer.

We do not assume replication is perfectly current. For every delta request, Postgres serves a small, authoritative slice at the head of the sync action log, while turbopuffer serves the larger historical range behind it. The two ranges intentionally overlap, and the server deduplicates the combined result by sync action ID. If turbopuffer is unavailable or cannot cover the requested range, the request falls back to Postgres.

This makes the serving path tolerant of replication delay, out-of-order index visibility, deploys, and restarts. The replicator uses durable progress tracking and idempotent writes, while the read path treats Postgres as the final authority for the most recent actions.

Before sending production traffic through the new path, we ran it in shadow mode. Each request was executed against both turbopuffer and the existing Postgres path, and we compared the resulting sync action IDs. Delta sync is a correctness-critical path; a faster query is only useful if it returns exactly the sync actions the client is supposed to receive.

### Predictable latency at scale[⁠](https://linear.app/now/rebuilding-delta-sync-read-path.html#predictable-latency-at-scale)

The clearest difference between the two read paths showed up in tail latency as workspaces grew. On the Postgres path, larger candidate ranges and access filters steadily increased p95 and p99 latency. With turbopuffer’s posting-list indexes, however, both remained largely flat as workspace size increased.

![Chart comparing tail latency from small to enterprise workspaces, showing Postgres P95 and P99 latency increasing with workspace size while Turbopuffer P95 and P99 remain low and nearly flat.](https://webassets.linear.app/images/ornj730p/production/689381d3da7a137920a305074e7852b12f8d1c55-3904x1866.png?q=95&auto=format&dpr=2)

![Chart comparing tail latency from small to enterprise workspaces, showing Postgres P95 and P99 latency increasing with workspace size while Turbopuffer P95 and P99 remain low and nearly flat.](https://webassets.linear.app/images/ornj730p/production/fb8dc8eda21a6e3c6dd91d576dd6e2d9445ebbdf-2352x1740.png?q=95&auto=format&dpr=2)

In production, that flatter tail made catch-up much more predictable.

This matters most for our largest customers. A workspace generating close to one million sync actions per day should not make reconnecting progressively slower as it grows, nor should large permission and subscription sets force clients into a full bootstrap.

The broader lesson for us was that storing a change log and serving a change log are different problems. Postgres is the right place to commit and retain our client-facing WAL. The reconnect query, however, is an ID range intersected with very large permission and subscription sets.

Representing those sets as posting lists changed the economics of that query. turbopuffer gave us a serving path whose latency stays predictable as both the log and the customer grow, while Postgres remains the authoritative source of the underlying data.

[Peter Travers](https://linear.app/now/author/peter-travers.html)·August 18, 2026

Copy link
