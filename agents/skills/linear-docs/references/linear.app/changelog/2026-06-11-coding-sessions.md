---
title: "Coding sessions in Linear – Changelog"
source_url: "https://linear.app/changelog/2026-06-11-coding-sessions"
fetched_at: "2026-10-27T08:17:41.028425+00:00"
---



[Changelog](https://linear.app/changelog.html)

[June 11, 2026](https://linear.app/changelog/2026-06-11-coding-sessions.html) Share

[## Coding sessions in Linear](https://linear.app/changelog/2026-06-11-coding-sessions.html)

[![](https://webassets.linear.app/images/ornj730p/production/324f033c368a45d64811843f7c11ce1217821b8d-1936x1080.png?q=95&auto=format&dpr=2)](https://webassets.linear.app/files/ornj730p/production/19430ac440a288b422cbc54e82b36904538ead08.mp4)

Elapsed00:00Remaining time unknown−--:--

0.25×0.5×0.75×1×1.25×1.5×1.75×2×

Earlier this year, we launched [Linear Agent](https://linear.app/changelog/2026-03-24-introducing-linear-agent.html), giving teams a new way to plan and coordinate their issues and projects. Since then, we’ve added [Code Intelligence](https://linear.app/changelog/2026-05-14-code-intelligence.html) to extend that understanding to the codebase, and [MCP support](https://linear.app/changelog/2026-04-23-linear-agent-mcp-support.html) to bring all of your context together.

Today we’re closing the loop: **Linear Agent can now write code using Claude Code and Codex.** You can triage, plan, review, and ship—all in Linear.

Start a coding session by assigning an issue to Linear, or ask it to make a change in a chat, comment, or Slack thread. Each session is grounded in your workspace context, pulling in issue details, history, customer requests, discussions, and related work.

![Linear agent working alongside a diff](https://webassets.linear.app/images/ornj730p/production/020e273126f3f486fdc16fdc7b6a8a337fe31aa1-3600x2160.png?q=95&auto=format&dpr=2)

## A coding agent your team will love[⁠](https://linear.app/changelog/2026-06-11-coding-sessions.html#a-coding-agent-your-team-will-love)

Coding sessions run in the cloud, so you can prototype ideas and make changes without setting up a local development environment.

When the change is ready, Linear returns a new diff for review. Share [preview links](https://linear.app/docs/pull-request-reviews.html#pull-request-preview-links), bring teammates into the discussion, and address feedback with further iterations in the same thread.

## Automate the first pass[⁠](https://linear.app/changelog/2026-06-11-coding-sessions.html#automate-the-first-pass)

When a new issue is reported, Linear Agent can investigate and attempt a fix before it reaches an engineer, reducing the load on your team.

It follows your team’s guidance, gathers evidence from tools like Sentry or Datadog through MCP, and inspects the codebase to trace the root cause before producing a fix.

Linear uses this workflow internally to resolve roughly 30% of incoming bug reports, mostly on the first pass.

You can set up your own agent automation in your team’s Triage settings.

![issue activity feed, showing a completed coding session](https://webassets.linear.app/images/ornj730p/production/19f7e609de632c335811b8c3ea412ceadf1383af-3600x2275.png?q=95&auto=format&dpr=2)

## Availability and pricing[⁠](https://linear.app/changelog/2026-06-11-coding-sessions.html#availability-and-pricing)

Coding sessions are available on Basic, Business, and Enterprise plans. They require a GitHub connection with code access and use AI credits to run. Workspace admins can enable coding sessions in [Settings](https://linear.app/settings/ai/coding-sessions.html) and manage access, usage, and credits from the usage dashboard. [Learn more in the docs](https://linear.app/docs/coding-sessions.html).

Fixes

* Agents

  Filled in the thumbs down button after submitting AI feedback
* Agents

  Fixed a missing space between the integrations link and surrounding text on the team agents settings page
* Agents

  Vertically centered the label and preview text in the agent session card’s status row
* Agents

  Fixed left padding of the agent session card header to match other activity cards
* Archive

  Fixed restoring a trashed issue or document failing in rare cases where the document’s trashed flag was stored as `false`
* Asks

  Allowed Slack workflows and external users using the Asks Agent to access private teams’ channel-configured templates
* Customers

  Fixed excessive row spacing and the limited customer list on the unfiltered customers page
* Customers

  Fixed the customer merge preview showing annual revenue under the monthly revenue label
* Customers

  Fixed a bug where linking a Slack channel to a customer failed for workspaces with multiple Slack connections but a single Asks connection
* Diffs

  Opening a `linear.review` link in a workspace without Diffs enabled now routes to enable-reviews instead of bouncing back to GitHub
* Diffs

  Fixed showing GitHub legacy commit statuses (e.g. external CI like RWX or Jenkins) in PR checks
* Diffs

  Fixed “Update branch → with rebase” creating a merge commit instead of rebasing
* Diffs

  Fixed the file list sidebar not scrolling when the file tree was taller than the viewport
* Display options

  Fixed the display options menu being slow to open on views grouped into a large number of items
* Editor

  Fixed customer and customer request mentions not loading their details in the iOS editor
* Editor

  Pasting `linear.app/review/<owner>/<repo>/pull/<id>` now properly embeds as a PR mention
* Editor

  Fixed the tooltip for plain links covering link controls
* GitHub

  Fixed Linear issues with comma-containing label names failing to sync to GitHub
* Initiatives

  Fixed Initiative projects table columns occasionally overlapping or taking up too much width
* Integrations

  Fixed an importer freeze when mapping a large number of users
* Issues

  Fixed a line break appearing between an issue’s status icon and its identifier in undo/redo toasts
* Labels

  Archived labels no longer appear in the form-template label group picker
* Links

  Fixed a crash when a link embed with a missing or invalid URL failed to load a preview
* Mobile

  Release, Release Note, and Release Pipeline mentions now display properly on mobile
* Notifications

  Fixed agent completion notifications not being delivered to the user who delegated the work
* Projects

  Project issue list deep links now redirect to the project overview instead of the filtered issue view
* Project Views

  Fixed saved project views unexpectedly showing empty groups when grouping and filtering projects
* Pulse

  Fixed daily Pulse summaries being skipped when a single feed update had a malformed body
* SCIM

  Fixed SCIM role group pushes not repairing a stale role when the user was already tracked in the role’s membership
* Settings

  AI settings dependent on the Linear Agent now show “Disabled” when the Linear Agent is turned off
* Slack

  Sharing a project comment link in Slack now unfurls the comment instead of the project
* SLAs

  Fixed missing SLAs for issues created from Slack asks
* Updates

  Fixed inconsistent icon spacing in the project/initiative update health control

Improvements

* Asks

  Improved longer, cleaner fallback issue titles when creating Asks from Slack without an AI-generated title
* Diffs

  The “Copy pull request number” action now copies just the number, without the leading `#`
* Diffs

  Added a file action to open the full file in GitHub from the review diff
* Diffs

  Guided reviews now jump directly to a selected file instead of scrolling slowly through every file in between
* Documents

  Added “New document” and “New document from template” to the right click menu on the create issue button
* Team Documents

  Added cycle documents to the team documents tab, including support for grouping documents by cycle
* Triage

  On Android, choosing a status that requires a priority to leave triage now opens the priority picker automatically instead of hiding those statuses

Keyboard shortcuts

* Editor

  Changed the strikethrough shortcut to `Cmd/Ctrl` `Shift` `X`

MCP server

* `list_comments` now returns comments on archived issues
* Documents can now be listed and created under a team
