---
title: "Post mortem on Linear incident from Jan 24th, 2024 | Linear"
source_url: "https://linear.app/now/linear-incident-on-jan-24th-2024"
fetched_at: "2026-10-27T08:17:41.028425+00:00"
---



1. [Now](https://linear.app/now.html)
2. [From the team](https://linear.app/now/team.html)

# Post mortem on Linear incident from Jan 24th, 2024

![The linear logo with a warning sign](https://webassets.linear.app/images/ornj730p/production/2e281ae34028ff175a63af027de95bca66b9bcb1-2056x944.png?q=95&auto=format&dpr=2)

![The linear logo with a warning sign](https://webassets.linear.app/images/ornj730p/production/e078697b78690170e26ec6ed13fd77483d5269c4-2056x944.png?q=95&auto=format&dpr=2)

[Jori Lallo](https://linear.app/now/author/jorilallo) and 2 others·January 30, 2024

On Wednesday January 24, Linear experienced a temporary [data loss incident](https://linearstatus.com/incidents/01HMX98N26X50PZR72156MN1F4) from 04:47 to 09:56 UTC (about five hours) due to restoration from backup. This affected workspaces that made changes during this window or updated via automated processes (e.g. cycle automation), especially those in the EU due to the timing.

As part of the disaster recovery process, we took Linear offline for one hour, impacting all users. We restored over 99% of lost data within 36h of the start of the incident. But, in some cases we couldn’t restore data due to conflicts.

A database migration caused the incident, which accidentally deleted data from production servers. We put Linear into maintenance mode and reverted the database to a backup taken a few hours prior. We immediately began restoring missing data, which took two days to complete.

We’re deeply sorry for the inconvenience and frustration this incident caused for our customers. Reliability and security are top priorities for us at Linear and last week we fell short from our promise to our users and ourselves. In learning from this incident, we’ll improve our tools and processes to prevent such mistakes and recover more quickly.

Below is a timeline of the incident, and more details around its cause and the ultimate fix.

## **Incident timeline**[⁠](https://linear.app/now/linear-incident-on-jan-24th-2024.html#incident-timeline)

*All times are in Coordinated Universal Time (UTC)*

### **January 24**[⁠](https://linear.app/now/linear-incident-on-jan-24th-2024.html#january-24)

* **04:47**: Full database backup completed (pre-incident).
* **07:01**: Merge of migration that caused data loss.
* **07:20**: Migration completed.
* **07:52**: Strange notifications noticed in the app, engineering and support notified to check other reports.
* **08:10**: Critical incident initiated with Zoom call to investigate, additional engineers paged.
* **08:36**: Update posted to Linear status page and shared on X: “[Investigating data access issues](https://x.com/linear/status/1750074910456602761?s=20)“
* **09:20**: Additional update posted on Linear [status site](https://linearstatus.com/).
* **09:56**: Linear put in maintenance mode to prevent further changes and recover from backup.
* **10:48**: Linear access restored with the database backup from 04:47.
* **11:09**: Status site updated to monitoring.
* **11:30**: Restoration started for all data entered between 04:47 and 09:56.
* **13:50**: Emails sent to customers who had created workspaces between 04:47 and 09:56 asking them to recreate their workspace as we could not rebuild it.
* **15:35**: Emails sent to affected users and workspace administrators with information about the incident and restoration process.

### **January 25**[⁠](https://linear.app/now/linear-incident-on-jan-24th-2024.html#january-25)

* **14:00**: Data recovery page published to application settings and shared with admins via email.
* **14:25**: Bug fixed with the data recovery page by forcing clients to refresh (which then overloaded our API and caused application loading issues).
* **16:40**: Dry-runs of the restoration process started.
* **17:49**: Workspace data restoration started.
* **19:48**: 98% of affected workspaces restored.
* **23:20**: 99% of affected workspaces restored.

### **January 26**[⁠](https://linear.app/now/linear-incident-on-jan-24th-2024.html#january-26)

* **07:37**: Restoration for all workspaces except one completed.
* **08:39**: Restoration of final workspace completed.

## **What happened**[⁠](https://linear.app/now/linear-incident-on-jan-24th-2024.html#what-happened)

Linear uses trunk-based development and changes land in production on an ongoing basis as part of new feature development. We gate execution using feature flags.

While developing new features, we created two new tables in the production database. We also filled these tables with data from existing tables in preparation for rolling out the new functionality. We considered the data faulty and planned a new migration to update it. We had to drop the existing data in the new tables as part of that migration.

A pull request was created, reviewed and accepted that added a database migration that first dropped data in the new tables. Then, it copied data from existing tables to the new ones. The new tables were only used by engineers developing the feature and not used by actual users yet, so we deemed deletion safe. We used the following SQL statement for data deletion:

`TRUNCATE TABLE <new_table> CASCADE;`

The intention here was to delete any data in the new table as well as any rows of test data with foreign keys pointing to the new table. However, `CASCADE` simply truncates the entire contents of any tables that have foreign keys to the table.

This caused the full deletion of production data for issue and document descriptions, comments, notifications, favorites, and reactions.

When pull requests include migration, we do include CI warnings for dangerous migrations, like large indexing operations. The pull request was tested locally and reviewed by multiple engineers but the cascade operation was missed by both author and peer reviewers.

## **Outage and investigation**[⁠](https://linear.app/now/linear-incident-on-jan-24th-2024.html#outage-and-investigation)

With the data deleted, symptoms weren’t immediately visible to end-users, including our own team. Linear stores most workspace data in a local client cache, and there’s also a database cache which sits in front of the Postgres database. Our [sync engine](https://linear.app/blog/scaling-the-linear-sync-engine.html) updates this database cache programmatically to add and remove “sync” packets describing database mutations.

As this is part of the application logic, deleting rows directly from the database won’t create sync packets and thus won’t update the cache or clients. This meant users would continue to see and receive data for the deleted tables in the Postgres database until they reloaded their local data and the backend cache was invalidated, which usually takes 24 hours. Data caching was also one of the primary reasons the problem was missed in local development.

The data loss went unnoticed for 30 minutes due to the multiple layers of cache involved. It was possible to reload the Linear client and not see any visible problems at all. Only mutations caused errors due to underlying database entities no longer existing.

The outage first became apparent with notifications, as it is one of our most frequently updated tables, with notifications created and deleted based on many events. There is always a small lag in synchronization state between the backend and its clients. We often see the client trying to update deleted entities and see these as a *synchronization lag* warning. As an expected part of the system these did not count towards error metrics or trigger alert monitors.

An engineer started an internal incident to investigate when they saw problems while using their own notification inbox. User reports confirmed the synchronization issues that the problems pointed to. This happened around 30 minutes after the migration. This caused a critical incident to start and personnel to be paged.

The cause wasn’t clear at first due to the caching. But, a spike in warnings from clients to the *notificationUpdate* GraphQL endpoint offered a clue about when the problem started. The faulty commit was quickly correlated. Our engineers verified that the commit did cause similar symptoms when run locally. Shortly thereafter, an engineer found all notifications had been deleted in their local database. At this point, production data was checked and we found multiple tables had been entirely deleted.

Linear was promptly taken into maintenance mode, which blocks any updates and presents a maintenance screen for all users. We created a new backup to capture all the sync packets created up until that point. Then the database was restored from the latest backup from before the faulty migration ran.

Linear takes daily full backups in addition to having point-in-time recovery. The last backup was taken at 04:47 UTC and the bad commit landed at 07:01 UTC. With point-in-time recovery engineering could have restored services to the state they were in at 07:01. However, the engineering team had never tested point-in-time recovery, nor had engineering developed tooling to quickly restore the database using point-in-time recovery, so that option wasn’t considered. Restoring from a full backup was a frequently tested procedure and thus executed to get the application up and running as quickly as possible, while initially losing more data than point-in-time recovery.

After backup restoration was completed, Linear was brought back online again with data as of the 04:47 UTC backup.

The service recovered somewhat quickly, with intermittent problems affecting synchronization. The sync service uses a cursor to get changes not yet sent to clients and caches this cursor in Redis. However, the code did not account for the ID moving backwards, as was the case with a full database restore. Resetting the cache and restarting the sync service resolved these issues.

## **Data restoration**[⁠](https://linear.app/now/linear-incident-on-jan-24th-2024.html#data-restoration)

After Linear was back online, our engineering team started restoring data that was affected by the rollback.

As mentioned earlier, Linear’s realtime sync engine keeps a log of every change that affects entities and properties in a form of sync packet (“action”) that is sent to clients. This includes the type of action taken (insert, update, archive, delete), a snapshot of the entire entity after the change, and a delta of properties changed in case of an update action. Each change also contains an actor, usually the user that made the change.

We used these actions to find all users affected by changes in the outage. We then contacted them to tell them about the problem and when data would be restored. We also sent an email to all administrators of the affected workspaces in the interest of transparency and awareness.

Part of our team implemented a new settings page to show administrators the progress of the restoration procedure.This page also listed any lost data and errors during restoration so they could then fix their data, if needed.

At the same time, we added a restoration script to run through the lost actions for each workspace. It reapplied the actions by users, integrations, API calls, and Linear automations. The script was first executed as a dry-run to expose and fix any edge cases in the replaying of these changes. When a workspace didn’t have any errors in the dry-run, recovery was run for it. We investigated workspaces that had errors to see if we could fix them.

Due to the large number of affected workspaces, this investigation took the majority of the recovery time. Some actions were unrecoverable because of unresolvable conflicts and were listed in the individual workspace’s recovery page. Most of the errors revolved around:

* **Document content already existed:** This meant the description for an issue or document had been recently created. We did not want to override changes made by users.
* **User created:** Users created during the outage were not recovered as we had no way to tie them back to an authentication. Ultimately, all the actions involving a new user (e.g. being assigned to an issue) and issues created by these new users were skipped as well.
* **Modifications to entities no longer existed:** If an update for an entity was archived or deleted, those updates were skipped.

We also excluded some objects from recovery entirely, such as integrations allowed to act in Linear on behalf of a workspace. We did not want to bring these back automatically after this delay. Instead, we chose to let users reconnect any missing integrations themselves. Similarly, we did not recover newly-created workspaces. Instead, we sent the workspace administrators an email telling them about the situation.

## **Impact**[⁠](https://linear.app/now/linear-incident-on-jan-24th-2024.html#impact)

All users experienced one hour of platform downtime while the backup restored data.

In all, 12% of workspaces had data that was unavailable until the restoration finished. Another 7% had automated changes (like generated Cycles) that were also unavailable.

We restored over 99% of data within 36 hours. The remaining 4,136 sync packets for unresolvable conflicts represent an average of 0.44 per workspace.

## **Next steps and improvements**[⁠](https://linear.app/now/linear-incident-on-jan-24th-2024.html#next-steps-and-improvements)

This incident was the largest in Linear’s five-year history. We strive to build the fastest and most reliable product for our users. This incident revealed many areas where we can do better to find, stop, and recover from similar outages. We learned important lessons from the outage, which we’ll be making actionable in the coming weeks and months. We’ve listed some of the changes we’ll implement below, with more to come as we continue assessing our response:

* No user on the production databases should have `TRUNCATE` privileges.
* Improve how migrations are created and applied to the database. This includes better review practices from database admins—separate from code reviews—and linting of dangerous operations.
* Make testing of database migrations in a staging environment easier and automated to reduce friction.
* Create and test tooling to quickly re-create the database from point-in-time backups.
* Various changes to internal tooling, addressing weaknesses or friction uncovered by the incident response.
* Improved monitors for data integrity.
* Implement the ability to turn on a read-only mode for Linear, so that clients have read access even when no changes are allowed to reduce the effects of downtime.

Again, we’re extremely sorry that this outage happened and it has involved most of our engineering team over the past week to resolve. We’ll keep working to improve as a team and to commit to a high level of transparency around our incident response, both during and after.

[Jori Lallo](https://linear.app/now/author/jorilallo) and 2 others·January 30, 2024

Copy link
