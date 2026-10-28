---
title: "Changelog – Linear"
source_url: "https://linear.app/changelog"
fetched_at: "2026-10-27T08:17:41.028425+00:00"
---



October 22, 2026

[## More ways to run and share Loops](https://linear.app/changelog/2026-10-22-slack-and-github-loops.html)

[![](https://webassets.linear.app/images/ornj730p/production/2de4d32335588139d6e122a64b89bed3e2ff9076-1920x1080.png?q=95&auto=format&dpr=2)](https://webassets.linear.app/files/ornj730p/production/9e1278d821662e7bea1b814dc3cbb89f28671943.mp4)

Elapsed00:00Remaining time unknown−--:--

0.25×0.5×0.75×1×1.25×1.5×1.75×2×

Loops automate product work by responding to changes in Linear and connected tools. You can now trigger them from Slack and GitHub, share them as templates, and customize their reasoning levels.

### Slack and GitHub triggers[⁠](https://linear.app/changelog.html#slack-and-github-triggers)

Events in Slack and GitHub can now start loops automatically, so work can move forward without someone having to notice an update and take action.

Set up a loop to answer product questions in a Slack channel, or draft a QA plan when a GitHub pull request gets a “ready for testing” label.

Learn how to get started with Loops in the [docs](https://linear.app/docs/loops.html).

### Custom loop templates[⁠](https://linear.app/changelog.html#custom-loop-templates)

You can now save loops as templates for others in your workspace to use. For example, share your team’s bug-triage loop so other teams can adapt it without starting from scratch.

To create a template, open a loop’s menu and select **Save as template**. It will appear alongside Linear’s built-in templates when someone in your workspace creates a new loop.

### Reasoning levels[⁠](https://linear.app/changelog.html#reasoning-levels)

Choose how much reasoning each loop uses to balance speed, cost, and task complexity. Keep routine work fast and cost-efficient, and reserve deeper reasoning for more demanding tasks.

**Auto** uses your workspace’s default setting, or select **Low**, **Medium**, or **High** for more control.

## Figma MCP server[⁠](https://linear.app/changelog.html#figma-mcp-server)

Linear Agent can now read and update Figma designs. Share a frame to turn a design into implementation requirements, or ask the agent to create a design proposal from an issue.

Learn more and get connected on the [Figma integration page](https://linear.app/integrations/figma.html#configure).

## Cursor Origin sync[⁠](https://linear.app/changelog.html#cursor-origin-sync)

You can now keep Linear issues in sync with PRs in your Cursor Origin repos. Use a phrase like “Fixes PROD-120” in the PR title or description, and status automations in Linear automatically update the issue as work progresses.

Learn more in our [docs](https://linear.app/integrations/origin.html).

Fixes

* Authentication

  Fixed SCIM role group setup failing or removing existing roles before users were provisioned
* Diffs

  Added a Resolve conflicts button that opens a draft in agent chat from the pull request header
* Drafts

  Creating an issue from a draft no longer clears the draft’s content when creation fails
* Editor

  Fixed a startup crash caused by invalid code syntax theme preferences
* GitHub

  Prevented automatic closure of merge-queued PRs when linked issues were canceled or marked Duplicate
* Insights

  Fixed the fullscreen drill on large team issue views and server-backed custom views now shows every issue the insight counted, including sub-issues and triage issues
* Integrations

  Fixed out-of-office days from Google Calendar sometimes showing a day early, a day late, or as two days instead of one
* Issues

  Fixed sub-issues created through MCP or Linear Agent missing their parent’s project when eligible to inherit it
* OAuth

  Fixed client-credentials tokens granting access to public teams outside the app user’s selected teams
* Projects

  Excluded completed and other inactive projects from initiative active-project health counts
* Teams

  Fixed preserving team settings description edits through refresh and sync updates
* Templates

  Fixed issues created from a project template landing in Triage instead of their template status when the creator was not a member of a team
* Views

  Fixed boards grouped by release or customer briefly disappearing and scrolling back to the top when a card moved between columns

Improvements

* Diffs

  Added Pending and Drafts filters in Diff to find comments you have not sent yet
* Diffs

  Added a sidebar badge when a personal GitHub account needs connecting or reconnecting
* Diffs

  Improved multi-line code selection highlights in diffs and attached code previews
* Editor

  Added scannable images for QR codes drawn as text in code blocks, with a toolbar button to switch between image and text while editing
* Filters

  Added initiative lead team filters to project views
* GitHub

  Pull request activity shows running Codex reviews from 👀 reactions
* Imports

  Improved the ability to scope Asana imports to a specific projects
* Inbox

  “Delete all completed” now also removes review requests you already handled
* Issues

  Added T3 Code as an option for opening issues
* Labels

  Label groups can now be designated as multi-select instead of single-select. Use this in scenarios where multiple labels are expected to be applied to an object at the same time.
* Linear Agent

  The agent can now rename it’s current chat
* Loops

  Added a “Create new loop” action to the `Cmd/CtrlK` command menu
* Triage

  Added BetterStack as a supported schedule for triage responsibility
* Triage

  Improved the triage responsibility schedule to now show your upcoming shift while you are on the current shift

MCP server

* You can now assign users by part of their name, and a name that matches more than one user returns the possible matches
* We’ve added customer lookup by domain and external IDs

API

* OAuth

  Fixed OAuth token refresh to return `invalid_grant` for expired, revoked, or unknown refresh tokens, so apps can prompt users to reconnect
* Projects

  Fixed project template label defaults differing between the web and API after converting a label group to single-select

October 8, 2026

[## Stacked pull requests](https://linear.app/changelog/2026-10-08-stacked-pull-requests.html)

![Linear Diffs showing the current pull request within a four-part stack, with its position, related changes, and branch status.](https://webassets.linear.app/images/ornj730p/production/3770c67200a675f2ce42edef7405feb5a3b47bcd-3600x2098.png?q=95&auto=format&dpr=2)

Stacked pull requests are now displayed in Linear Diffs. Move through a stack and see review, CI, and merge status at a glance. Related PRs are grouped into a single collapsible row in Reviews, alongside their issue and project context.

For [GitHub-native stacks](https://docs.github.com/en/pull-requests/get-started/about-stacked-prs), you can preview every affected PR before merging the current PR and those below from Linear.

Learn more in our [documentation](https://linear.app/docs/pull-request-reviews.html#stacked-diffs).

## View code changes as the agent works[⁠](https://linear.app/changelog.html#view-code-changes-as-the-agent-works)

Diffs now update in realtime throughout a Linear coding session, including uncommitted changes from follow-up prompts. You can follow the code as it evolves, catch wrong turns earlier, and steer the agent before or after a pull request is opened.

## AI credit usage explorer and spend limits[⁠](https://linear.app/changelog.html#ai-credit-usage-explorer-and-spend-limits)

![AI credit usage over seven days, showing 573 sessions, an average cost of $0.27 per session, and $153.34 in total spend.](https://webassets.linear.app/images/ornj730p/production/5579d89c160c42565936b4d86739425ad5f9e225-3600x2150.png?q=95&auto=format&dpr=2)

Admins can now see what’s driving AI credit usage and set limits to manage spend.

The new usage explorer breaks down spend by team, feature, user, or loop across any time period. Compare total spend, session count, and average spend per session, then select a group in the chart or table for a closer look.

You can also set spend limits at the workspace, user, or loop level to keep usage within the bounds you choose. When a limit is reached, additional AI credit usage is paused until the limit resets or an admin increases it.

Billing admins and owners can access both features in [Usage & Limits](https://linear.app/settings/usage.html). Learn more about AI credits in our [documentation](https://linear.app/docs/ai-credits.html).

## Guided Reviews on Basic[⁠](https://linear.app/changelog.html#guided-reviews-on-basic)

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

September 24, 2026

[## New controls for Linear coding agent](https://linear.app/changelog/2026-09-24-new-controls-for-linear-coding-agent.html)

![Diagram showing Auto mode routing a simple button-copy typo to the faster Luna model and a downtime investigation to the more capable Astra model, with pull requests created for each task.](https://webassets.linear.app/images/ornj730p/production/74cb8bca9e9a934712da5130ff972e972ae4455c-2400x1440.png?q=95&auto=format&dpr=2)

[Coding sessions](https://linear.app/changelog/2026-06-11-coding-sessions.html) are the shortest path from issue to diff. Assign a task to Linear Agent, and it works in a secure cloud environment to write and test the code before opening a pull request for review.

We’re adding more control over how each session runs, from its environment to the models behind it.

### Adaptive routing[⁠](https://linear.app/changelog.html#adaptive-routing)

Save time and tokens by automatically routing simpler tasks to a faster model while using the default reasoning model for more complex work. If a task needs more capability than expected, you can restart the session on the default model while keeping the original pull request for reference.

### Environment secrets[⁠](https://linear.app/changelog.html#environment-secrets)

Coding sessions can now access environment secrets during setup to securely fetch private dependencies and other environment config.

### Open-weight models[⁠](https://linear.app/changelog.html#open-weight-models)

Coding sessions now support open-weight models, starting with GLM-powered sessions. Workspace admins and owners can choose which models are available from [Coding sessions settings](https://linear.app/settings/ai/coding-agent.html).

Visit the [docs](https://linear.app/docs/coding-sessions.html) for more details.

## Team organization at scale[⁠](https://linear.app/changelog.html#team-organization-at-scale)

![Overlapping team settings panels showing custom statuses, labels, initiatives, and team ownership for Mobile, QA, and Design teams.](https://webassets.linear.app/images/ornj730p/production/ab6a0ecc87ba215aa2ea7560c4b11ac05861cfac-3600x2080.png?q=95&auto=format&dpr=2)

As companies grow, it can become challenging to accommodate every team’s workflow within a single workspace-wide system. A Product team may track discovery and development, while Marketing organizes work around campaign stages. Both need workflows that reflect how they operate, without fragmenting the company-wide view.

We’re giving teams more freedom to own and organize project work, without losing sight of the bigger picture.

### Team project labels and statuses[⁠](https://linear.app/changelog.html#team-project-labels-and-statuses)

Teams can now define their own project labels and statuses to reflect how they work, and extend those workflows across their sub-teams for consistency. Team project labels and statuses are available on Business and Enterprise plans.

### Project lead teams[⁠](https://linear.app/changelog.html#project-lead-teams)

You can now define a lead team for a project to clarify ownership when multiple teams contribute. Filter by lead team to create focused views of the projects each team owns.

### Team loops triggers[⁠](https://linear.app/changelog.html#team-loops-triggers)

[Loops](https://linear.app/docs/loops.html) can now run when a team is created, someone joins or leaves a team, or an issue is assigned to a team. This makes it possible to automate recurring coordination, such as sending onboarding information to new teammates or reassigning open issues when someone leaves.

### Project and initiative IDs[⁠](https://linear.app/changelog.html#project-and-initiative-ids)

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

September 14, 2026

[## Loops for product management](https://linear.app/changelog/2026-09-14-loops-for-product-management.html)

[![](https://webassets.linear.app/images/ornj730p/production/b3ef54a4552ef1ca313902a05ffba24c609bf33e-3840x2160.jpg?q=95&auto=format&dpr=2)](https://webassets.linear.app/files/ornj730p/production/80f59b063433c661b3aeae3f613f0cf2a58d3a35.mp4)

Elapsed00:00Remaining time unknown−--:--

0.25×0.5×0.75×1×1.25×1.5×1.75×2×

[Loops](https://linear.app/now/introducing-loops.html) are recurring agent workflows for teams. They now respond to more workspace activity, including changes to initiatives, projects, and cycles. They can also edit Linear documents and post updates to Slack.

Teams change project plans all the time. It’s not the change itself that’s hard, but the follow-through: updating docs, creating issues, and keeping everyone informed. That’s where information falls out of sync and handoffs get missed. Loops can now handle that coordination for you.

For example, when a project’s target date changes, a loop can automatically update the launch plan and post a Slack message explaining what changed, why, and who needs to act.

#### Trigger from across your workspace[⁠](https://linear.app/changelog.html#trigger-from-across-your-workspace)

New triggers include:

* Project and initiative changes to status, ownership, target dates, milestones, membership, and labels, plus new updates and comments
* Cycles being created, started, or completed
* Issue changes to status, priority, assignee, cycle, project, or labels

#### Edit documents[⁠](https://linear.app/changelog.html#edit-documents)

In addition to creating issues and updating projects and initiatives, Loops can now edit documents. When scope or timing changes, a loop can update the relevant Linear document so plans stay aligned.

#### Share updates in Slack[⁠](https://linear.app/changelog.html#share-updates-in-slack)

A loop can now also draft and post tailored Slack updates using context from Linear and connected tools. Keep the right people informed about what changed and what happens next.

#### Continue any run[⁠](https://linear.app/changelog.html#continue-any-run)

Each loop run starts a conversation with Linear Agent. Once it finishes, you can continue that conversation like any other agent session to review the work, add context, or direct what happens next.

#### Loops credits available until end of year[⁠](https://linear.app/changelog.html#loops-credits-available-until-end-of-year)

We’ve extended introductory Loops credits through December 31, giving teams more time to test Loops on their own workflows. See the [docs](https://linear.app/docs/loops.html) for more details.

## Callout components[⁠](https://linear.app/changelog.html#callout-components)

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

September 3, 2026

[## Priority inbox](https://linear.app/changelog/2026-09-03-priority-inbox.html)

![Linear Inbox in dark mode, showing Priority and Other tabs with several notifications about issue assignments, project updates, comments, and mentions.](https://webassets.linear.app/images/ornj730p/production/8005be22da38ee19e6ac56569976958564d9bbb1-3600x2080.png?q=95&auto=format&dpr=2)

An active workspace can create a significant amount of notifications each day, and until now your inbox treated them all the same. The new **Priority** tab separates what needs your attention from what can wait, so something like a review blocking a release never gets buried.

Linear selects what appears in Priority by default, with the option to customize it by choosing notification sources or creating a filter. You can also continue using the inbox just as you do today.

To get started, open the inbox display options or read the [docs](https://linear.app/docs/inbox.html).

## Draft projects with Linear Agent[⁠](https://linear.app/changelog.html#draft-projects-with-linear-agent)

The new project composer lets you develop ideas with Linear Agent before creating a live project. Inside the composer, Linear can pull in relevant context from your workspace and connected tools to sharpen the brief and build out a plan.

Drafts save automatically as you work, so you can return to the draft without losing progress.

Select **Create with Agent** in the project creation page to get started.

![Linear’s AI project-drafting interface creating a “Reliable airport pickups” project, with a live chat panel and project brief fields.](https://webassets.linear.app/images/ornj730p/production/0e436be9125079b223439fcb01d4db5feae680a8-3600x2368.png?q=95&auto=format&dpr=2)

## Document editing on mobile[⁠](https://linear.app/changelog.html#document-editing-on-mobile)

Document creation and editing are now available in Linear’s [iOS](https://apps.apple.com/us/app/linear-mobile/id1645587184) and [Android](https://play.google.com/store/apps/details?id=app.linear&hl=en_US&pli=1) apps. Start a doc while the context is fresh, update a plan as it changes, or fix a detail before it sends someone in the wrong direction, without waiting until you’re back at your desk.

## Rich previews in diffs[⁠](https://linear.app/changelog.html#rich-previews-in-diffs)

Images, fonts, Markdown, and PDFs now render directly inside Linear diffs. Reviewers can see the output alongside the code and understand what changed without leaving the pull request.

Symlinks are also now supported, shown as file-based changes.

![Code review diff for DRV-2498 showing an updated SVG asset, with removed and added illustration previews side by side.](https://webassets.linear.app/images/ornj730p/production/177687802d38fab3bc19324fc075a82c95b2cd0e-3600x2394.png?q=95&auto=format&dpr=2)

## Third-party app approvals[⁠](https://linear.app/changelog.html#third-party-app-approvals)

As more apps and agents connect to your workspace, admins need control over which ones can access company data. Third-party app approvals are now available on paid Linear plans, allowing admins to review and approve apps before they’re installed.

Learn more in the [docs.](https://linear.app/docs/third-party-application-approvals.html)

Fixes

* Agents

  Fixed triage suggestions now showing the team name instead of the key
* Agents

  Fixed an issue where Linear Agent was sometimes not linking a PR to the issue it was generated from
* Asks

  Fixed large inbound emails blocking workflow processing during quote detection
* Desktop

  Fixed an issue where opening documents in the desktop app navigated to their parent
* Diffs

  Reduced request spikes when opening very large pull requests
* Diffs

  Fixed changed lines sometimes missing from pull requests
* Diffs

  Fixed incremental PR Guide updates sometimes dropping unchanged sections
* IOS

  @-mentions now respect the full name display preference in comments and issue descriptions
* Linear Agent

  Fixed agent panel “use as context” button’s tooltip incorrectly formatting entity names like pull request
* Notifications

  Fixed bulk notification actions to show both read-state options when the selection contains read and unread notifications
* Projects

  Fixed the scroll position indicator jumping back to an earlier section while scrolling down a project overview
* Slack

  Fixed issue creation failing after updating fields in the Slack issue form
* Slack

  Fixed synced Slack replies being deleted when an issue is archived
* Teams

  Fixed team settings rejecting an unchanged team identifier that became reserved after it was initially claimed by the team
* Triage

  Fixed cases where future shifts did not appear in triage responsibility when using an external schedule

Improvements

* Accessibility

  Improved accessibility of view display controls
* Asks

  Allowed reordering templates on Asks Web pages
* Command Menu

  Improved command menu to now use fuzzy search
* Desktop

  Added native creation commands, including documents, and made `Cmd/CtrlN` choose what to create from the current view
* Diffs

  Added compact activity updates for running and completed Codex reviews
* Favorites

  You can now add a loop to `Favorites`
* Favorites

  You can now right-click a favorites folder to copy the URLs of all items
* Favorites

  You can now drag items to add them to favorites
* Filters

  Added a “No labels” filter option
* Filters

  Added “My teams” filter value that matches the teams the current user belongs to
* Labels

  Removed the ability for labels to contain emojis
* Linear Agent

  Files dropped anywhere over an Agent chat now attach to the message composer
* Loops

  Notified loop owners when one of their loops is deleted or disabled by someone else
* Loops

  Added support for running scheduled Loops every hour or at custom hourly intervals
* Settings

  Added an option to start SLA timing when an issue is created instead of when it is escalated
* Settings

  Added CSV exports to workspace teams, team members, API keys, and usage history tables
* Settings

  Added support for adding multiple workspace members to one or more teams at once
* Settings

  Added support for selecting workspace members and changing roles, suspending, or activating them in bulk
* Slack

  Accents in Slack always use the color defined for the associated issue status
* Teams

  Added bulk member selection, team owner promotion, demotion, and removal to team member settings
* Workspaces

  Standardized search, filter, and display controls across workspace-level Teams, Members, Loops, and Releases views

Keyboard shortcuts

* Fixed `ShiftCmd/CtrlO` opening sub-issue creation instead of the pull request preview
* Added `O` then `G` to open linked pull requests and synced GitHub issues from issue views

API

* Added the `startMode` field and `SLAStartMode` enum to SLA configuration responses
* Added outbound IP addresses published at https://linear.app/.well-known/appspecific/app.linear.ips.json

August 20, 2026

[## Coding sessions: environments, browser use, and updated pricing](https://linear.app/changelog/2026-08-20-coding-environments.html)

[![](https://webassets.linear.app/images/ornj730p/production/f7ae17745a2aae2e14f3cc80a4aaa72fe3633c44-1200x800.png?q=95&auto=format&dpr=2)](https://webassets.linear.app/files/ornj730p/production/3922f252288414570e31823dbfc947723a2e59a2.mp4)

Elapsed00:00Remaining time unknown−--:--

0.25×0.5×0.75×1×1.25×1.5×1.75×2×

Linear Agent can now set up, run, and test your code before returning its work. That means fewer handoffs and changes that are further along when they come back to you.

We’re also introducing lower, more transparent pricing, making AI credit usage easier to understand and control.

## **Configurable environments**[⁠](https://linear.app/changelog.html#configurable-environments)

Coding sessions now automatically adapt to each codebase’s configuration, with broader out-of-the-box support for Python, Ruby, Go, and more.

During a session, Linear detects and installs the toolchains and dependencies it needs to complete the task. Teams can go further by pinning runtime versions, adding setup scripts, and defining environment variables.

To get started, create an environment in [settings](https://linear.app/settings/ai/coding-sessions.html). Visit the [docs](https://linear.app/docs/coding-sessions.html) for more details.

## Browser testing[⁠](https://linear.app/changelog.html#browser-testing)

Once the application is running, Linear Agent tests its work where users experience it: in the browser.

The agent opens the app, navigates through a flow, and verifies its implementation. It also captures before-and-after screenshots, making visual changes easier to review alongside the code.

Browser testing can catch broken interactions and visual regressions that code review alone might miss. If the agent finds a problem, it can make a fix, rerun the test, and return the work with that validation complete.

![Screenshot of Linear UI](https://webassets.linear.app/images/ornj730p/production/4949ed5cd70ac79c7cb914eb65373f5e494af720-3600x2160.png?q=95&auto=format&dpr=2)

## Transparent pricing[⁠](https://linear.app/changelog.html#transparent-pricing)

As coding sessions take on more work, costs need to be easy to understand and easy to control.

Starting today, coding sessions use a lower-cost pricing model with two components:

* **Model usage:** Tokens are charged at the provider’s published rates, with no markup
* **Sandbox runtime:** Charged at $0.25 per 20-minute block

Together, model usage and runtime determine the AI credit cost of a session. The usage dashboard shows the breakdown, along with token usage and cost by model.

Admins can also set workspace-wide and per-user spend limits that reset daily, weekly, or monthly. When a limit is reached, additional AI credit usage is paused until the limit resets or an admin increases it.

Learn more about AI credits in the [docs](https://linear.app/docs/ai-credits.html).

Fixes

* Agents

  Fixed an issue where Linear couldn’t find or assign a future cycle when referenced by its number (e.g. “Cycle 13”) in Slack and comments
* Android

  Fixed read AI conversations appearing bold in the conversation picker
* Desktop

  Fixed search and create issue buttons in the sidebar not responding to clicks at narrow window sizes
* Diffs

  Fixed merge queue duration tooltips appearing stuck
* Diffs

  Fixed guide sections with a lot of files in them not being scrollable
* Diffs

  Fixed Linear guest users with a connected GitHub account being able to edit Diff title and description if they have write access to that PR on GitHub
* Diffs

  Removed hover underlines from GitHub code embed header links, kept their link cursors when focused, and added external-link indicators to file names
* Diffs

  Fixed repeated review cache errors when IndexedDB is unavailable

Improvements

* Asks

  Added a per-channel Asks setting that posts a message mentioning the new assignee in the synced Slack thread when an Ask is assigned
* Authentication

  Improved pending SAML domain verification from 24 hours to seven days
* Diffs

  Improved meaningful change count on PR tooltips as well
* IOS

  Improved error messages for unsupported media formats
* Issues

  Added the full issue copy menu to the issue header URL button
* Team Home

  Initiative documents pinned to a team’s overview now also appear in the team’s documents tab
* Views

  Added ability to subscribe to events in project views and receive notifications in Inbox or Slack

Keyboard shortcuts

* Issues

  Open a GitHub-synced issue in GitHub with `O``G`
* Issues

  Fixed `Cmd/Ctrl``Up/Down` scrolling to the top or bottom of an issue after editing its title or description

August 13, 2026

[## Team initiatives](https://linear.app/changelog/2026-08-13-team-initiatives.html)

![Initiatives view showing active company goals, nested team initiatives, owners, lead teams, project progress, and health.](https://webassets.linear.app/images/ornj730p/production/4a9c8a92201a695eeaa5f3a6fccb507adac9c661-3600x2080.png?q=95&auto=format&dpr=2)

Initiatives are Linear’s way to manage product strategy and high-level planning across projects. Strategy may start at the company level, but teams carry it forward. You can now assign a team to lead an initiative, making it clear who is responsible for driving the work and how it contributes to the broader direction.

For work that requires tighter access, initiatives led by private teams are only visible to team members. This creates a secure place for confidential planning, regulated projects, audits, and other restricted work.

Learn more about initiatives in the [docs](https://linear.app/docs/initiatives.html).

## **Enterprise-managed authorization for MCP**[⁠](https://linear.app/changelog.html#enterprise-managed-authorization-for-mcp)

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

July 30, 2026

[## Coding sessions on mobile](https://linear.app/changelog/2026-07-30-coding-sessions-on-mobile.html)

[![](https://webassets.linear.app/images/ornj730p/production/78d768e09260fedffc0583ed039244f34d3a4548-3600x2058.png?q=95&auto=format&dpr=2)](https://webassets.linear.app/files/ornj730p/production/8ea92634a2eaa8e2e1441da4fa69ccf0fad9c60e.mp4)

Elapsed00:00Remaining time unknown−--:--

0.25×0.5×0.75×1×1.25×1.5×1.75×2×

Your coding session doesn’t have to stop when you leave your desk. Use the Linear mobile app to review code changes, comment on specific lines, and iterate with Linear Agent.

Open any diff and switch to the Changes tab to inspect the code. When you spot something to change, tap the relevant line to add it to your message to steer the coding session in the direction you want.

We’ve also added section under My Issues → Assigned for your delegated issues. It shows the status of each coding session, and gives you a quick way back into active work.

![ My Issues → Assigned showing delegated issues on iOS mobile app](https://webassets.linear.app/images/ornj730p/production/de5bfa7b44714eef4e54f0bb4c6bfab6841eb716-3600x2360.png?q=95&auto=format&dpr=2)

Download the Linear mobile app for [iOS](https://apps.apple.com/us/app/linear-mobile/id1645587184) and [Android](https://play.google.com/store/apps/details?id=app.linear&hl=en_US&pli=1).

## Guided Reviews are now generally available[⁠](https://linear.app/changelog.html#guided-reviews-are-now-generally-available)

[Guided Reviews](https://linear.app/changelog/2026-05-27-linear-diffs.html#guided-reviews-(beta)) break diffs into focused sections with explainers on what changed and why. As part of general availability, they are now generated for larger pull requests, with a bigger context window and better latency.

Guided Reviews are available on Business and Enterprise plans at no additional cost.

![Guided Review for Diff on Refactor notification model and capture parse failures](https://webassets.linear.app/images/ornj730p/production/0bae3de361f646dc692b226b236f9f7e1ae19224-3600x2200.png?q=95&auto=format&dpr=2)

## Support for GitHub teams in reviews[⁠](https://linear.app/changelog.html#support-for-github-teams-in-reviews)

You can now assign reviews to GitHub teams. Review requests assigned to your GitHub teams appear in a dedicated section of the Reviews inbox. Learn more in the [docs](https://linear.app/docs/pull-request-reviews.html#notifications).

![Diff with Frontend team tagged as reviewer](https://webassets.linear.app/images/ornj730p/production/f2560c920ea56c0a8f04279cc509c27818c76ab4-3600x1942.png?q=95&auto=format&dpr=2)

## Signed commits for coding sessions[⁠](https://linear.app/changelog.html#signed-commits-for-coding-sessions)

Coding sessions now support signed commits. Add your SSH or GPG key in [Settings](https://linear.app/settings/account/security.html) to enable signing.

Workspace admins can also require users to upload a signing key before using coding sessions.

## GitHub Copilot for Linear[⁠](https://linear.app/changelog.html#github-copilot-for-linear)

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

July 23, 2026

[## Text attribution and agent-assisted editing](https://linear.app/changelog/2026-07-23-agent-assisted-editing.html)

![a document and an agent panel showing the prompt to edit ](https://webassets.linear.app/images/ornj730p/production/15b9a90d9ef28e617836383f0b295536c437b4b1-3600x2080.png?q=95&auto=format&dpr=2)

Documents and project descriptions are critical context for your teams and agents.

You can now edit text with [Linear Agent](https://linear.app/docs/linear-agent.html), and use [Loops](https://linear.app/docs/loops.html) to keep docs and project descriptions up-to-date. Author name indicators let you check if text was written by a colleague or added by a loop.

When editing, changes you make through Linear Agent highlight separately so they’re easy to review. If you need to revert to an earlier version, restore to any previous checkpoint from version history.

Show author names or open version history from the `⌘`/`Ctrl` + `K` menu, or in document display options. Learn more in our [documentation](https://linear.app/docs/project-documents.html#edit-documents).

## Refreshed issue sidebar[⁠](https://linear.app/changelog.html#refreshed-issue-sidebar)

The issue sidebar now closely integrates issue properties with the main content. We’ve pinned Diffs to the top of this panel so you can access the issue’s pull requests from anywhere on the page.

![New issue sidebar with diffs at the top](https://webassets.linear.app/images/ornj730p/production/fdbe518ba5882edab1681f7410f9af78716021f2-3600x2058.png?q=95&auto=format&dpr=2)

Fixes

* Asks

  Fixed issues created through Slack Asks ignoring a chosen template’s default status
* Comments

  The resolved comments menu no longer appears when there are no resolved comments
* Diffs

  Submit review flyouts now properly close when clicking outside them
* GitHub

  Prevented revert pull requests from reopening issues linked to another GitHub repository
* GitHub

  Fixed linking GitHub pull requests to issues via pasted URLs.
* Initiatives

  Fixed oversized initiative titles
* Integrations

  Fixed a bug where removing a linked GitHub pull request disconnecting GitHub issue sync
* Integrations

  Fixed Slack project channel setup retrying after a project was deleted or archived
* Settings

  Fixed IP restrictions not appearing when searching for “IP” in settings
* Slack

  Fixed truncated issue summaries in Slack unfurls
* Views

  Fixed view filters (like `Cmd/Ctrl` `F` filtering) resetting when navigating to an item in a split view list

Improvements

* Editor

  Added Backspace navigation from empty issue descriptions and document bodies back to the title
* Issues

  Improved issue composer to suggest templates as a quick suggestion, surfaced before other suggestions because they apply a bundle of issue properties
* Projects

  Added a way to view a project’s issues filtered by a specific milestone from the project overview on iOS
* Triage

  Added triage responsibility to the triage screen on iOS, showing who is responsible for incoming issues and letting you manage the action and responsible members
* Diffs

  “Quick to review” now shows up for slightly larger PRs and also appears for the author of the PR

API

* Added `bodyData` to GraphQL pull request comments
* `CycleCreate` and `CycleUpdate` now prevent overlapping schedules and validate neighboring cycles using their dates.

July 20, 2026

[## Introducing Loops](https://linear.app/changelog/2026-07-20-introducing-loops.html)

[![](https://webassets.linear.app/images/ornj730p/production/6d18bd62c1abee6e9048418f7553bab34d4c1eda-3840x2160.jpg?q=95&auto=format&dpr=2)](https://webassets.linear.app/files/ornj730p/production/cb230e1a5833081ae9e60f918c92d6db01ed64c4.mp4)

Elapsed00:00Remaining time unknown−--:--

0.25×0.5×0.75×1×1.25×1.5×1.75×2×

Loops are a new way for Linear Agent to take on recurring work for your team.

Describe the job in plain language and then choose whether it should run on a schedule or in response to an event. From there, Loops use context from your workspace and connected tools to decide on the next best action.

For example:

* Review incoming issues, research root causes, and dispatch to coding agents
* Create and coordinate follow-up work based on unstructured notes, like meeting transcripts or incident reports
* Keep launch plans and project specifications up-to-date
* *See more ways to use Loops in the [docs](https://linear.app/docs/loops.html#example-loops)*

[![](https://webassets.linear.app/images/ornj730p/production/f7b4a24a414f8ff6513a45f85978e48684cb3c10-1920x1080.jpg?q=95&auto=format&dpr=2)](https://webassets.linear.app/files/ornj730p/production/7eea0fd4bd8d2f019cb4f846cdb4b57ac444e1a4.mp4)

Elapsed00:00Remaining time unknown−--:--

0.25×0.5×0.75×1×1.25×1.5×1.75×2×

Loops run at the team and workspace level, with shared visibility and control. Anyone with access can review their instructions, see how they are configured, and inspect what happened during each run.

Loops are available today on Business and Enterprise plans and use AI credits. To help you get started and understand usage, we’re giving your workspace $20 per seat in promotional credits. These credits are applied automatically to runs, and expire on August 20, 2026.

Read the [blog post](https://linear.app/now/introducing-loops.html) to learn more.

Fixes

* Android

  Added a fallback page for auth redirects so users can reopen the app when browser handoff fails
* Asks

  Fixed Asks created by mentioning the Asks agent in private Slack channels weren’t syncing the originating thread to the issue
* Cycles

  Fixed archived cycles getting stuck behind persisted label and other view filters with no visible way to clear them
* Diffs

  Pull requests with more than 50 commits now loading up to 450 commits
* Documents

  Private team document templates now consistently appearing in the template selector
* Editor

  Fixed checklists pasted from Google Docs rendering incorrectly
* Email

  Prevented notification emails from being sent to deactivated users
* Inbox

  Fixed email intake issues not appearing in the assignee’s inbox when the intake template auto-assigned the issue back to the sender
* Integrations

  Fixed GitHub Enterprise Cloud installation webhooks routing to the wrong workspace region before the installation was known to Linear
* Integrations

  Fixed GitHub Enterprise Cloud setup showing a generic error when an IP allow list blocked Linear, with clearer guidance on allowing Linear IPs
* Notifications

  Fixed duplicate Slack notifications when a newly created issue is added to a view with Slack notifications enabled
* Projects

  Fixed project pages crashing when a graph tooltip referenced a stale date
* Pulse

  Added an unsubscribe action for Pulse items shown through team project update subscriptions
* Triage Intelligence

  Fixed Triage Intelligence no longer requiring destination teams to have workspace-wide scope to be eligible for suggestions

Improvements

* Agent

  Linear Agent can now manage inbox notifications
* Asks

  Email intake threads can now be resolved and unresolved
* Asks

  Synced comment threads (Slack and Asks) can now be resolved and unresolved, and a new reply reopens a resolved thread
* Comments

  Added inline issue description comments on iOS, including highlights in the description, tap-to-scroll to the thread, and quoted text above description comments
* Desktop

  Added support for Cmd+Z to restore accidentally closed tabs, with timeline-ordered priority and batch restore for bulk close operations
* Diffs

  Added the Diffs inbox as a default home view option
* Diffs

  Improved visibility of auto-merge status in review controls
* Diffs

  Showed failed checks in merge queue removal events
* Diffs

  Showed GitHub force-push events in pull request timelines
* Interface

  Added an Underline links preference under Interface and theme to always underline links in issue descriptions, comments, and documents
* Teams

  Added display options to team member lists for sorting, filtering by member type, and choosing visible columns

MCP server

* Improved attachment uploads to accept base64 payloads with whitespace or `data:` URL prefixes

[Older updates](https://linear.app/changelog/page/2.html)
