---
title: "New to Product Intelligence: Auto-apply triage suggestions – Changelog"
source_url: "https://linear.app/changelog/2025-09-19-auto-apply-triage-suggestions"
fetched_at: "2026-10-27T08:17:41.028425+00:00"
---



[Changelog](https://linear.app/changelog.html)

[September 18, 2025](https://linear.app/changelog/2025-09-19-auto-apply-triage-suggestions.html) Share

[## New to Product Intelligence: Auto-apply triage suggestions](https://linear.app/changelog/2025-09-19-auto-apply-triage-suggestions.html)

![Automation settings being configured so that the suggested team is auto-applied to issues in Triage](https://webassets.linear.app/images/ornj730p/production/b05687734db02673543d4a9a457f0a8a54c7815d-3600x1800.png?q=95&auto=format&dpr=2)

This feature has been renamed to **Triage Intelligence**

Let Product Intelligence take the first pass at triage and automatically apply suggestions to issues.

[![](https://webassets.linear.app/images/ornj730p/production/877d402ccb09de4d1f27b803ef0d3475e2eac64e-3200x1600.png?q=95&auto=format&dpr=2)](https://webassets.linear.app/files/ornj730p/production/371df06004bd7740cea6cec0a74fa95d68933c7f.mp4)

Elapsed00:00Remaining time unknown−--:--

0.25×0.5×0.75×1×1.25×1.5×1.75×2×

Set up rules to automatically accept suggestions for individual issue properties, or only for specific values. For example, you can configure triage suggestions to always apply the suggested team and assignee but only automatically apply specific labels like `bug`.

Properties that have been automatically applied are clearly marked in the suggestions header. Hover over them to review the reasoning or to make changes.

![Linear product intelligence interface showing that the bug label was auto-applied and showing reasoning (it was suggested because it matched similar issues that are labeled as bugs). The team was also auto-applied (Rider app team) but the iOS label was only suggested, since the settings are limited to only auto-applying the bug label.](https://webassets.linear.app/images/ornj730p/production/c7fc3e3e723d5196e64e2cab4f177e74fdb48517-3600x1890.png?q=95&auto=format&dpr=2)

By letting Product Intelligence take the first pass, you can dramatically reduce the time it takes to triage issues. Your team can focus its attention fully on solving problems, rather than being continuously interrupted.

You can configure [Triage suggestions](https://linear.app/settings/product-intelligence.html) at the workspace or team level. It is part of Product Intelligence, which is available in Technology Preview to anyone on the Business and Enterprise [plans](https://linear.app/pricing.html).

To get started, ask your workspace admin to enable [Product Intelligence](https://linear.app/settings/product-intelligence.html) or learn more in the [docs](https://linear.app/docs/product-intelligence.html).

## OAuth improvements[⁠](https://linear.app/changelog/2025-09-19-auto-apply-triage-suggestions.html#oauth-improvements)

We’re moving OAuth apps to use short-lived access tokens for user-initiated OAuth. These new tokens will be valid for 24 hours and paired with refresh tokens.

Starting October 1st, 2025, all newly created OAuth apps will issue refresh tokens by default. Existing apps will have until April 1st, 2026 to migrate to the new refresh token system.

We also added support for the `client_credentials` grant type for apps that use OAuth tokens for direct server-to-server communication and cannot support a user-initiated OAuth flow involving refresh tokens.

View the updated [OAuth developer documentation](https://linear.app/developers/oauth-2-0-authentication.html) to learn more.

Fixes (24)

* Agents

  We now create an agent session if an agent is mentioned in an issue description, not just a comment
* Agents

  Fixed agent panel so it closes on `Esc` when the input is empty
* Agents

  The elicitation status badge in a comment is now removed when there is new activity
* Customers

  Fixed domains not displaying correctly on the customer page
* Customers

  Fixed an issue where we showed stale customer names after merges by ensuring the latest Intercom customer name is shown
* Customers

  Fixed Intercom updates incorrectly changing merged customers’ names or attributes by always preferring the target customer’s source
* Desktop

  The app no longer crashes when quickly selecting values in filter drop-downs
* Desktop App

  Fixed an issue where opening a deep link in the desktop app would fail to load content when triage or review pages were opened previously
* Document

  The page layout no longer shifts when comments are first loaded
* Editor

  Fixed a bug where pasting a link over editor content that contained an emoji would remove the emoji
* Editor

  Fixed a flicker when video uploads finished; the thumbnail now stays visible as the player loads
* Editor

  Arrow up at the start of a code block or other text block inside a table cell will now add a paragraph above, if there isn’t one already
* Filters

  Fixed “in one day” relative filters saving as a solidified date
* Inbox

  Unselecting all options in a filter now correctly displays all notifications instead of none
* Milestones

  Fixed a bug preventing you from editing the milestone name when in the timeline view
* Notifications

  We now delete unread “Slack thread synced” notifications when the associated Slack thread is disconnected from a Linear comment. This prevents stale notifications from persisting after the sync is removed.
* Projects

  Fixed multiple labels from the same group being applied when changing project templates, which previously blocked project creation
* Projects

  Fixed a bug where a label group was incorrectly applied when creating a project from a view
* Projects

  We now maintain team and remove template labels when removing project template during project creation
* Sentry

  The Sentry integration now delegates to agents when choosing an agent as an assignee
* Timeline

  Fixed the `Ctrl` drag shortcut not working on Linux
* Triage

  Fixed a bug where “related issues” filters would not work correctly on initial load or in the triage view
* Updates

  Fixed update comment not being cleared from input when posted if someone else commented in the meantime
* Updates

  Fixed a flicker when new comments appeared in update comments

Improvements (10)

* Editor

  We now automatically trim leading and trailing whitespace from pasted inputs in migration form fields
* Filters

  AI Filtering for issues and projects now supports all customer filters (e.g., “Prospects with revenue over 100k”)
* Git integrations

  Azure Dev and Bitbucket pull request links are now parsed and a PR number is shown in issue list and board views
* Icons

  We now allow selecting custom icon color through the color picker
* iOS

  Added a “Recently Used” section to the iOS emoji picker, providing quick access to a user’s most frequently used emojis
* Jira Imports

  Jira Components are now imported as labels
* Preferences

  New users will now see full user names by default across all platforms (web, desktop, mobile). Existing user preferences for this setting remain unchanged.
* Profile

  Improved layout of the profile settings page to better support long email addresses
* Projects

  Added a display option to show empty groups and sub-groups when grouping projects by label or label group
* Projects

  Added a warning before submitting a project when there is an unsaved milestone

Keyboard shortcuts (3)

* You can now create projects with `NP`
* Copy git branch name with `Cmd/Ctrl` `Shift` `.` now handles multiple attached pull requests properly
* It’s now possible to search text in inbox or triage using `Cmd`/`Ctrl` `F`

MCP server (2)

* Improved support for passing an API key or OAuth token received from an existing Linear integration
* Added support for querying and setting project state and members

API (4)

* Removed an agent-delegation backwards-compatibility shim for API and webhooks, where the `Issue.delegate` field was mirrored as the `assignee` even if a separate assignee was set
* Added a new `semanticSearch` query that can search multiple item types at once
* Allowed issue:create tokens to access issueSubscribe and issueUnsubscribe
* Improved the process of creating a developer token for an app user with the option to choose which scopes to grant
