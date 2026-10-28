---
title: "Coding sessions on mobile – Changelog"
source_url: "https://linear.app/changelog/2026-07-30-coding-sessions-on-mobile"
fetched_at: "2026-10-27T08:17:41.028425+00:00"
---



[Changelog](https://linear.app/changelog.html)

[July 30, 2026](https://linear.app/changelog/2026-07-30-coding-sessions-on-mobile.html) Share

[## Coding sessions on mobile](https://linear.app/changelog/2026-07-30-coding-sessions-on-mobile.html)

[![](https://webassets.linear.app/images/ornj730p/production/78d768e09260fedffc0583ed039244f34d3a4548-3600x2058.png?q=95&auto=format&dpr=2)](https://webassets.linear.app/files/ornj730p/production/8ea92634a2eaa8e2e1441da4fa69ccf0fad9c60e.mp4)

Elapsed00:00Remaining time unknown−--:--

0.25×0.5×0.75×1×1.25×1.5×1.75×2×

Your coding session doesn’t have to stop when you leave your desk. Use the Linear mobile app to review code changes, comment on specific lines, and iterate with Linear Agent.

Open any diff and switch to the Changes tab to inspect the code. When you spot something to change, tap the relevant line to add it to your message to steer the coding session in the direction you want.

We’ve also added section under My Issues → Assigned for your delegated issues. It shows the status of each coding session, and gives you a quick way back into active work.

![ My Issues → Assigned showing delegated issues on iOS mobile app](https://webassets.linear.app/images/ornj730p/production/de5bfa7b44714eef4e54f0bb4c6bfab6841eb716-3600x2360.png?q=95&auto=format&dpr=2)

Download the Linear mobile app for [iOS](https://apps.apple.com/us/app/linear-mobile/id1645587184) and [Android](https://play.google.com/store/apps/details?id=app.linear&hl=en_US&pli=1).

## Guided Reviews are now generally available[⁠](https://linear.app/changelog/2026-07-30-coding-sessions-on-mobile.html#guided-reviews-are-now-generally-available)

[Guided Reviews](https://linear.app/changelog/2026-05-27-linear-diffs.html#guided-reviews-(beta)) break diffs into focused sections with explainers on what changed and why. As part of general availability, they are now generated for larger pull requests, with a bigger context window and better latency.

Guided Reviews are available on Business and Enterprise plans at no additional cost.

![Guided Review for Diff on Refactor notification model and capture parse failures](https://webassets.linear.app/images/ornj730p/production/0bae3de361f646dc692b226b236f9f7e1ae19224-3600x2200.png?q=95&auto=format&dpr=2)

## Support for GitHub teams in reviews[⁠](https://linear.app/changelog/2026-07-30-coding-sessions-on-mobile.html#support-for-github-teams-in-reviews)

You can now assign reviews to GitHub teams. Review requests assigned to your GitHub teams appear in a dedicated section of the Reviews inbox. Learn more in the [docs](https://linear.app/docs/pull-request-reviews.html#notifications).

![Diff with Frontend team tagged as reviewer](https://webassets.linear.app/images/ornj730p/production/f2560c920ea56c0a8f04279cc509c27818c76ab4-3600x1942.png?q=95&auto=format&dpr=2)

## Signed commits for coding sessions[⁠](https://linear.app/changelog/2026-07-30-coding-sessions-on-mobile.html#signed-commits-for-coding-sessions)

Coding sessions now support signed commits. Add your SSH or GPG key in [Settings](https://linear.app/settings/account/security.html) to enable signing.

Workspace admins can also require users to upload a signing key before using coding sessions.

## GitHub Copilot for Linear[⁠](https://linear.app/changelog/2026-07-30-coding-sessions-on-mobile.html#github-copilot-for-linear)

GitHub Copilot users can assign issues directly to Copilot’s cloud agent from Linear. Copilot uses the issue context to work in its own development environment, open draft pull requests, and update the issue as it makes progress.

Choose model and agent settings, set the base and working branches, then steer ongoing work through comments in Linear. To get started, install [GitHub Copilot for Linear](https://linear.app/integrations/github-copilot.html), or read the [GitHub announcement](https://github.blog/changelog/2026-07-23-copilot-cloud-agent-for-linear-is-now-generally-available/) for more details.

Fixes

* Agents

  Queued agent messages now display readable text in previews instead of raw markup
* API

  Fixed issue SLA sort to order by the displayed SLA bucket (Breached / High / Medium / Low / Achieved / Failed) instead of raw `slaBreachesAt`, so mobile lists no longer show repeated SLA sections
* Comments

  Inline images no longer appear too large in iOS comments
* Diffs

  Pull request reviews no longer unexpectedly open an inline comment draft when the revision changes
* Diffs

  Dismissed issue suggestions no longer reappear on pull requests
* GitHub

  Pull request events now update issue statuses when a Git automation branch pattern contains unsupported regex syntax
* Inbox

  Fixed new project and initiative update notifications appearing as separate inbox entries for the same parent
* Integrations

  GitHub Enterprise Server setup no longer gets stuck on “Verifying installation” after the Linear app is created
* Integrations

  Prevented Slack Asks from responding to unmentioned thread messages after creating an Ask
* IOS

  File, image, and video attachments in document comments now open when tapped, and attachment cards have better contrast in the comments drawer
* Issues

  Issue boards now show an error instead of an empty state when too many issues match
* Reviews

  Structural diffs no longer mark entire reformatted statements as changed when only part of the statement changed
* Reviews

  Resolving a review thread that no longer exists in GitHub now shows a clear message instead of a generic error
* Search

  Searching for a GitHub URL now finds issues that reference the pull request
* Slack

  Fixed Slack review request notifications sometimes showing the wrong person as the requester
* Slack

  Fixed pasting a project milestone link into Slack now previewing that milestone instead of another milestone from the same project
* Teams

  Fixed internal custom view and dashboard links in Team Home displaying generic labels or icons
* Triage

  “Copy as prompt” no longer moves issues out of triage

Improvements

* Diffs

  Diffs linked as `Related` no longer change the status of the issue
* Diffs

  AI can now generate a Linear issue from a pull request or suggest an existing issue to link
* Diffs

  Inline feedback can now be sent to the Linear Agent, added to a review, or posted to the diff
* Diffs

  New agent sessions can now be started from any pull request using the Agent panel
* Diffs

  TypeScript and JavaScript regular expressions can now be tested directly from the file where they’re introduced
* Diffs

  Pull requests now show the number of meaningful changes, excluding tests and documentation
* Diffs

  Improved Slack notifications for a pull request removed from the merge queue to include the reason it was removed
* Editor

  Updated the keyboard shortcut cheat sheet to show `Cmd/CtrlEnter` for toggling checklist items
* Importers

  It is now possible to import issues into a sub-team if it doesn’t inherit statuses from its parent team
* Issues

  You can now restore an archived or deleted issue from the iOS app
* Loops

  Improved the “Authenticated email intake” trusted source by renaming it to “Email intake” and explaining when an email is treated as trusted
* Loops

  Added ability for Loops to send user notification
* Zendesk

  Improved the Zendesk integration to allow connection using an agent role instead of an end-user role

MCP server

* Added Zapier to the built-in MCP connector directory

Keyboard shortcuts

* Editor

  Toggle a checklist item with `Cmd/CtrlEnter` when the cursor is inside it. Hold `Shift` to also toggle nested items
* Search

  Escape now clears the search input while keeping the current results, then dismisses search when the input is empty
* Triage

  Triage keyboard shortcuts now follow the order of the actions: `1` accepts, `2` declines, `3` marks as duplicate
