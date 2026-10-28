---
title: "How we built multi-region support for Linear"
source_url: "https://linear.app/now/how-we-built-multi-region-support-for-linear"
fetched_at: "2026-10-27T08:17:41.028425+00:00"
---



1. [Now](https://linear.app/now.html)
2. [From the team](https://linear.app/now/team.html)

# How we built multi-region support for Linear

![An illustration of a globe with connected dots](https://webassets.linear.app/images/ornj730p/production/f188388c5cb52bc0755e8356d57239e93f9b389a-4112x1888.png?q=95&auto=format&dpr=2)

![An illustration of a globe with connected dots](https://webassets.linear.app/images/ornj730p/production/16f6cf8049413320752bc938df267d8da5b8357c-4112x1888.png?q=95&auto=format&dpr=2)

[Sean McGivern](https://linear.app/now/author/smcgivern) and [Tuomas Artman](https://linear.app/now/author/tuomas-artman.html)·May 23, 2024

*Linear now supports [hosting workspace data in Europe](https://linear.app/docs/security.html#data-regions). In this post, we outline why we decided to support multiple regions and how we tackled the project.*

## **Why support multiple regions?**[⁠](https://linear.app/now/how-we-built-multi-region-support-for-linear.html#why-support-multiple-regions)

Initially, Linear’s infrastructure was concentrated in a single location - Google Cloud’s us-east1. While this configuration served most users well, it presented long-term challenges. We identified two primary reasons to diversify our data hosting locations.

First, having a separate region with a full instance of the Linear application makes future scaling simpler. If we can host some workspaces in a particular infrastructure deployment (application servers, databases, etc.), then we can add other regions behind the scenes in the future to avoid hitting scaling limits on, for instance, the size of our primary Postgres server.

From the early beginnings of Linear, we’ve sought to invest in our foundation preemptively, always having an eye on potential future bottlenecks we might encounter. This enables us to build out the best possible infrastructure and application framework, without being forced to urgently implement sub-par solutions to scaling issues when we’re hitting those bottlenecks. This is also why we decided to tackle multi-region infrastructure earlier than other companies would typically do.

Second, many larger European companies prefer to have their data hosted in Europe as it makes their compliance with GDPR easier. Specifically, some companies were worried about potentially entering their customer’s information into Linear and having that data be stored in the US.

Instead of sharding the database, we chose to replicate the entire Linear production deployment. This simplifies development as we can continue executing operations against a single database instance within one deployment, and any ancillary data stores are also regional by default with no additional logic needed. Further, we gain full segregation of regions we operate in. Problems in one region won’t affect others and we are able to improve the reliability and availability of the Linear app.

## **Multi-region architecture**[⁠](https://linear.app/now/how-we-built-multi-region-support-for-linear.html#multi-region-architecture)

From the start, the biggest requirement was that the region selection be invisible to users except when creating a workspace. In practice, this means we didn’t want to have a separate domain for our Europe region–you should be able to use our client (linear.app) and API (api.linear.app) via these primary domains, regardless of where your workspace is hosted. We also extended this requirement for integrations and internal tooling, to make the migration to multi-region seamless and require no code changes outside of our application. Every single feature in Linear should work, regardless of which region you are using.

We wanted to isolate all multi-region complexity to a few sub-systems and APIs. Engineers should never have to think about multi-region when developing functionality for the Linear backend or clients. They should be able to work in their local development environments and multi-region should simply work without any additions when their code is deployed into production.

We identified a simple architecture that would achieve this. Add a proxy in front of all traffic that would be able to authenticate requests, associate them with a user and their workspace, and route the request to the correct region:

![An architecture diagram of multi-region support in Linear](https://webassets.linear.app/images/ornj730p/production/10586baa1f2f50b7c75ded08ba31b6e58e857903-2352x2096.png?q=95&auto=format&dpr=2)

![An architecture diagram of multi-region support in Linear](https://webassets.linear.app/images/ornj730p/production/27a57ea4614c6fc76c626eb12990731e357bc1c7-2352x2096.png?q=95&auto=format&dpr=2)

We worked on this in three distinct phases: Terraforming our infrastructure, extracting authentication to a global service, and creating the proxy to route requests to the correct regions.

### **Terraforming our infrastructure**[⁠](https://linear.app/now/how-we-built-multi-region-support-for-linear.html#terraforming-our-infrastructure)

Before going multi-region, all of Linear’s infrastructure was manually managed in Google Cloud Platform. While we could have continued doing this, moving to infrastructure as code (in our case, Terraform) made spinning up a second region a lot easier.

We used Google Cloud’s [Terraform export tooling](https://cloud.google.com/docs/terraform/resource-management/export) to create an initial set of Terraform resources for our existing infrastructure. We removed everything that we knew we didn’t need for our main application to be deployed through Terraform: this was typically either resources that we hadn’t created manually in the first place, or global resources that wouldn’t be affected by the move to multi-region Linear.

Once we had the exported resources in place, we refactored the Terraform code into [modules](https://developer.hashicorp.com/terraform/language/modules) to support passing in the target region as a variable, as well as managing region-specific credentials and secrets that the application needs. We used this to build a staging environment too, which we used for testing infrastructure changes, as well as the proxy’s routing logic.

### **Extracting the authentication service**[⁠](https://linear.app/now/how-we-built-multi-region-support-for-linear.html#extracting-the-authentication-service)

The proxy needed a way of routing network requests to the correct region based on the information contained within these requests. For this, we created a global authentication service, which would know about all user accounts, workspaces, and their associations. The auth service would be able to authenticate user accounts and work out the region of the workspace that the request was sent to.

To keep things as simple as possible, we chose to have a one-way data flow between the regional backend services and the authentication service. A regional service can call the authentication service directly, but if the authentication service wants a regional service to take an action, it schedules a background task using the [Google Pub/Sub one-to-many pattern](https://cloud.google.com/pubsub/docs/pubsub-basics#choose_a_publish_and_subscribe_pattern) to run that task on all regions. This also means that the authentication service only responds to HTTP requests–it has no background task runner of its own–making deployment more straightforward. Even so, this was by far the largest step in the project, touching large parts of our codebase.

After prototyping a few different options for the internal API between the API service and the authentication service, we settled on GraphQL. It isn’t ideal for service to service communication, but we already had strong tooling for GraphQL in our codebase ([our public API](https://developers.linear.app/docs) is GraphQL), and we used [Zeus](https://graphqleditor.com/docs/tools/zeus/) to generate a type-safe client for the API service to call the authentication service.

As we wanted to extract this gradually, the authentication service shares a database with the main backend service in our US region - which was the only region while we were working on this. When the logic was fully extracted, we split the tables from the authentication service and the other backend services into their own schemas, and set database permissions to guarantee that the authentication service cannot read or write regional data in the database, and vice versa: they must go via the calling conventions described above.

Most existing tables had a single owner. For instance, documents are only on the regional databases, as they are not needed for authentication. Some, however, needed to be split between the two services as they contained both application information as well as authentication information. For example, most workspace information and configuration is in the regional service, but some workspace settings relate to authentication, so the authentication service needs to store its own copy of that data. This means that we have pairs of tables in the authentication service and the regional services that have a 1:1 relationship: their data should always be in sync for shared fields, and we should never have a case where one system has a record but the other doesn’t.

To handle the data sync between the two systems, we settled on a mix of patterns that fit neatly into our existing codebase and conventions. There were three cases we needed to cover: creating, deleting, and updating records.

* When creating a shared record, we always create it in the authentication service first, and use the returned ID to create a corresponding record in the regional database. This is to ensure that any uniqueness constraints (such as on a workspace’s URL key) are applied globally first.
* Deleting works in the same way as creating records, with an additional fallback using Postgres triggers to create an audit log of deleted records, which accounts for records that are deleted due to a foreign key cascade from another table.
* For updating records, we already have a lot of logic around creating efficient updates for clients using our sync engine. We were able to reuse this to also schedule an asynchronous update to the authentication service with the new data, so that updates are easiest for developers: they just update the record in the regional service as normal.

To extract this in a gradual way, we first created the new tables with database triggers to copy over the columns we needed on create and update. This worked because we had a single region at the time, so we could allow the database users for each service to see each other’s tables, while using linting rules to ensure that our application code did not reach across service boundaries. Once we confirmed the syncing logic was working, we deleted the triggers and relied solely on the methods described above, even while still running in a single region.

Finally, we created a set of background tasks that would periodically walk through all tables that are synced with the authentication service. These tasks fetch a batch of records in the regional service, and use an internal API call to check that the authentication service has the corresponding batch of records, with no missing records on either side or differences in column values.

### **Routing requests and putting it all together**[⁠](https://linear.app/now/how-we-built-multi-region-support-for-linear.html#routing-requests-and-putting-it-all-together)

Since we already use Cloudflare Workers extensively, it was an easy decision to also use Cloudflare Workers for the proxy that routes requests. The worker extracts the relevant authentication information from a request, calls the authentication service to obtain a signed JWT and the target region, and then forwards the request to that region with the pre-signed header.

The Cloudflare Worker securely caches authentication signatures so that frequent requests from the same client don’t need to spend time on the round-trip between the Cloudflare worker and the authentication service, and instead the request can be directly routed to the correct region.

That is, our request flow went from users connecting directly to our API servers…

![A flowchart visualizing the request flow from users connecting directly to Linear's API servers](https://webassets.linear.app/images/ornj730p/production/62107588d373e5fd63658c7120bb0961b5c61490-2352x1204.png?q=95&auto=format&dpr=2)

![A flowchart visualizing the request flow from users connecting directly to Linear's API servers](https://webassets.linear.app/images/ornj730p/production/7cfb205f850812ae49aeaa650c6b51efce045758-2352x1204.png?q=95&auto=format&dpr=2)

…to having this proxy in between:

![A flow chart of the new request flow](https://webassets.linear.app/images/ornj730p/production/56b127f326e60fc7f3197ed583c4a8ed684ed4b4-2352x1880.png?q=95&auto=format&dpr=2)

![A flow chart of the new request flow](https://webassets.linear.app/images/ornj730p/production/4d2f1e274334d9edbd28feaca70fbba9fbca4508-2352x1880.png?q=95&auto=format&dpr=2)

Using Cloudflare Workers as a proxy like this is effective, even for long-running requests, because Cloudflare Workers that return a `fetch` request without modifying the response [hand off to a more efficient code path](https://blog.cloudflare.com/workers-optimization-reduces-your-bill). Linear uses WebSockets for our [realtime sync](https://linear.app/docs/offline-mode), and so this is an important factor for us.

While we were building the authentication service, we were still using a single region, so we kept fallback code in our API service to authenticate the request directly if it was not pre-signed by the authentication service. Once we had the initial proxy in place, the rest of the work here was largely straightforward: logging and fixing requests that used this fallback, working through our existing [library of integrations](https://linear.app/integrations.html) and adding code to handle each one in the API router, and ensuring internal tools could read from or write to both regions as necessary.

We rolled out a region selector that lets you choose what region to host new workspaces in, gated by a feature flag. This flag was initially available only to Linear engineers. Once we confirmed that the new region functioned without any problems, we gradually allowed everyone to create workspaces in the new region.

## **Wrapping up**[⁠](https://linear.app/now/how-we-built-multi-region-support-for-linear.html#wrapping-up)

This was a lot of work behind the scenes, and it touched authentication logic, which is always a sensitive part of any codebase. We built it in such a way that while there were of course bugs along the way, most of those were invisible to our users because we left the hard cut-overs as late as possible, making sure we had a fallback in place until we were confident that we had covered every corner case.

Linear now supports creating new workspaces in our European region. We set the default region in the workspace creation form based on your system timezone, to give the best experience for most people, while still allowing you to choose the region yourself. Workspaces in Europe have access to all Linear features, and always will.

We intend on adding support for existing workspaces that want to move to a different region later this year.

–

If you like how we build, [apply to join our team](https://linear.app/careers.html). We’re hiring for backend and fullstack engineering roles.

[Sean McGivern](https://linear.app/now/author/smcgivern) and [Tuomas Artman](https://linear.app/now/author/tuomas-artman.html)·May 23, 2024

Copy link
