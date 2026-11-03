---
title: "Agent assisted project updates – Changelog"
source_url: "https://linear.app/changelog/2026-06-18-agent-assisted-project-updates"
fetched_at: "2026-10-27T08:17:41.028425+00:00"
---



[Changelog](https://linear.app/changelog.html)

[June 18, 2026](https://linear.app/changelog/2026-06-18-agent-assisted-project-updates.html) Share

[## Agent assisted project updates](https://linear.app/changelog/2026-06-18-agent-assisted-project-updates.html)

[](https://webassets.linear.app/files/ornj730p/production/47ba9e0b33dfcf931ed9dee36d3aa10542316269.mp4#t=0.001)

Elapsed00:00Remaining time unknown−--:--

0.25×0.5×0.75×1×1.25×1.5×1.75×2×

Project and initiative updates keep teams aligned, but writing them means pulling out recent changes from issues, documents, and discussions.

Instead of finding that context manually, click **Write with Agent** to let Linear do it for you. The agent reviews changes made since the last update, checks messages in the linked Slack channel, and writes an update draft for you to refine.

Add your own perspective by prompting for further changes or editing directly, then publish the update.

## Desktop navigation history and pinned tabs[⁠](https://linear.app/changelog/2026-06-18-agent-assisted-project-updates.html#desktop-navigation-history-and-pinned-tabs)

We’ve rebuilt our desktop tabs to make navigation feel fluid and predictable.

* Each desktop tab now has its own history stack, so moving backwards won’t navigate you to another tab
* Pinned tabs are now a reliable home for important work. They stay anchored in the tab bar, persist after quitting and reopening the app, and aren’t replaced by new content you open.

These changes are live for current desktop users. Try Linear on desktop by [downloading the app](https://linear.app/download.html).

## Private sub-teams[⁠](https://linear.app/changelog/2026-06-18-agent-assisted-project-updates.html#private-sub-teams)

Private sub-teams organize groups that work together under one umbrella, like independent business units, skunkworks efforts, or teams handling sensitive data like People Ops.

When you create a sub-team under a private team, you can now choose between two access options:

* **Restricted to parent team members** — parent team members can see and choose to join the sub-team. This makes it easy to manage private team structures without coordinating invitations to each sub-team.
* **Private to team members** — the team is hidden, except to members directly invited to that sub-team

Private sub-teams are available on Business and Enterprise plans. Learn more in our [documentation](https://linear.app/docs/private-teams.html#restricted-and-private-sub-teams).

## Build agents with Vercel Eve[⁠](https://linear.app/changelog/2026-06-18-agent-assisted-project-updates.html#build-agents-with-vercel-eve)

Vercel Eve is an open-source framework for building custom agents.

Build agents that can investigate incidents, monitor SLAs, or analyze customer feedback. You can deploy agents on Vercel with the guided setup, or host them wherever you run your Eve app.

Once connected to Linear, teammates can delegate issues to your agent or mention it in comments. Learn more about Eve in Vercel’s [documentation](https://beta.eve.dev/docs/getting-started).

## Release pipeline changelogs[⁠](https://linear.app/changelog/2026-06-18-agent-assisted-project-updates.html#release-pipeline-changelogs)

[Releases](https://linear.app/changelog/2026-04-30-releases.html) let you plan and track your software releases. Now, you can also keep your team aligned on what’s shipping with changelogs for each release pipeline. These changelogs bring a pipeline’s release notes together in one place, so progress is easy to review and share.

Choose to auto-generate release notes in pipeline settings so your changelog is always up to date. Learn more in our [documentation](https://linear.app/docs/releases.html#changelogs).

![release pipeline changelog for an iOS pipeline showing fixes in releases 1.81.0 and 1.82.0](https://webassets.linear.app/images/ornj730p/production/d5760a65b0d93563cb4baeb4ec79df2bb8b04357-3600x2192.png?q=95&auto=format&dpr=2)

## OAuth application manifests[⁠](https://linear.app/changelog/2026-06-18-agent-assisted-project-updates.html#oauth-application-manifests)

OAuth application manifests let platforms provide a one-click OAuth app setup experience for users creating integrations.

Use URL parameters to send users directly to a pre-filled *Create OAuth App* form in Linear. An equivalent JSON manifest format lets you store configurations in files, validate them locally, or generate them programmatically.

Find the details in our [developer docs](https://linear.app/developers/oauth-app-manifests.html).

Fixes

* Command menu

  Added the missing command menu action for recently deleted initiatives
* Comments

  Threaded comment highlight corners now match with the reply composer below the thread
* Customers

  Fixed stale customer request counts on issues and projects after archiving or restoring customer requests
* Desktop

  Middle-clicking a link to a document comment now properly navigates to the comment
* Diffs

  Fixed the Unified/Split layout toggle not taking effect when a narrow column had forced the diff into unified view
* Diffs

  The tooltip on group headers in the Reviews inbox now covers the entire clickable header
* Documents

  Creating an issue from a selection in a team document now creates it in the correct team
* Duplicates

  When you remove a duplicate relation, it now restores the issue’s last status
* Duplicates

  Fixed duplicate merges running concurrently for the same issue during bulk deduplication
* Filters

  Fixed the filter button not staying visually active while its menu is open
* Front

  Fixed processing Front conversation links for conversations without a primary recipient
* GitHub

  Fixed GitHub integrations being marked “disconnected” after a transient GitHub authentication blip
* Inbox

  We no longer send a *removed from merge queue* notification when a pull request is successfully merged by GitHub’s merge queue
* Inbox

  Fixed inbox notifications occasionally appearing as blank while the sender’s name was loading
* Insights

  Fixed release-filtered burn-up charts failing to render
* Issues

  Fixed oversized issue status icons in delete confirmation toasts
* Milestones

  Fixed a flicker in the milestone list when creating the first milestone from a project overview
* Notifications

  Each recipient’s name display preference is now respected in project and initiative update notifications
* Project Updates

  Fixed the project updates panel occasionally leaving an empty wrapper element on the page after navigating elsewhere
* Pull requests

  Right-clicking pull request pills in issue lists now opens the correct menu
* Pull requests

  Fixed pull request details overflowing their container when hovering over a PR badge
* SCIM

  Renaming a linked SCIM role group (e.g. `linear-admins`) in the identity provider no longer causes Linear to stop managing the associated role
* Settings

  Prevented the language selector from overlapping the scrollbar in Code & Reviews settings
* Settings

  Fixed an odd transition when switching between the same settings page of different teams
* Slack

  Slack thread sync no longer fails to import a comment when one of its reactions came from a user without access to the issue
* Slack

  Underscores in pull request titles are now preserved in Slack notifications
* Slack

  Slack comment notifications now link out to unsupported images instead of sending invalid Slack image blocks
* Slack

  Slack pasted message links now sync to Linear threads as a clickable link

Improvements

* Agents

  AI chat thinking steps are now shown as blockquotes when copying conversations as markdown
* Diffs

  Added a “Missing issue” PR filter that shows PRs without a linked issue
* Diffs

  Raised the size limit for generating Guides on larger pull request diffs
* Diffs

  Holding `Opt` and clicking the chevron in the file header now expands/collapses all files
* Diffs

  Review list approval copy now shows who approved a pull request
* Diffs

  Whole added/removed lines in diffs render more clearly with the same color as inline added/removed characters
* Diffs

  Added the ability to use custom font for code in diffs
* Diffs

  Added contextual help about the Reviews feature and related keyboard shortcuts
* Diffs

  Polished the pull request review layout — removed the divider between the conversation and code columns, and the Guide now has even horizontal padding with the scrollbar no longer overlapping content
* Diffs

  Added copy link to file actions in pull request diffs
* GitHub/GitLab

  Unassigned triage issues remain in triage for Git request and commit automations, unless the final merged change closes the issue
* PagerDuty

  Added support for PagerDuty shift-based schedules, so triage responsibility on-call now syncs from both shift-based (v3) and classic layer-based schedules (v2)
* Team documents

  The documents list now supports multi-select
* Views

  Updated the sort direction icons so the arrow direction matches the active sort order

MCP server

* MCP project status update tools are now available in workspaces without recent project update history
* Fixed issue with fetches failing when descriptions contained Unicode line or paragraph separators

API

* `templateCreate` and `templateUpdate` now reject unsupported form field payloads
