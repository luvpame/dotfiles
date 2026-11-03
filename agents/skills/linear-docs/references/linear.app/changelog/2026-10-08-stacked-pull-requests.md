---
title: "Stacked pull requests – Changelog"
source_url: "https://linear.app/changelog/2026-10-08-stacked-pull-requests"
fetched_at: "2026-10-27T08:17:41.028425+00:00"
---



[Changelog](https://linear.app/changelog.html)

[October 8, 2026](https://linear.app/changelog/2026-10-08-stacked-pull-requests.html) Share

[## Stacked pull requests](https://linear.app/changelog/2026-10-08-stacked-pull-requests.html)

![Linear Diffs showing the current pull request within a four-part stack, with its position, related changes, and branch status.](https://webassets.linear.app/images/ornj730p/production/3770c67200a675f2ce42edef7405feb5a3b47bcd-3600x2098.png?q=95&auto=format&dpr=2)

Stacked pull requests are now displayed in Linear Diffs. Move through a stack and see review, CI, and merge status at a glance. Related PRs are grouped into a single collapsible row in Reviews, alongside their issue and project context.

For [GitHub-native stacks](https://docs.github.com/en/pull-requests/get-started/about-stacked-prs), you can preview every affected PR before merging the current PR and those below from Linear.

Learn more in our [documentation](https://linear.app/docs/pull-request-reviews.html#stacked-diffs).

## View code changes as the agent works[⁠](https://linear.app/changelog/2026-10-08-stacked-pull-requests.html#view-code-changes-as-the-agent-works)

Diffs now update in realtime throughout a Linear coding session, including uncommitted changes from follow-up prompts. You can follow the code as it evolves, catch wrong turns earlier, and steer the agent before or after a pull request is opened.

## AI credit usage explorer and spend limits[⁠](https://linear.app/changelog/2026-10-08-stacked-pull-requests.html#ai-credit-usage-explorer-and-spend-limits)

![AI credit usage over seven days, showing 573 sessions, an average cost of $0.27 per session, and $153.34 in total spend.](https://webassets.linear.app/images/ornj730p/production/5579d89c160c42565936b4d86739425ad5f9e225-3600x2150.png?q=95&auto=format&dpr=2)

Admins can now see what’s driving AI credit usage and set limits to manage spend.

The new usage explorer breaks down spend by team, feature, user, or loop across any time period. Compare total spend, session count, and average spend per session, then select a group in the chart or table for a closer look.

You can also set spend limits at the workspace, user, or loop level to keep usage within the bounds you choose. When a limit is reached, additional AI credit usage is paused until the limit resets or an admin increases it.

Billing admins and owners can access both features in [Usage & Limits](https://linear.app/settings/usage.html). Learn more about AI credits in our [documentation](https://linear.app/docs/ai-credits.html).

## Guided Reviews on Basic[⁠](https://linear.app/changelog/2026-10-08-stacked-pull-requests.html#guided-reviews-on-basic)

[Guides](https://linear.app/docs/pull-request-reviews.html#guides) walk you through the most important changes in a pull request. They’re now available on Basic plans.

Fixes

* Asks

  Fixed duplicate text in issue descriptions created from Slack messages
* Diffs

  Stopped sending notifications for Codex reviews without inline code comments
* Diffs

  Fixed review submissions failing when file review changes were still saving
* Diffs

  Hidden running Codex review summaries and notified when reviews completed
* Diffs

  Kept published review comments on unchanged lines current when edits shifted their position
* Diffs

  Fixed closing search resetting the scroll position after opening a result in a collapsed file
* Diffs

  Fixed approvals reverting during GitHub sync
* Diffs

  Added confirmation before merging a pull request when you are not responsible for merging it
* Editor

  Fixed document printing from intercepting macOS text navigation
* Editor

  Fixed `Backspace` undo for automatically created mentions
* GitHub

  Fixed repeated sync errors when a sub-issue was already attached to its intended GitHub parent
* Imports

  Fixed showing permission errors during Linear imports instead of leaving team selection loading
* Initiatives

  Fixed the new initiative form appearing below the list instead of at the top
* Issues

  Fixed agent status badges not showing on unassigned delegated issues when the session needs attention
* OAuth

  Reduced Cloudflare rate-limit errors caused by frequent OAuth token rotation
* Projects

  Fixed Slack channel creation for agent-created projects with unformatted custom channel names
* Projects

  Fixed duplicated project views resetting their display options
* Settings

  Hid sidebar integration warnings for users who cannot update the connection
* Triage

  Triage rules can only move issues to teams that the rule editor can access
* Webhooks

  Fixed issue creation from Sentry alerts when payload values contain null characters
* Zapier

  Fixed Zapier issue triggers now showing an error when the selected status belongs to a different team

Improvements

* Coding Sessions

  Improved management capabilities for environment owners
* Coding Sessions

  Added Claude Sonnet 5.5 as a coding session model
* Diffs

  Added previous and next controls to jump between Guide sections without marking them reviewed
* Diffs

  Added a merge confirmation in case there are failed non-required checks
* Documents

  Added `[[` to find or create documents inline, plus a “Create new document” slash command that attaches the document to the current context
* GitHub

  Added coding-session static IPs to Linear’s published GitHub allowlist
* Imports

  Linear-to-Linear imports now let you choose which workspace issue labels, project labels, initiative labels, templates, and project statuses to copy
* Imports

  Linear-to-Linear imports can now include a parent team without some or all of its sub-teams
* Integrations

  GitHub issue priority is now a synced property
* Integrations

  Added settings to update the GitLab token and enable automatic renewal (self-rotation of tokens)
* IOS

  Improved icon search to match multiple words across icon names, keywords, and categories
* Issues

  Added the option to save an issue copy as a draft

API

* OAuth

  Required an explicit S256 method for PKCE authorization requests
* Webhooks

  Added quotas limiting the number of webhooks per team (30) and per workspace (50)

MCP server

* Customer Requests

  Added `list_customer_needs` tool that returns the customer requests for an issue, project, or initiative, one page at a time

Keyboard shortcuts

* Added the ability to dismiss toasts using `Cmd/CtrlOptX`
