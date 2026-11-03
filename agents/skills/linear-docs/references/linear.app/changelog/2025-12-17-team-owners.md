---
title: "Team owners – Changelog"
source_url: "https://linear.app/changelog/2025-12-17-team-owners"
fetched_at: "2026-10-27T08:17:41.028425+00:00"
---



[Changelog](https://linear.app/changelog.html)

[December 17, 2025](https://linear.app/changelog/2025-12-17-team-owners.html) Share

[## Team owners](https://linear.app/changelog/2025-12-17-team-owners.html)

![Abstract illustration of two people icons centered on a dark background with a subtle radial motion effect, representing team ownership and permissions.](https://webassets.linear.app/images/ornj730p/production/32aa3ff07821269c4a286f4d12e4381592dd9d3a-3600x1800.png?q=95&auto=format&dpr=2)

We are introducing a new **team owner** role to give teams more control over their team settings. Alongside this new role, we’re adding team permissions so you can choose who can manage team settings, labels, templates, and membership — either any team member or only team owners. This empowers teams to define their own policies, while ensuring workspace owners and admins retain control over workspace-wide settings.

![Team settings permissions panel showing controls for settings management, label management, template management, and member management, with most actions restricted to team owners.](https://webassets.linear.app/images/ornj730p/production/8ca7091ca10ac77f34785e20b21bb410d38bd7e7-3600x1680.png?q=95&auto=format&dpr=2)

You can also control access and require an invite to join a team. Issues and projects of any team will still remain visible to everyone, and workspace owners and admins can always manage the settings for any team.

Configure these permissions on your team’s *Access and permissions* page. Team owners and permissions are available on Business and Enterprise [plans](https://linear.app/pricing.html). Learn more in the [docs](https://linear.app/docs/members-roles.html#team-owner).

## v0 by Vercel MCP connector[⁠](https://linear.app/changelog/2025-12-17-team-owners.html#v0-by-vercel-mcp-connector)

Access your Linear data from v0 to generate prototypes, dashboards, and internal tools. After connecting Linear’s MCP server, you can pull context from Linear issues, projects, and discussions when building in v0. [Learn more.](https://linear.app/integrations/v0.html)

Improvements

* Agents

  Improved visual aspects of agent chat interfaces to better surface responses, highlight associated pull requests, and automatically collapse agent thoughts after work completes
* Asks

  You can now explicitly link your Slack user ID with Linear when managing Asks settings to ensure you have access to private channels’ settings in Linear
* Editor

  Improved custom Slack emojis to appear when pasted if they are available in your Linear workspace
* Editor

  Improved support for pasting images with external links into Linear
* Editor

  Improved emojis in text pasted from Slack to be replaced with their Linear equivalent, or rendered as :emoji: if not available
* Editor

  Table cell and block (image, video, etc.) selections will now be visible to other users during collaborative editing
* Templates

  Disabled form templates in the sub-issue composer
* Video player

  Videos now generate automatic closed captions which are indexed for search

Fixes

* Actions

  Fixed `Cmd`/`Ctrl` `C` failing to copy title as link when the issue title already contains a markdown link
* Customers

  Fixed domain validation incorrectly rejecting valid public suffix domains when creating a customer
* Editor

  Fixed automatic scrolling of long tables when dragging to rearrange rows
* Editor

  Improved contrast of unchecked checklist checkbox borders in dark mode
* Editor

  Fixed `Shift` `Cmd` + Arrow keys inside of table cells to first select text before selecting the whole cell, and then the remainder of the row or column
* GitHub

  Fixed an issue that let users connect personal GitHub integrations before a workspace-level GitHub integration existed
* GitLab

  Stopped transitioning issues to review when a merged merge request receives comments or metadata updates.
* OAuth

  Fixed `oauthTokenMigrateOldToken` to successfully migrate old app tokens to the new short-lived tokens with a refresh token
* Project templates

  Fixed issue disappearing when selecting a team outside the project in project template editor
* Slack

  Fixed personal Slack connections to now be associated with a Slack workspace that is already connected to Linear for a Slack or Asks integration
* Projects

  Fixed choosing project dependencies to now prioritize projects you’re a member of

API

* Agents

  Added `promptContext` field to `AgentSessionEvent` “created” webhooks, a formatted string containing the relevant context for the agent session, including issue details, comments, and guidance
* Issues

  Filters on issue IDs now also accept identifiers

MCP server

* It is now possible to add and remove issues from project milestones
* Labels returned to the model will now include their group information
* Added support for project icon and color in `create_project` and `update_project` tools
* Added optional team filtering to `list_users` tool
