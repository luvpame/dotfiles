---
title: "Team initiatives – Changelog"
source_url: "https://linear.app/changelog/2026-08-13-team-initiatives"
fetched_at: "2026-10-27T08:17:41.028425+00:00"
---



[Changelog](https://linear.app/changelog.html)

[August 13, 2026](https://linear.app/changelog/2026-08-13-team-initiatives.html) Share

[## Team initiatives](https://linear.app/changelog/2026-08-13-team-initiatives.html)

![Initiatives view showing active company goals, nested team initiatives, owners, lead teams, project progress, and health.](https://webassets.linear.app/images/ornj730p/production/4a9c8a92201a695eeaa5f3a6fccb507adac9c661-3600x2080.png?q=95&auto=format&dpr=2)

Initiatives are Linear’s way to manage product strategy and high-level planning across projects. Strategy may start at the company level, but teams carry it forward. You can now assign a team to lead an initiative, making it clear who is responsible for driving the work and how it contributes to the broader direction.

For work that requires tighter access, initiatives led by private teams are only visible to team members. This creates a secure place for confidential planning, regulated projects, audits, and other restricted work.

Learn more about initiatives in the [docs](https://linear.app/docs/initiatives.html).

## **Enterprise-managed authorization for MCP**[⁠](https://linear.app/changelog/2026-08-13-team-initiatives.html#enterprise-managed-authorization-for-mcp)

Linear’s MCP now supports managing employee access through your existing Okta-managed identity.

When employees connect from a supported Anthropic agent, Linear verifies their identity through Okta and applies their existing Linear permissions. Admins can manage access centrally, without requiring employees to sign in or authorize Linear individually.

Available to Enterprise workspaces with Okta SAML configured. Learn more in the [docs](https://linear.app/docs/mcp.html#enterprise-managed-authorization).

Fixes

* Agent

  Fixed agent sometimes not showing a progress indicator
* Agent

  Fixed Linear Agent sometimes claiming a Slack thread synced when it did not
* Comments

  Prevented document comment threads from shifting away from their referenced text when content changes size
* Cycles

  Fixed new cycle names with quarter or half-year labels not incrementing correctly
* Cycles

  Fixed fast issue creation while viewing completed cycles
* Diffs

  Fixed code review discussions crashing when a file path is missing
* Diffs

  Fixed comment links not opening the associated thread
* Diffs

  Fixed authored pull requests appearing in “To review” after commenting
* Diffs

  Fixed closing an already-closed GitHub pull request failing to remove it from review lists
* Diffs

  Fixed stale PR Guides not refreshing after a pull request update
* Editor

  Added support for comments on Mermaid diagrams
* GitHub

  Fixed closing an abandoned draft pull request changing the status of an issue already marked Done or Canceled
* GitLab

  Fixed merge requests from deleted users failing to process
* Integrations

  Fixed disconnecting a personal Notion account opening Notion instead of removing the connection
* Integrations

  Renaming an OAuth application now updates the name shown in the activity of issues it creates
* Issues

  Fixed imported recurring issues missing their recurring-series link in issue history
* Issues

  Fixed drag-and-drop for sub-issues in views sorted by status, title, or due date
* Issues

  Fixed “Copy as” prompt copying a parent issue instead of the selected sub-issue
* Notifications

  Fixed duplicate notifications for GitHub review requests
* Notifications

  Fixed members being unable to disable Slack alerts for shared custom views
* Projects

  Fixed blocking and blocked-by relationships appearing in the wrong direction in project activity
* Projects

  Fixed project and initiative update reminders being sent when an update was already posted on the previous business day
* Search

  Improved exact user name matches in search results
* Triage

  Added GitHub usernames to GitHub-sourced issues in triage

Improvements

* Agent

  Linear Agent can now update releases
* Billing

  Added the ability to remove a previously set tax ID
* Coding sessions

  Added GPT-5.6 Luna as a model option
* Cycles

  Added an explanation of cycle success to the tooltip
* Diffs

  Added a branch-status widget showing whether a branch is up to date, behind, or has conflicts
* Diffs

  Grouped agent and bot review comments under Agents & Bots
* Diffs

  Made structural diff highlighting the default
* Diffs

  Showed merge-queue time on pull request hover
* Editor

  Added support for mentioning pull requests from the editor mention picker
* Editor

  Pressing `Enter` at the end of an issue or document title now starts a new line at the top of the content below it
* Git

  Updated `relates to` and `related to` magic words to mark pull requests as related rather than contributing
* Importer

  Added an option to skip workspace-level labels and templates during Linear-to-Linear imports
* Integrations

  Improved the channel connection labels across Slack and Microsoft Teams menus
* IOS

  We now indicate progress while importing photo library attachments for comments
* Loops

  Made the **Disabled** badge interactive so loops can be re-enabled directly
* Projects

  Added project milestone agent widgets on iOS

API

* Added `subscribers` field on `Document`
* Added a subscription for user settings updates

Keyboard shortcuts

* Teams

  Fixed `Ctrl``Shift``1–9` shortcuts for opening team home pages
