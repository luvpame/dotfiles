---
title: "Loops for product management – Changelog"
source_url: "https://linear.app/changelog/2026-09-14-loops-for-product-management"
fetched_at: "2026-10-27T08:17:41.028425+00:00"
---



[Changelog](https://linear.app/changelog.html)

[September 14, 2026](https://linear.app/changelog/2026-09-14-loops-for-product-management.html) Share

[## Loops for product management](https://linear.app/changelog/2026-09-14-loops-for-product-management.html)

[![](https://webassets.linear.app/images/ornj730p/production/b3ef54a4552ef1ca313902a05ffba24c609bf33e-3840x2160.jpg?q=95&auto=format&dpr=2)](https://webassets.linear.app/files/ornj730p/production/80f59b063433c661b3aeae3f613f0cf2a58d3a35.mp4)

Elapsed00:00Remaining time unknown−--:--

0.25×0.5×0.75×1×1.25×1.5×1.75×2×

[Loops](https://linear.app/now/introducing-loops.html) are recurring agent workflows for teams. They now respond to more workspace activity, including changes to initiatives, projects, and cycles. They can also edit Linear documents and post updates to Slack.

Teams change project plans all the time. It’s not the change itself that’s hard, but the follow-through: updating docs, creating issues, and keeping everyone informed. That’s where information falls out of sync and handoffs get missed. Loops can now handle that coordination for you.

For example, when a project’s target date changes, a loop can automatically update the launch plan and post a Slack message explaining what changed, why, and who needs to act.

#### Trigger from across your workspace[⁠](https://linear.app/changelog/2026-09-14-loops-for-product-management.html#trigger-from-across-your-workspace)

New triggers include:

* Project and initiative changes to status, ownership, target dates, milestones, membership, and labels, plus new updates and comments
* Cycles being created, started, or completed
* Issue changes to status, priority, assignee, cycle, project, or labels

#### Edit documents[⁠](https://linear.app/changelog/2026-09-14-loops-for-product-management.html#edit-documents)

In addition to creating issues and updating projects and initiatives, Loops can now edit documents. When scope or timing changes, a loop can update the relevant Linear document so plans stay aligned.

#### Share updates in Slack[⁠](https://linear.app/changelog/2026-09-14-loops-for-product-management.html#share-updates-in-slack)

A loop can now also draft and post tailored Slack updates using context from Linear and connected tools. Keep the right people informed about what changed and what happens next.

#### Continue any run[⁠](https://linear.app/changelog/2026-09-14-loops-for-product-management.html#continue-any-run)

Each loop run starts a conversation with Linear Agent. Once it finishes, you can continue that conversation like any other agent session to review the work, add context, or direct what happens next.

#### Loops credits available until end of year[⁠](https://linear.app/changelog/2026-09-14-loops-for-product-management.html#loops-credits-available-until-end-of-year)

We’ve extended introductory Loops credits through December 31, giving teams more time to test Loops on their own workflows. See the [docs](https://linear.app/docs/loops.html) for more details.

## Callout components[⁠](https://linear.app/changelog/2026-09-14-loops-for-product-management.html#callout-components)

Use callout components to draw attention to important information in issue and project descriptions, as well as documents. Choose any color, icon, or emoji to match the context.

In PR descriptions, Linear converts callouts to the closest matching GitHub callout type, so the emphasis carries over.

Type `/callout` to get started.

![callout component shown in linear document](https://webassets.linear.app/images/ornj730p/production/68d09905ee168ded3249ebb114a04073a424dab1-3600x2000.png?q=95&auto=format&dpr=2)

Fixes

* Diffs

  Reduced the number of false positives for issue suggestions
* Imports

  Preserved archive status in GitHub imports
* IOS

  Fixed issue list delegation confirmations showing internal user details instead of the agent’s name
* Issues

  Fixed issue copies omitting nested sub-issues
* MCP

  Updated Datadog MCP connections to use the supported v1 endpoints
* Settings

  Fixed SCIM-managed team members incorrectly showing a Non-SCIM label to members and team owners
* Slack

  Fixed a duplicate linkback when a message contained an issue identifier and a link to the same issue at the end of a sentence
* Templates

  Issues created from a form template now keep the status and labels of the board column they were created under

Improvements

* Diffs

  Added a “Copy filename” action to the file tree context menu
* Diffs

  Added a hover explanation to the pull request status badge, so a “Blocked” badge states what is blocking the merge
* Diffs

  Added Diff issue suggestion dismissal button
* Diffs

  Added related diffs to the pull request sidebar
* Editor

  Added support for commenting on links and viewing existing threads from the link toolbar
* Filters

  Changed new label filters to default to “include any of” when all selected labels belong to the same group
* Search

  It is now possible to search projects by their synced Jira Epic key

Keyboard shortcuts

* Diffs

  Fixed collapsed-code controls so `Shift``Up` expands code above and `Shift``Down` expands code below

MCP server

* Hid the Active MCP connections link when the user cannot access workspace security settings
* `list_teams` and `get_team` now report each team’s `visibility` and `retiredAt`

API

* Added new outbound IPs for webhooks, which will go live in the next few weeks. Visit the [docs](https://linear.app/docs/security.html#collapsible-fb465e337d77) for the current list
* Fixed team updates for Asks email intake addresses
