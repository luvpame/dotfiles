---
title: "Initiative properties – Changelog"
source_url: "https://linear.app/changelog/2026-07-02-initiative-properties"
fetched_at: "2026-10-27T08:17:41.028425+00:00"
---



[Changelog](https://linear.app/changelog.html)

[July 2, 2026](https://linear.app/changelog/2026-07-02-initiative-properties.html) Share

[## Initiative properties](https://linear.app/changelog/2026-07-02-initiative-properties.html)

![Top-level initiatives page on a workspace level showing initiatives grouped by "Company bet" label. Every initiative has an explicit priority assigned.](https://webassets.linear.app/images/ornj730p/production/22e763f897ab3be86523145a6edd20b1cb032d2d-3600x2080.png?q=95&auto=format&dpr=2)

Initiatives define your company’s high-level goals and organize the projects that contribute to them. To help you manage initiatives as your roadmap grows, we’ve added a new set of focused initiative properties:

* **Proposed** and **canceled** statuses make it clear when an initiative is under consideration or has been intentionally set aside
* **Priority** communicates which initiatives are most important
* **Labels** group initiatives by product line, region, or other meaningful categories

Use these properties to group and filter initiatives on any plan, or build custom initiative views on Enterprise plans. Learn more about initiative properties in the [docs](https://linear.app/docs/initiatives.html#initiative-properties).

## Centrally manage access to Linear’s MCP server in Claude[⁠](https://linear.app/changelog/2026-07-02-initiative-properties.html#centrally-manage-access-to-linear's-mcp-server-in-claude)

Give employees secure access to Linear and other MCP servers in Claude, without requiring them to authenticate with each server individually.

Enterprise-managed Authorization lets Okta administrators manage access and permissions centrally, and users automatically get access to the MCP servers they’re authorized to use when they sign in to Claude.

Enterprise-Managed Authorization is available to Enterprise workspaces using Okta as an identity provider and Claude as an MCP client. Learn more in the [docs](https://linear.app/docs/mcp.html) or in the [MCP specification](https://modelcontextprotocol.io/extensions/auth/enterprise-managed-authorization).

## Share filtered views[⁠](https://linear.app/changelog/2026-07-02-initiative-properties.html#share-filtered-views)

You can now share any filtered view by copying its URL from your browser, or by pressing `⌘`/`Ctrl` `Shift` `C` on desktop.

Share filtered views to discuss a subset of an existing view with someone else — like an issue view filtered by an assignee, or project or initiative view filtered by a label.

Fixes

* Agents

  Fixed issues with editing collapsible sections inside documents and descriptions with the Linear agent
* API

  Stopped automatically cancelling and restarting active Triage Intelligence runs after issue content changes
* API

  Fixed fieldless GraphQL input metadata from turning persisted filters into match-all filters
* Asks

  Slack `/asks` commands now pre-fill the modals with the entered text
* Automations

  Fixed showing agent automation `Show more` prompt buttons only when hovering an automation block
* Comments

  Fixed a transient agent session wrapper appearing after mentioning an agent that only handles comment events
* Cycles

  Fixed renamed cycles showing their local generated cycle number in some client Chrome
* Desktop

  Fixed OAuth application creation form resetting when switching tabs on desktop
* Diffs

  Added Linear details comments for manually linked GitHub pull requests when the link is created or changed
* Diffs

  Kept combined code review diffs aligned with side-by-side view when inserted additions are followed by a later paired helper extraction
* Diffs

  Show pull request status icons for coding session inbox notifications tied to PRs
* Diffs

  Fixed review notifications to now open the diff at the relevant comment instead of the guide
* Diffs

  Fixed Team reviews settings appearing when Diffs were disabled
* Diffs

  Fixed poor contrast of JSDoc comments in the GitHub Light syntax theme
* Diffs

  Fixed scroll position jumping when expanding collapsed code sections in diff view
* Diffs

  Fixed commit navigation controls shifting when the changed file count changes between selected commits
* Diffs

  Comment filters on the PR Diffs tab no longer hide comments in the Guide
* Editor

  Fixed emoji rendering in italicized text so emojis remain upright
* Editor

  Improved autolink for a broader list of TLDs when pasting URLs in the editor
* Email

  Fixed email intake settings occasionally displaying an incomplete email address
* Initiatives

  Fixed initiative list with sub-initiatives correctly restoring scroll position on navigation
* Initiatives

  Fixed transparency issues with the icon picker when editing initiatives inline in the list
* Integrations

  Reverted a GitHub sync change that stopped updates from Linear to GitHub once an issue is synced via the `one-way` sync
* Integrations

  Added a warning to Slack issue dialogs when selected labels include multiple labels from the same label group
* Integrations

  Fixed Google Calendar out-of-office status labels showing an absence as starting today when it starts tomorrow in the user’s timezone
* Integrations

  Fixed GitHub issue sync sending Linear label updates back to repositories configured for one-way GitHub-to-Linear sync
* Integrations

  Fixed Linear user mentions in Slack unfurls notifying mentioned users
* Integrations

  Fixed Slack synced comment import retries when Slack returns missing scopes while fetching message replies
* Issue Activity

  Fixed issue activity history no longer briefly reordering or regrouping while loading when lots of labels are involved
* Issue templates

  Fixed blank optional-only form template submissions from creating empty issues
* Issues

  Fixed issue sidebar hover styles not updating after switching between dark and light mode
* Issues

  Fixed copied issues including sub-issues after the Include sub-issues option was disabled
* Issues

  Fixed SLA workflow triggers failing when a workflow condition did not include an issue filter
* Mobile

  Prevented synced email threads from being resolved from Android
* Project Views

  Fixed a problem where hidden groups could not be restored in timeline views
* Projects

  Fixed completed projects appearing in project dependency blocker counts
* Projects

  Fixed newly created projects now receiving varied default icon colors, matching initiatives
* Projects

  Fixed the project update editor border disappearing after Agent highlight interactions
* Releases

  Fixed started release stage rows appearing taller than other rows in release pipeline settings
* Settings

  Fixed existing application images now showing when editing an OAuth application
* Settings

  Fixed settings search input box now respecting custom sidebar theme colors
* Settings

  Fixed customer status and tier row dividers appearing brighter than the header divider in settings
* Settings

  Fixed workspace security settings copy incorrectly referencing recurring issues for workspace template management
* Sidebar

  Properly aligned controls in the sidebar into one consistent column and fixed their focus rings
* Slack

  Stopped retrying permanent Slack webhook errors for disabled app message tabs and invalid block payloads
* Teams

  Fixed duplicate favorite action in action menu on team views
* Triage

  Fixed Triage rules sometimes showing duplicate or missing rows immediately after saving
* Triage

  Fixed the issue preview closing when a new issue entered a label-filtered Triage queue
* Views

  Fixed some server-backed views not loading correctly with some complex filter conditions

* Projects

  Project and initiative overview latest updates no longer inherit the previous latest update’s open state
* Diffs

  Fixed commit titles of specific lengths from overflowing the commit selector dropdown
* Initiatives

  Initiative target dates now use the same completed date rendering semantics as project target dates
* Initiatives

  Show the notifications subscribe control on initiative pages
* Estimates

  Restored the selected issue’s estimate total in the bulk action toolbar
* Editor

  Fixed dragging URL-backed Linear content into editors that was inserting duplicated mentions
* Pulse

  Fixed Pulse summary item navigation inside the inbox and added a breadcrumb back to the originating summary
* Documents

  Fixed restoring deleted documents whose project parent is archived
* Pull requests

  Cmd-clicking linked pull requests now opens them in a new tab
* Diffs

  Fixed bug where some code in Code Review diffs could not be copied to the clipboard

Improvements

* Android

  Added support for toggling todo checkboxes directly in issue descriptions and comments
* Diffs

  Added syntax highlighting for `.gjs` and `.gts` files in Diffs
* Diffs

  Added settings to control whether GitHub team review requests appear in Reviews and count as To Do
* Diffs

  Collapsed generated protobuf Go files in pull request diffs by default
* Diffs

  Changed PR comment copy menu label to refer to threads when copying prompts for comment threads
* Inbox

  Added ability to filter inbox notifications by related review status
* Issues

  Renamed canonical issue duplicate relation labels from “Duplicated by” to “Duplicates”
* Search

  Updated search tabs to show the search term with a Search prefix and a search-results icon
* Teams

  Improved the spacing between team home columns at medium-width resolutions

* Settings

  Clarified the keyboard preference for submitting comments and agent chat messages
* Insights

  Improved performance of issue and insights queries that filter by initiative
* GitHub

  Added `Linear issue` to the list of `magic words` linking pull requests to issues

MCP server

* Added read-only MCP tools for listing and retrieving Linear Agent skills
* Added support for managing releases, release notes, and release issue associations through the MCP server
* Added source URL support to the `save_customer_need` tool

API

* Added an external-user actor variant to the webhook actor union
* Included the top-level `url` field in data-change webhook payloads for remove actions when an entity URL is available
* Fixed entity webhooks for external-user actions so their top-level actor is populated

Keyboard shortcuts

* Added the `]` shortcut to show or hide the Agent sidebar from Diffs when an Agent session is available
* Fixed `Shift` `Cmd/Ctrl` `ArrowDown` not opening sub-issues in board view
