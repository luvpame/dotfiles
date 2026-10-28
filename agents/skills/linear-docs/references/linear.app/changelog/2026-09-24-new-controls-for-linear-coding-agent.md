---
title: "New controls for Linear coding agent – Changelog"
source_url: "https://linear.app/changelog/2026-09-24-new-controls-for-linear-coding-agent"
fetched_at: "2026-10-27T08:17:41.028425+00:00"
---



[Changelog](https://linear.app/changelog.html)

[September 24, 2026](https://linear.app/changelog/2026-09-24-new-controls-for-linear-coding-agent.html) Share

[## New controls for Linear coding agent](https://linear.app/changelog/2026-09-24-new-controls-for-linear-coding-agent.html)

![Diagram showing Auto mode routing a simple button-copy typo to the faster Luna model and a downtime investigation to the more capable Astra model, with pull requests created for each task.](https://webassets.linear.app/images/ornj730p/production/74cb8bca9e9a934712da5130ff972e972ae4455c-2400x1440.png?q=95&auto=format&dpr=2)

[Coding sessions](https://linear.app/changelog/2026-06-11-coding-sessions.html) are the shortest path from issue to diff. Assign a task to Linear Agent, and it works in a secure cloud environment to write and test the code before opening a pull request for review.

We’re adding more control over how each session runs, from its environment to the models behind it.

### Adaptive routing[⁠](https://linear.app/changelog/2026-09-24-new-controls-for-linear-coding-agent.html#adaptive-routing)

Save time and tokens by automatically routing simpler tasks to a faster model while using the default reasoning model for more complex work. If a task needs more capability than expected, you can restart the session on the default model while keeping the original pull request for reference.

### Environment secrets[⁠](https://linear.app/changelog/2026-09-24-new-controls-for-linear-coding-agent.html#environment-secrets)

Coding sessions can now access environment secrets during setup to securely fetch private dependencies and other environment config.

### Open-weight models[⁠](https://linear.app/changelog/2026-09-24-new-controls-for-linear-coding-agent.html#open-weight-models)

Coding sessions now support open-weight models, starting with GLM-powered sessions. Workspace admins and owners can choose which models are available from [Coding sessions settings](https://linear.app/settings/ai/coding-agent.html).

Visit the [docs](https://linear.app/docs/coding-sessions.html) for more details.

## Team organization at scale[⁠](https://linear.app/changelog/2026-09-24-new-controls-for-linear-coding-agent.html#team-organization-at-scale)

![Overlapping team settings panels showing custom statuses, labels, initiatives, and team ownership for Mobile, QA, and Design teams.](https://webassets.linear.app/images/ornj730p/production/ab6a0ecc87ba215aa2ea7560c4b11ac05861cfac-3600x2080.png?q=95&auto=format&dpr=2)

As companies grow, it can become challenging to accommodate every team’s workflow within a single workspace-wide system. A Product team may track discovery and development, while Marketing organizes work around campaign stages. Both need workflows that reflect how they operate, without fragmenting the company-wide view.

We’re giving teams more freedom to own and organize project work, without losing sight of the bigger picture.

### Team project labels and statuses[⁠](https://linear.app/changelog/2026-09-24-new-controls-for-linear-coding-agent.html#team-project-labels-and-statuses)

Teams can now define their own project labels and statuses to reflect how they work, and extend those workflows across their sub-teams for consistency. Team project labels and statuses are available on Business and Enterprise plans.

### Project lead teams[⁠](https://linear.app/changelog/2026-09-24-new-controls-for-linear-coding-agent.html#project-lead-teams)

You can now define a lead team for a project to clarify ownership when multiple teams contribute. Filter by lead team to create focused views of the projects each team owns.

### Team loops triggers[⁠](https://linear.app/changelog/2026-09-24-new-controls-for-linear-coding-agent.html#team-loops-triggers)

[Loops](https://linear.app/docs/loops.html) can now run when a team is created, someone joins or leaves a team, or an issue is assigned to a team. This makes it possible to automate recurring coordination, such as sending onboarding information to new teammates or reassigning open issues when someone leaves.

### Project and initiative IDs[⁠](https://linear.app/changelog/2026-09-24-new-controls-for-linear-coding-agent.html#project-and-initiative-ids)

Projects and initiatives now have durable, human-legible IDs. Reference work reliably in agent workflows and external tools, even when names change.

Fixes

* Android

  Fixed app crashes when a WebView renderer crashes or is stopped to free memory
* Asks

  Fixed Asks sometimes duplicating Slack message content in descriptions
* Diffs

  Fixed incorrect badge images in synced GitHub review content
* Diffs

  Fixed stray markup appearing in synced GitHub content containing HTML entities
* Diffs

  Fixed Codex review requests from GitHub appearing as threaded replies
* Diffs

  Fixed auto-merge attempting to enter the merge queue before required checks complete when repository settings are stale
* Documents

  Fixed unresolved document comments appearing resolved when created without a text selection
* Editor

  Increased maximum zoom limit for lightbox images. Zooming past native dimensions now shows sharp pixel boundaries
* Editor

  Fixed recent description edits sometimes being omitted when copying prompts, opening coding tools, sending AI messages, or importing meetings
* Editor

  Fixed keyboard access and button semantics for editor node action menus
* Editor

  Fixed holding `Shift` to preserve the aspect ratio when resizing an image crop
* Editor

  Added support for `Cmd/Ctrlscroll` to zoom Mermaid diagrams
* Imports

  Fixed workspace migrations failing when custom views reference initiatives outside the selected teams
* Insights

  Fixed bar chart snapshots failing when state metadata is missing
* IOS

  Fixed “No project,” “No milestone,” and “No agent” missing from matching picker search results
* Loops

  Fixed the search clear button not responding in the desktop app
* Loops

  Fixed Slack user group mentions rendering as literal text in Loop messages
* Notifications

  Fixed priority-only Slack notifications ignoring custom sender filters
* Projects

  Fixed project descriptions being labeled as initiative descriptions for assistive technology
* Pulse

  Fixed Pulse disappearing and reappearing in the sidebar when opening the application
* Settings

  Fixed settings search ranking so pages appear above nested settings with equal matches
* Settings

  Fixed the allowed MCP connectors list to sort alphabetically by connector title
* Slack

  Fixed Slack and Asks submissions restoring deselected template labels
* Teams

  Fixed guest member menus failing to open when the viewer could manage regular members but lacked permission to remove guests

Improvements

* Agent

  Linear Agent can now contact support on your behalf
* Asks

  Added the applied template name to issue creation activity
* Diffs

  Added bot detection for GitHub usernames ending in `-bot` or `Bot`
* Diffs

  Added syntax highlighting for `.cshtml` and `.razor` files
* Diffs

  Simplified Codex review comments
* Diffs

  Grouped closed diffs behind a count toggle in the issue sidebar
* Diffs

  Added Android Vector XML previews and comparisons
* Diffs

  Simplified the activity wording when auto-merge is manually disabled
* Diffs

  Added a saved option to switch between implementation and total line counts by clicking the review header stats
* Diffs

  Added an option to show reviewer avatars in the Created list
* Documents

  Improved document printing to PDF with better page breaks, wide-table continuations, comments as linked endnotes, and consistent formatting for media and embeds
* Editor

  Added an Insert screenshot option to the desktop slash menu on macOS
* Editor

  Added support for pasting tab-separated data (TSV) as editable tables
* Editor

  Added `ShiftTab` support to move nested collapsible blocks to the same level as their parent
* Editor

  Added support for @-mentioning shared views pinned to team, project, and initiative pages in Linear agent chats and loops
* Filters

  Added `Option/Altclick` to replace the current filter selection
* Imports

  Added an option to create users outside selected teams as suspended during Linear workspace imports
* Integrations

  Added the `updates` magic word to create Contributes links from commits and pull requests
* Loops

  Added support for running team and workspace loops on multiple selected issues from the command menu
* Loops

  Added Slack user group lookup so Loops can mention groups named in instructions or lookup tables
* OAuth

  Added audit log entries for explicit OAuth token revocations
* Search

  Improved document search using parent and folder names
* Views

  Changed the default nested sub-issue setting to show only issues matching the current filters
* Views

  Improved icon search with multi-word queries and category matching

API

* Mentioning a third-party agent in a comment now sends a follow-up to its most recent available session on that issue (working or completed)
* Added `Feature` and `Linear` tags to Datadog feature flags created through Linear
* Required pipeline administration rights to change release pipeline team associations
