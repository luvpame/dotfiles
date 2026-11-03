---
title: "Post mortem on Linear security incident on March 24th, 2026"
source_url: "https://linear.app/now/linear-incident-on-mar-24th-2026"
fetched_at: "2026-10-27T08:17:41.028425+00:00"
---



1. [Now](https://linear.app/now.html)
2. [From the team](https://linear.app/now/team.html)

# Post mortem on Linear security incident on March 24th, 2026

![Linear logo on a dark background inside a rounded square outline, with an orange alert icon containing an exclamation mark at the top-right corner](https://webassets.linear.app/images/ornj730p/production/c655370e49ac8a5eb488799587c08b6a64a68038-3904x1440.png?q=95&auto=format&dpr=2)

![Linear logo on a dark background inside a rounded square outline, with an orange alert icon containing an exclamation mark at the top-right corner](https://webassets.linear.app/images/ornj730p/production/a285a53604910d6b5f117b666742ec0cfe01c008-2352x1280.png?q=95&auto=format&dpr=2)

[Jamie Finnigan](https://linear.app/now/author/jamie-finnigan.html)·April 06, 2026

On Tuesday March 24, a code change we deployed caused data from private teams to be accessible to other members within the same workspace. During a window of approximately one hour, 12:07am through 1:10am UTC, workspace members, including guest users, may have had access to data outside their normal team permissions. The issue was identified, code change reverted, and affected client sessions cleared within hours of detection.

We notified the owners/admins of affected workspaces by email on Thursday, March 26.

We’re sorry this happened. Private teams and guest roles exist so that sensitive work stays visible only to authorized members, and we failed to uphold that boundary.

Below is a timeline of the incident, more detail around its cause, and the steps we’ve taken and intend to take.

### Incident timeline[⁠](https://linear.app/now/linear-incident-on-mar-24th-2026.html#incident-timeline)

*All times are in Coordinated Universal Time (UTC)*

**March 24**

* 00:07: Code change deployed to production.
* 01:10: Initial subset of exposure identified, code change reverted, and rollback deployed.
* 01:30: Server side cache reset and database version incremented, forcing client cache reset.
* 01:40: Customer report of notification email with excessive content.
* 01:45: Incident channel opened.
* 03:13: Mobile clients active during the window logged out, forcing cache reset.
* 03:23: Web and desktop clients forced to clear cache with reload.
* 04:02: [Status page incident](https://linearstatus.com/incidents/01KMF04EBVAP7BKFWBX0QSGYW8) published.
* 05:04: Auto-generated Pulse feed posts created during the window deleted as a precaution.

**March 25**

*Data gathering and analysis efforts to understand per-workspace exposure continued.*

* 23:45: Email notification sent to all affected workspace contacts.
* 23:47: Status page incident marked as resolved.

**March 27**

*Analysis efforts to understand per-workspace exposure continued.*

* 21:30: Began sending per-workspace exposure summaries to customers who requested additional detail.

### What happened[⁠](https://linear.app/now/linear-incident-on-mar-24th-2026.html#what-happened)

Linear’s access control layer uses an internal “sync group” mechanism to determine which data each workspace member can access. When a query is executed—whether via the web client, mobile app, or API—sync group resolvers add permission filters to ensure users only see data from teams they belong to.

A performance optimization attempted to skip sync group resolvers that could never match a given user’s permissions. The optimization was gated to run only for a single internal workspace in production, with the intent to validate before broader rollout. However, the code that disabled the optimization for all other workspaces contained a variable shadowing bug: instead of falling back to the original unfiltered resolvers, it omitted all user specific resolvers.

This caused the downstream permission check to be skipped entirely; rather than raising an error, queries silently returned results without team-level filtering.

The change was tested and peer-reviewed. Our existing test coverage validated that the optimization worked correctly when active, but did not cover the codepath where it was disabled for non-target workspaces. This is the gap that allowed the regression to reach production.

This change was written and reviewed by engineers without AI assistance. While we use AI extensively in our development workflow, the root cause here was a variable shadowing bug in a code path that was peer-reviewed and tested. The gap was in test coverage, not in the authoring process.

### What was affected[⁠](https://linear.app/now/linear-incident-on-mar-24th-2026.html#what-was-affected)

No data was exposed to anyone outside each workspace. No credentials, API keys, or authentication tokens were exposed.

During the window, data from private teams may have been exposed to other workspace members, including:

* Issues, comments, and attachments
* Projects, documents, and related entities

Private teams did not appear in the Linear web or desktop app interface directly.

The exposure was primarily through:

**Notification emails**: Digest emails sent to workspace members during the window may have contained inflated unread counts and details of activity from private teams. The notification system, operating under the broken permissions, generated notifications spanning team boundaries. In some workspaces, a single member received a digest containing notifications for the entire workspace.

**Web and desktop client data sync**: Approximately 7,000 full client bootstraps occurred during the window. Users who synced may have temporarily had data from private teams in their local client database, though this data was not surfaced in the app interface. All clients were force-reloaded during remediation to clear cached data.

**Mobile app**: Mobile sessions active during the window may have had access to data from private teams via in-app functionality. All mobile sessions active during the window were logged out. Pulse feed content that may have contained cross-boundary data was deleted.

**API and third-party integrations**: OAuth apps and API keys made requests during the window that may have received responses containing data from private teams, depending on the scope of each integration’s queries. Integrations that query specific issues or teams they already have access to would not have been affected, while those making broader queries may have received data beyond their normal permissions. API access was restored to normal permissions when the code change was reverted.

**Background tasks**: Several server-side tasks that operate with user context were affected. The notification pruning task incorrectly archived notifications at the workspace level instead of per-user, and the feed summary generator produced posts with cross-boundary data. Incorrectly archived notifications were restored, and affected feed posts were deleted.

Our post-incident audit of sensitive mutations—team membership changes, role changes, and workspace invitations—across all affected workspaces found no evidence of malicious abuse.

### Our response[⁠](https://linear.app/now/linear-incident-on-mar-24th-2026.html#our-response)

Following identification of the issue, we completed an initial set of remediation activities:

* Reverted the code change within one hour of deployment
* Force-reloaded all desktop and web clients to clear cached data
* Logged out all mobile sessions active during the window
* Conducted an audit of access and modification logs for affected workspaces

We notified affected workspace contacts within 48 hours of the incident. For customers who requested additional detail, we provided per-workspace exposure summaries covering activity associated with each exposure vector during the window.

### Next steps and improvements[⁠](https://linear.app/now/linear-incident-on-mar-24th-2026.html#next-steps-and-improvements)

This incident revealed gaps in how we validate and deploy changes to our access control layer. We’ve already made the following changes:

* Expanded integration test coverage that validates permission boundaries across deployment environments, team types, user roles, guest access, and authentication methods.
* Implemented limits to cap the number of notification items rendered in a single digest email.

Additional followup tasks we will prioritize are:

* Tighten enforcement of pre-deployment security review, by human and agent, for any changes to authorization-related code paths.
* Improve operational monitoring for anomalous authorization layer behavior and permission boundary violations.
* Extend internal logging system to provide a higher level of visibility into workspace related events.
* Allow workspace admins / owners to configure specific security contacts for future notifications.
* Document incident data collection process to enable faster analysis in future incidents.

We take the trust our customers place in us seriously, and we’re committed to the actions above and continued transparency in our incident response.

[Jamie Finnigan](https://linear.app/now/author/jamie-finnigan.html)·April 06, 2026

Copy link
