---
title: "Web forms for Linear Asks – Changelog"
source_url: "https://linear.app/changelog/2026-04-02-web-forms-for-linear-asks"
fetched_at: "2026-10-27T08:17:41.028425+00:00"
---



[Changelog](https://linear.app/changelog.html)

[April 2, 2026](https://linear.app/changelog/2026-04-02-web-forms-for-linear-asks.html) Share

[## Web forms for Linear Asks](https://linear.app/changelog/2026-04-02-web-forms-for-linear-asks.html)

![Hero image showing web connecting to Asks connecting to Linear](https://webassets.linear.app/images/ornj730p/production/7947ca43dbce4368c7e039537cf1ba7c0f4ca3a9-3600x1800.png?q=95&auto=format&dpr=2)

[Linear Asks](https://linear.app/features/asks.html) allows you to capture internal requests and bring them into Linear so the appropriate team can work on them. Previously, we’ve enabled intake through Slack and email.

Now we’ve added custom web forms as well.

Teams can create a dedicated Asks page with forms for the types of requests they handle, like feature requests, bug reports, data pulls, or HR and IT tasks. Forms are powered by issue templates, so teams control exactly what information gets collected. Every submission becomes an issue in the team’s triage inbox, where it can be fielded by a team member or routed with [Triage Intelligence](https://linear.app/docs/product-intelligence.html).

Anyone in your company can create an ask, even if they don’t have a Linear account. After submitting an ask, submitters can follow up through a synced email thread on the issue.

![laptop request web form ](https://webassets.linear.app/images/ornj730p/production/c72160def314dd9ba1730a91cb95aee4f5da5f08-3600x2400.png?q=95&auto=format&dpr=2)

Web forms for Linear Asks are available on the Enterprise plan. Learn more in our [documentation](https://linear.app/docs/linear-asks.html#web-forms).

Fixes

* Agent

  Fixed “Ask Linear” and history buttons highlighting when the agent toolbar is right-clicked
* Agent

  Fixed agent chat prompt clearing when navigating to settings pages
* Agent

  Fixed slow UI responses when agent chat is streaming
* Agent automations

  Fixed a bug where the agent triage automation editor could lose the input if the rule failed to save
* Agent Session

  Fixed long file paths overflowing in agent activity tooltips
* Asks

  Preserved original Slack rich text formatting from Slack Asks forms
* Code Reviews

  Fixed Swift raw/extended string literals (`#"..."#`) breaking syntax highlighting for the remainder of the file
* Date fields

  Fixed date picker not respecting the user’s locale when entering a date without a year (e.g. 05/06 would always resolve to May 6th)
* Documents

  Fixed duplicate favorite action showing when viewing a project document
* Editor

  Fixed the toggle checklist keyboard shortcut (`Alt/Option` `Enter`) which had been incorrectly changed to `Cmd/Ctrl` `Enter`
* Editor

  Stopped collapsed code blocks from automatically expanding after refocusing an issue page
* Editor

  Fixed entity mention icons not updating in real-time when changed by another user
* Editor

  Fixed text formatting dropdown appearing detached and at the wrong z-index when editing sub-issue descriptions
* Editor

  Fixed pasting screenshots into editors not auto-scrolling to reveal the pasted content
* Favorites

  Fixed favoriting an Initiative’s Update tab incorrectly taking you to the Projects tab
* Focus

  Fixed breadcrumb in the Focus tab showing misleading parent/sub-issue hierarchy when navigating between issues
* GitLab

  Fixed an issue where merging a GitLab MR could move the linked issue backwards in status automations instead of staying in “Done”
* Inbox

  Fixed notification type filters in inbox
* Inbox

  Anchor links in document comments now correctly navigate to the linked section when opening from Inbox
* Inbox

  Fixed inbox project filter sometimes not showing any projects
* Inbox

  Changed empty state to fill the whole width of the inbox view
* Initiatives

  Fixed initiative filtering showing unrelated parent initiatives when sub-initiatives have multiple parents
* Integrations

  Fixed flickering when navigating to an already installed external integration page
* Issue Activity

  Fixed issue activity section rendering empty initially and history entries popping in with layout shifts when navigating between issues
* Issues

  Fixed missing left padding on delegation pill in issue list views
* Issues

  Fixed business-day issue SLAs so weekend-created issues expired at the next working-day boundary
* Issues

  Hovering over actor names of issue history entries now shows a popover
* List

  Fixed missing padding on the selected items count badge shown in collapsed group headers
* OAuth

  Fixed authorize button being disabled when auto-submit form is unavailable
* OAuth

  Fixed the Authorize button being disabled for users in workspaces where another user had already authorized the OAuth app with `prompt=consent`
* Projects

  Fixed the “Away” badge not showing in multiple users’ popovers (e.g. project members)
* Projects

  Fixed project health grouping to correctly place projects with “never” update schedule and non-active projects with stale health in the “No update expected” group
* Projects

  Project update reminders are no longer sent for deleted projects
* Project Updates

  Creating an issue from a project update now properly adds that issue to the project
* Project Updates

  Fixed project update mentions showing project preview instead of update preview
* Settings

  Fixed team settings workflows and automations page layout shift on initial load
* Shortcuts

  Added `O` + `V` command to the shortcuts list in the `?` menu. This shortcut was previously functional but not listed.
* Sidebar

  Fixed collapsed teams in the sidebar auto-expanding when navigating to a team page via command menu or keyboard shortcuts

Improvements

* Agent

  Linear Agent can now reorganize issue and project labels
* Agent

  Dragging files anywhere onto the agent chat window now triggers file upload
* Agent

  Chats can now be copied as markdown
* Agent

  Added ability for Linear Agent to delete customers
* Agent

  My Issues, Inbox, Reviews, Pulse, and team views can now be included as context for Linear Agent
* Agent

  Improved the expand/minimize arrow icons in the agent chat window for clearer iconography
* Agent

  Improved recognition of natural-language delegation prompts in Slack (e.g. “@Linear work on this”, “@Linear go”)
* Asks

  Updated “Reconnect” copy in Slack and Asks settings to say “Update connection”, as integration is still connected when this displays
* Custom Views

  Added “Show sub-team issues” toggle to custom view display settings when the view is associated with at least one team with sub-teams
* Deeplinks to AI coding tools

  Run a custom local script when opening issues in coding tools. Enable this behavior in [preferences](https://linear.app/settings/account/preferences/coding-tools.html).
* Deeplinks to AI coding tools

  “Copy as prompt” now respects the “move issue to started status” preference, matching the existing open-in-coding-tool behavior
* Desktop

  Desktop redirect interstitial now shows a countdown before closing
* Drafts

  Drafts page cards now have a subtle shadow for better visual separation
* Editor

  Code block controls are now hidden when text is being selected
* Editor

  Improved and unified mention styling
* GitHub

  “Implements” is now a magic word for GitHub PR descriptions, matching the behavior of “closes,” “fixes,” and “resolves”
* Guests

  Guest users now see a “Guest” badge on their hover card, making their role clearly visible
* Inbox

  You can now make Inbox sidebar smaller, the minimum width is now 300px instead of 350px
* Inbox

  Added “Mark all as read” to the inbox sidebar right-click menu
* Jira Sync

  New Jira sync unidirectional links to sync property changes back to Jira
* Jira Sync

  Added the ability to manually link a Jira epic to a project, enabling sync for projects that weren’t automatically linked
* Settings

  Updated agent automations description to clarify triage-only scope
* Slack

  Arrow sequences (`->`, `-->`, `<-`, `<--`) in Slack notifications are now rendered as `→` / `←`
* Teams

  Improved retired banner copy to “Team retired — [model] is read-only” for clarity
* Triage

  Added “Show triage issues” toggle to issue list display settings on team, project, and My Issues screens
* Videos

  Added “Copy link at timestamp” to the video context menu. Pasting the copied link embeds the video starting at the referenced timestamp

MCP server

* Fixed MCP OAuth flow hanging on the redirect page for non-Safari browsers
* Fixed MCP OAuth flow failing when the callback probe consumed the authorization code before browser navigation
* Added support for removing issue relationships
* Updated ChatGPT app client ID for search and fetch tools
* Added `trashed` field to `list_projects` and `get_project` responses so consumers can identify soft-deleted projects

API

* Added `parentId` filter to issue subscriptions
