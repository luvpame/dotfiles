---
title: "Priority inbox – Changelog"
source_url: "https://linear.app/changelog/2026-09-03-priority-inbox"
fetched_at: "2026-10-27T08:17:41.028425+00:00"
---



[Changelog](https://linear.app/changelog.html)

[September 3, 2026](https://linear.app/changelog/2026-09-03-priority-inbox.html) Share

[## Priority inbox](https://linear.app/changelog/2026-09-03-priority-inbox.html)

![Linear Inbox in dark mode, showing Priority and Other tabs with several notifications about issue assignments, project updates, comments, and mentions.](https://webassets.linear.app/images/ornj730p/production/8005be22da38ee19e6ac56569976958564d9bbb1-3600x2080.png?q=95&auto=format&dpr=2)

An active workspace can create a significant amount of notifications each day, and until now your inbox treated them all the same. The new **Priority** tab separates what needs your attention from what can wait, so something like a review blocking a release never gets buried.

Linear selects what appears in Priority by default, with the option to customize it by choosing notification sources or creating a filter. You can also continue using the inbox just as you do today.

To get started, open the inbox display options or read the [docs](https://linear.app/docs/inbox.html).

## Draft projects with Linear Agent[⁠](https://linear.app/changelog/2026-09-03-priority-inbox.html#draft-projects-with-linear-agent)

The new project composer lets you develop ideas with Linear Agent before creating a live project. Inside the composer, Linear can pull in relevant context from your workspace and connected tools to sharpen the brief and build out a plan.

Drafts save automatically as you work, so you can return to the draft without losing progress.

Select **Create with Agent** in the project creation page to get started.

![Linear’s AI project-drafting interface creating a “Reliable airport pickups” project, with a live chat panel and project brief fields.](https://webassets.linear.app/images/ornj730p/production/0e436be9125079b223439fcb01d4db5feae680a8-3600x2368.png?q=95&auto=format&dpr=2)

## Document editing on mobile[⁠](https://linear.app/changelog/2026-09-03-priority-inbox.html#document-editing-on-mobile)

Document creation and editing are now available in Linear’s [iOS](https://apps.apple.com/us/app/linear-mobile/id1645587184) and [Android](https://play.google.com/store/apps/details?id=app.linear&hl=en_US&pli=1) apps. Start a doc while the context is fresh, update a plan as it changes, or fix a detail before it sends someone in the wrong direction, without waiting until you’re back at your desk.

## Rich previews in diffs[⁠](https://linear.app/changelog/2026-09-03-priority-inbox.html#rich-previews-in-diffs)

Images, fonts, Markdown, and PDFs now render directly inside Linear diffs. Reviewers can see the output alongside the code and understand what changed without leaving the pull request.

Symlinks are also now supported, shown as file-based changes.

![Code review diff for DRV-2498 showing an updated SVG asset, with removed and added illustration previews side by side.](https://webassets.linear.app/images/ornj730p/production/177687802d38fab3bc19324fc075a82c95b2cd0e-3600x2394.png?q=95&auto=format&dpr=2)

## Third-party app approvals[⁠](https://linear.app/changelog/2026-09-03-priority-inbox.html#third-party-app-approvals)

As more apps and agents connect to your workspace, admins need control over which ones can access company data. Third-party app approvals are now available on paid Linear plans, allowing admins to review and approve apps before they’re installed.

Learn more in the [docs.](https://linear.app/docs/third-party-application-approvals.html)

Fixes

* Agents

  Fixed triage suggestions now showing the team name instead of the key
* Agents

  Fixed an issue where Linear Agent was sometimes not linking a PR to the issue it was generated from
* Asks

  Fixed large inbound emails blocking workflow processing during quote detection
* Desktop

  Fixed an issue where opening documents in the desktop app navigated to their parent
* Diffs

  Reduced request spikes when opening very large pull requests
* Diffs

  Fixed changed lines sometimes missing from pull requests
* Diffs

  Fixed incremental PR Guide updates sometimes dropping unchanged sections
* IOS

  @-mentions now respect the full name display preference in comments and issue descriptions
* Linear Agent

  Fixed agent panel “use as context” button’s tooltip incorrectly formatting entity names like pull request
* Notifications

  Fixed bulk notification actions to show both read-state options when the selection contains read and unread notifications
* Projects

  Fixed the scroll position indicator jumping back to an earlier section while scrolling down a project overview
* Slack

  Fixed issue creation failing after updating fields in the Slack issue form
* Slack

  Fixed synced Slack replies being deleted when an issue is archived
* Teams

  Fixed team settings rejecting an unchanged team identifier that became reserved after it was initially claimed by the team
* Triage

  Fixed cases where future shifts did not appear in triage responsibility when using an external schedule

Improvements

* Accessibility

  Improved accessibility of view display controls
* Asks

  Allowed reordering templates on Asks Web pages
* Command Menu

  Improved command menu to now use fuzzy search
* Desktop

  Added native creation commands, including documents, and made `Cmd/CtrlN` choose what to create from the current view
* Diffs

  Added compact activity updates for running and completed Codex reviews
* Favorites

  You can now add a loop to `Favorites`
* Favorites

  You can now right-click a favorites folder to copy the URLs of all items
* Favorites

  You can now drag items to add them to favorites
* Filters

  Added a “No labels” filter option
* Filters

  Added “My teams” filter value that matches the teams the current user belongs to
* Labels

  Removed the ability for labels to contain emojis
* Linear Agent

  Files dropped anywhere over an Agent chat now attach to the message composer
* Loops

  Notified loop owners when one of their loops is deleted or disabled by someone else
* Loops

  Added support for running scheduled Loops every hour or at custom hourly intervals
* Settings

  Added an option to start SLA timing when an issue is created instead of when it is escalated
* Settings

  Added CSV exports to workspace teams, team members, API keys, and usage history tables
* Settings

  Added support for adding multiple workspace members to one or more teams at once
* Settings

  Added support for selecting workspace members and changing roles, suspending, or activating them in bulk
* Slack

  Accents in Slack always use the color defined for the associated issue status
* Teams

  Added bulk member selection, team owner promotion, demotion, and removal to team member settings
* Workspaces

  Standardized search, filter, and display controls across workspace-level Teams, Members, Loops, and Releases views

Keyboard shortcuts

* Fixed `ShiftCmd/CtrlO` opening sub-issue creation instead of the pull request preview
* Added `O` then `G` to open linked pull requests and synced GitHub issues from issue views

API

* Added the `startMode` field and `SLAStartMode` enum to SLA configuration responses
* Added outbound IP addresses published at https://linear.app/.well-known/appspecific/app.linear.ips.json
