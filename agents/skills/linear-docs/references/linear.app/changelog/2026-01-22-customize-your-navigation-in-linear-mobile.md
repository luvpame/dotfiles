---
title: "Customize your navigation in Linear Mobile – Changelog"
source_url: "https://linear.app/changelog/2026-01-22-customize-your-navigation-in-linear-mobile"
fetched_at: "2026-10-27T08:17:41.028425+00:00"
---



[Changelog](https://linear.app/changelog.html)

[January 22, 2026](https://linear.app/changelog/2026-01-22-customize-your-navigation-in-linear-mobile.html) Share

[## Customize your navigation in Linear Mobile](https://linear.app/changelog/2026-01-22-customize-your-navigation-in-linear-mobile.html)

![Close-up of a smartphone showing the Linear app interface, with a blurred list of projects and navigation icons along the bottom.](https://webassets.linear.app/images/ornj730p/production/f03b86242bef863719b8e15a1e45344640afb297-3600x2080.png?q=95&auto=format&dpr=2)

Now you can customize Linear Mobile to fit your daily workflow.

Personalize the bottom toolbar to prioritize the features you use the most. Rearrange the main navigation items, or pin specific projects, initiatives, and documents for quick access. For example, you can choose Pulse to stay up to date with work across your teams, or My issues to manage your assigned tasks.

![Linear mobile app showing the “Pinned” menu, with Inbox, Pulse, and Initiatives pinned at the top, plus Edit and Close buttons.](https://webassets.linear.app/images/ornj730p/production/69d970eccd5514ebee12553d36414f9b4f23366c-3600x2360.png?q=95&auto=format&dpr=2)

To pin specific projects, initiatives, or documents, open the item and use the **•••** menu in the top-right.

![Linear mobile project screen with an options menu open, showing actions like Favorite, Pin to tab bar, Copy link, Edit project, and Delete project.](https://webassets.linear.app/images/ornj730p/production/43ff5cb87d743e2a5bce4f21c5c399778832cf4d-3600x2360.png?q=95&auto=format&dpr=2)

Available today in the [App Store](https://apps.apple.com/app/linear-mobile/id1645587184) and [Play Store](https://play.google.com/store/apps/details?id=app.linear).

## Redesigned timing charts in Insights and Dashboards[⁠](https://linear.app/changelog/2026-01-22-customize-your-navigation-in-linear-mobile.html#redesigned-timing-charts-in-insights-and-dashboards)

Timing charts in Insights and Dashboards have been redesigned to make it easier to spot workflow trends and bottlenecks.

Timing charts now use a logarithmic scale by default so outliers don’t visually flatten the rest of your data. Percentile metrics also display by slice, allowing you to compare across different dimensions or track changes over time. We’ve also removed issue limits to support analysis across much larger datasets.

![Timing chart in Insights depicting lead time over different priority issues](https://webassets.linear.app/images/ornj730p/production/a3c6bbbbb787e1f04ae724e8c2e0a5d1e00934be-3600x1970.png?q=95&auto=format&dpr=2)

## Linear Agent for Slack on all plans[⁠](https://linear.app/changelog/2026-01-22-customize-your-navigation-in-linear-mobile.html#linear-agent-for-slack-on-all-plans)

We’ve made [Linear Agent for Slack](https://linear.app/changelog/2025-10-23-linear-agent-for-slack.html) available on every plan, including Basic and Free. Update your [Slack integration](https://linear.app/settings/integrations/slack.html), then create issues or ask questions by mentioning @Linear in Slack.

## Linear Code Reviews (Private Beta)[⁠](https://linear.app/changelog/2026-01-22-customize-your-navigation-in-linear-mobile.html#linear-code-reviews-(private-beta))

Linear Code Reviews is now available in private beta. We’ve brought code reviews directly into Linear, with support for both traditional PR workflows and agents output.

[Join the waitlist](https://linear.app/reviews.html) to request early access.

Fixes

* Agents

  Fixed Linear agent assigning work to inactive users
* Agents

  Fixed layout shift when loading issue views that have agent sessions
* Agents

  Fixed agent panel content overflowing when agent output contained long inline code strings
* Asks

  Fixed an issue where email auto-replies were incorrectly inheriting the styles of the emails they were replying to
* Boards

  Fixed a blank frame appearing on initial render for boards with swimlanes
* Boards

  Fixed unwanted scrolling when interacting with cards in board views
* Cycles

  Fixed a bug where the tooltips on the cycle progress graph showed the incorrect estimate points for today and tomorrow
* Documents

  Fixed moving documents from issues
* Editor

  Fixed an issue with using arrow keys in mentions menu
* Editor

  Fixed an issue where videos glitched between playing and paused state
* Editor

  Fixed an issue of deleting an issue when undoing the creation of an issue from a selection. The issue will be restored on redo
* Editor

  Fixed several usability problems related to dragging and dropping table columns and rows
* Email Intake

  Fixed an issue where emails with multiple identically named file attachments would only display the first image in Linear issues
* Filters

  Fixed the inline filter not persisting across navigations to issues in view and back
* Icons

  Team icon custom colors now have proper contrast adjustments
* Initiatives

  Fixed the position of comments on the initiative overview page
* Issues

  Fixed resource links to x.com not being correctly labeled “via X”, and the icon not being visible in dark mode
* Issues

  Fixed board drag-and-drop not working correctly when dragging issues into empty rows while ordering by priority
* Jira

  Fixed a bug where Jira integration would not map statuses correctly if the status contained non-ASCII characters
* Lists

  Fixed a bug in the shift + click selection logic
* Lists

  Fixed a bug where dates in project lists could get truncated
* Menus

  Fixed click target for checkboxes in menus with multiselect
* Notifications

  Fixed overly long email subjects for pull request comment notifications
* Project Updates

  Fixed milestone progress showing stale numbers in draft project and initiative updates
* Projects

  Fixed timeline date tooltip appearing in the wrong position after scrolling vertically
* Projects

  Fixed an issue where the deleted project name would remain displayed in the breadcrumb after deleting a project
* Projects

  Fixed project update milestone progress not reflecting actual progress when teams have estimates disabled
* Search

  Fixed project search results rendering
* Settings

  Fixed audit log table overflowing with longer actor emails
* Settings

  Fixed an animation glitch in workflow and project status settings
* Sidebar

  Fixed an issue on macOS where hovering the left edge would repeatedly show and hide the sidebar if the window was against the leftmost screen edge
* Sidebar

  Fixed right-clicking to show hidden items now works between Favorites and Teams
* Slack

  Fixed some labels not being applied on form templates submitted through the Slack integration with a label group field
* Slack

  Fixed some URLs in Linear that formerly rendered incorrectly in Slack
* Tooltip

  Fixed tooltip staying visible when clicking on updates in projects or initiatives list
* UI

  Favorite button color is now properly consistent on hover
* Video Transcription

  Fixed video transcription in documents and projects

API

* Agents

  Improved `AgentSessionEvent` webhooks, making `AgentActivityWebhookPayload`‘s `userId` field no longer nullable
* Agents

  `AgentSession.type` field is now deprecated and will be removed in the future
* OAuth

  Added support for RFC 7009-compliant `token` and `token_type_hint` parameters for the `/oauth/revoke` endpoint. The existing `access_token` and `refresh_token` form fields are now deprecated but remain functional for backward compatibility
* Webhooks

  Included a `user` object (not just `userId`) in the `AgentActivityWebhookPayload`, part of `AgentSessionEvent` webhooks
* Added new `issueRepositorySuggestions` query to get a confidence-ranked list of repos associated with an issue or agent session
* Added `url` field for `AgentSession` in GraphQL API
* Added `issueId` to `documentCreate` and `documentUpdate` inputs
* Added `issueSubGrouping` to the values you can get from view preferences

Improvements

* Agents

  Agent thoughts now take up the full available height of the panel when active
* Android

  Added “Add link” overflow menu action to the issue screen
* Android

  Git branch name can now be copied to clipboard via issue screen top bar overflow menu action
* Cycles

  Added support for documents and links in Cycles
* Docs

  Documentation pages now return Markdown content when requested with `accept:text/markdown` header
* Editor

  Table rows can now be sorted by column
* Initiatives

  When navigating to a sub-initiative, the parent is now displayed as a breadcrumb
* Initiatives

  Projects listed on the initiatives page when viewed from the inbox can now be interacted with
* iOS

  Improved support for displaying sub-team projects when viewing a team’s project list
* iOS

  Added ability to copy the branch name from an issue
* Issue creation

  When creating a new issue, it will now always be placed at the top of the list of issues you’re looking at
* Labels

  Added “Copy link” action to issue and project label pages
* Menus

  Added support for selecting a range of options from a menu with multiselect via click while holding `Shift`
* Menus

  Menus now open under their triggers by default
* Projects

  When sorting by last updated in project views, project updates, milestones, and description changes are now considered updates
* Related

  Capped suggested related issues in the issue sidebar
* Settings

  Added “Leave team” to the contextual menu of team sidebar items and within the “Danger zone” of team settings pages
* Settings

  Webhook signing secrets can now be rotated from settings
* Settings

  Application edit form now scrolls to fields with errors on submit
* Shortcuts

  Improved keyboard shortcut hints highlighting whichever key is pressed
* Sidebar

  Notifications in the sidebar now animate in at the same time, reducing flickering
* Teams

  Team owners can now change parent team
* Timeline

  Project name truncation no longer jumps around when opening a contextual menu in the timeline’s left-hand sidebar
* Views

  The `G``U` keyboard shortcut now displays a command picker allowing you to choose between workspace-level views and team-specific views
* Zendesk

  Improved issue intake to support attachments when Zendesk secure downloads are enabled

MCP server

* Added support for retrieving and managing issue relations (blocking, related, duplicate)
* It is now possible to add and remove projects from initiatives
* Added new tools for `create_document` and `update_document` in a project
