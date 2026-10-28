---
title: "Linear MCP for product management – Changelog"
source_url: "https://linear.app/changelog/2026-02-05-linear-mcp-for-product-management"
fetched_at: "2026-10-27T08:17:41.028425+00:00"
---



[Changelog](https://linear.app/changelog.html)

[February 5, 2026](https://linear.app/changelog/2026-02-05-linear-mcp-for-product-management.html) Share

[## Linear MCP for product management](https://linear.app/changelog/2026-02-05-linear-mcp-for-product-management.html)

![A dark, minimalist 3D render of a matte-black rectangular card angled against a black gradient background. The card features a small circular Linear logo cutout near the top-left corner and subtle engraved text near the bottom reading “Linear MCP (Up-grade).” The overall look is sleek, understated, and premium.](https://webassets.linear.app/images/ornj730p/production/5c360813a2a8f0e5ea6d0f5e80ee331b4f4a238f-3600x2080.png?q=95&auto=format&dpr=2)

We’ve expanded Linear’s MCP server with support for initiatives, project milestones, and updates. These allow product managers to keep plans up to date and communicate progress from other tools like Cursor and Claude.

[![](https://webassets.linear.app/images/ornj730p/production/6083ed7813480475810a95d7a7abf3b603e25a79-1920x1440.png?q=95&auto=format&dpr=2)](https://webassets.linear.app/files/ornj730p/production/5a871b88642ddadbd7fa70e797d3119ba0d26e2b.mp4)

Elapsed00:00Remaining time unknown−--:--

0.25×0.5×0.75×1×1.25×1.5×1.75×2×

Newly added MCP tools:

* Create and edit initiatives
* Create and edit initiative updates
* Create and edit project milestones
* Create and edit project updates
* Manage project labels
* Support for loading images

We also improved performance and reduced token usage through better tool documentation, and added broad support for loading Linear resources through URLs.

## Deprecation of `/sse` MCP endpoint[⁠](https://linear.app/changelog/2026-02-05-linear-mcp-for-product-management.html#deprecation-of-sse-mcp-endpoint)

SSE as a transport was deprecated starting with protocol version `2024-11-05`. As all modern clients now support the more reliable HTTP streams, Linear MCP is fully removing SSE support. To switch, update your endpoint from `https://mcp.linear.app/sse` to `https://mcp.linear.app/mcp`.

Deprecation errors for SSE will be rolled out gradually over the next two months.

Read more in [Linear MCP documentation](https://linear.app/docs/mcp.html).

## Nested sub-issues[⁠](https://linear.app/changelog/2026-02-05-linear-mcp-for-product-management.html#nested-sub-issues)

Issue lists can now show sub-issues as a nested hierarchy. Turn on this display option from any issue list view.

![A nested list of issues in Linear showing progress on improving iOS app startup performance, with statuses, assignees, and completion dates.](https://webassets.linear.app/images/ornj730p/production/e9278628833a0b32b8b8607fb0e0a5838aa27a96-3600x2136.png?q=95&auto=format&dpr=2)

## Retired teams[⁠](https://linear.app/changelog/2026-02-05-linear-mcp-for-product-management.html#retired-teams)

Teams form and disband as organizations evolve. When a team is no longer active, its issues and projects still hold useful context, but shouldn’t clutter your workspace.

We’re introducing the ability to retire teams, giving you a clean way to wind a team down while preserving its project and issue history.

![A confirmation dialog in Linear showing the impact of retiring a team, including canceled issues, read-only projects, and disabled cycles, with Cancel and Retire team buttons.](https://webassets.linear.app/images/ornj730p/production/7bad8b08be03d104e8291ac363a347844d09f822-3600x1770.png?q=95&auto=format&dpr=2)

Retired teams are read-only and hidden from the sidebar, but their issues, projects, and documents are still accessible. When retiring a team, you can choose to cancel any remaining open issues or move them to another team. Retired teams can be restored at any time.

Admins, workspace owners, and team owners can retire a team from its settings page.

Improvements

* Asks

  Added a link to Asks settings in the Slack message shown when a channel isn’t configured for auto-creating Asks
* Asks

  Asks now attempt to include file attachments from forwarded Slack messages when creating issues
* Audit log

  Added an audit log entries when a project or issue is deleted
* Email

  Email intake now handles emails with empty or missing subjects by generating AI-powered titles
* Figma Plugin

  Improved the Figma plugin’s performance by no longer loading all pages in the current file
* IOS

  Added the ability to create initiatives from the iOS app
* IOS

  Added support for composing project and initiative updates directly from Pulse
* Notifications

  Added notifications to inform assignees when an issue is deleted or restored
* Security

  In Enterprise workspaces, bypass of login method restrictions is now only available to owners, not admins and owners
* Slack

  Improved how public Slack channel names appear in synced comments. Private channels continue to show only the channel ID for privacy

Fixes

* Action Menu

  Fixed the command menu becoming unresponsive while typing with CJK IMEs
* Dashboards

  Fixed Insights showing an empty state instead of `0` when there were no matches
* Editor

  Fixed the table column resize cursor getting stuck after using the resize handle
* Editor

  Fixed embed menu text corruption when pasting URLs with leading newlines
* Inbox

  Fixed disappearing avatars in inbox notifications when resizing the browser window
* Issue composer

  The issue and project composers now default to your first active team that’s included in the current cross-team view
* Issue Templates

  Fixed a bug where sub-issues were duplicated when creating issues from form templates
* Lists

  Your last scroll position is now properly restored when returning to a list using the back button or keyboard shortcut after clicking into one of its items
* Navigation

  Fixed the Exploring section not appearing in the sidebar when navigating to a favorited page
* OAuth

  Fixed integrations using client credentials being unable to access initiatives
* Search

  Preserved search input when switching between result type tabs
* Slack

  Fixed URLs with link text formatting not showing up as expected on Android devices
* Statuses

  Fixed time in status property showing negative seconds on recently changed issues

API

* Agents

  OAuth app agents no longer automatically become the delegated agent when updating an issue’s status to Started or Done
* Added IssueHistory resolvers for project milestones, SLA changes, and triage responsibility teams

Keyboard shortcuts

* Added keyboard shortcut to add comments in code blocks: `Cmd/Ctrl``/`
