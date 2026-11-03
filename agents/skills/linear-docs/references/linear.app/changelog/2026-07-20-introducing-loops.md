---
title: "Introducing Loops – Changelog"
source_url: "https://linear.app/changelog/2026-07-20-introducing-loops"
fetched_at: "2026-10-27T08:17:41.028425+00:00"
---



[Changelog](https://linear.app/changelog.html)

[July 20, 2026](https://linear.app/changelog/2026-07-20-introducing-loops.html) Share

[## Introducing Loops](https://linear.app/changelog/2026-07-20-introducing-loops.html)

[![](https://webassets.linear.app/images/ornj730p/production/6d18bd62c1abee6e9048418f7553bab34d4c1eda-3840x2160.jpg?q=95&auto=format&dpr=2)](https://webassets.linear.app/files/ornj730p/production/cb230e1a5833081ae9e60f918c92d6db01ed64c4.mp4)

Elapsed00:00Remaining time unknown−--:--

0.25×0.5×0.75×1×1.25×1.5×1.75×2×

Loops are a new way for Linear Agent to take on recurring work for your team.

Describe the job in plain language and then choose whether it should run on a schedule or in response to an event. From there, Loops use context from your workspace and connected tools to decide on the next best action.

For example:

* Review incoming issues, research root causes, and dispatch to coding agents
* Create and coordinate follow-up work based on unstructured notes, like meeting transcripts or incident reports
* Keep launch plans and project specifications up-to-date
* *See more ways to use Loops in the [docs](https://linear.app/docs/loops.html#example-loops)*

[![](https://webassets.linear.app/images/ornj730p/production/f7b4a24a414f8ff6513a45f85978e48684cb3c10-1920x1080.jpg?q=95&auto=format&dpr=2)](https://webassets.linear.app/files/ornj730p/production/7eea0fd4bd8d2f019cb4f846cdb4b57ac444e1a4.mp4)

Elapsed00:00Remaining time unknown−--:--

0.25×0.5×0.75×1×1.25×1.5×1.75×2×

Loops run at the team and workspace level, with shared visibility and control. Anyone with access can review their instructions, see how they are configured, and inspect what happened during each run.

Loops are available today on Business and Enterprise plans and use AI credits. To help you get started and understand usage, we’re giving your workspace $20 per seat in promotional credits. These credits are applied automatically to runs, and expire on August 20, 2026.

Read the [blog post](https://linear.app/now/introducing-loops.html) to learn more.

Fixes

* Android

  Added a fallback page for auth redirects so users can reopen the app when browser handoff fails
* Asks

  Fixed Asks created by mentioning the Asks agent in private Slack channels weren’t syncing the originating thread to the issue
* Cycles

  Fixed archived cycles getting stuck behind persisted label and other view filters with no visible way to clear them
* Diffs

  Pull requests with more than 50 commits now loading up to 450 commits
* Documents

  Private team document templates now consistently appearing in the template selector
* Editor

  Fixed checklists pasted from Google Docs rendering incorrectly
* Email

  Prevented notification emails from being sent to deactivated users
* Inbox

  Fixed email intake issues not appearing in the assignee’s inbox when the intake template auto-assigned the issue back to the sender
* Integrations

  Fixed GitHub Enterprise Cloud installation webhooks routing to the wrong workspace region before the installation was known to Linear
* Integrations

  Fixed GitHub Enterprise Cloud setup showing a generic error when an IP allow list blocked Linear, with clearer guidance on allowing Linear IPs
* Notifications

  Fixed duplicate Slack notifications when a newly created issue is added to a view with Slack notifications enabled
* Projects

  Fixed project pages crashing when a graph tooltip referenced a stale date
* Pulse

  Added an unsubscribe action for Pulse items shown through team project update subscriptions
* Triage Intelligence

  Fixed Triage Intelligence no longer requiring destination teams to have workspace-wide scope to be eligible for suggestions

Improvements

* Agent

  Linear Agent can now manage inbox notifications
* Asks

  Email intake threads can now be resolved and unresolved
* Asks

  Synced comment threads (Slack and Asks) can now be resolved and unresolved, and a new reply reopens a resolved thread
* Comments

  Added inline issue description comments on iOS, including highlights in the description, tap-to-scroll to the thread, and quoted text above description comments
* Desktop

  Added support for Cmd+Z to restore accidentally closed tabs, with timeline-ordered priority and batch restore for bulk close operations
* Diffs

  Added the Diffs inbox as a default home view option
* Diffs

  Improved visibility of auto-merge status in review controls
* Diffs

  Showed failed checks in merge queue removal events
* Diffs

  Showed GitHub force-push events in pull request timelines
* Interface

  Added an Underline links preference under Interface and theme to always underline links in issue descriptions, comments, and documents
* Teams

  Added display options to team member lists for sorting, filtering by member type, and choosing visible columns

MCP server

* Improved attachment uploads to accept base64 payloads with whitespace or `data:` URL prefixes
