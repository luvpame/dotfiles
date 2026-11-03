---
title: "Multi-level sub-teams – Changelog"
source_url: "https://linear.app/changelog/2026-04-09-multi-level-sub-teams"
fetched_at: "2026-10-27T08:17:41.028425+00:00"
---



[Changelog](https://linear.app/changelog.html)

[April 9, 2026](https://linear.app/changelog/2026-04-09-multi-level-sub-teams.html) Share

[## Multi-level sub-teams](https://linear.app/changelog/2026-04-09-multi-level-sub-teams.html)

![Cascading sub-teams that read: Engineering, Infra, Mobile, Android, iOS](https://webassets.linear.app/images/ornj730p/production/c54265ffc54572c43a25fbd75d64be26222d0b29-3600x1800.png?q=95&auto=format&dpr=2)

Structure your teams in Linear to match how your organization works.

Teams can nest up to five levels deep, making it possible to represent divisions, departments, groups, squads, and more. Sub-teams inherit workflows and settings from their parents at every level, so you can maintain consistency while giving each unit flexibility in how they work.

Multi-level sub-teams are available on the Enterprise plan. Learn more in our [docs](https://linear.app/docs/sub-teams.html).

## Project and initiative comments[⁠](https://linear.app/changelog/2026-04-09-multi-level-sub-teams.html#project-and-initiative-comments)

Projects and initiatives now support comments in their activity feed, giving teams a place for high-level discussion alongside updates. Conversations stay attached to the work itself, making it easier for both people and agents to follow and reference.

![Comment thread on a project: what direction should we take for the first version, I'd go with the simpler path first and learn from real usage, Yeah we can always add depth later, but the core flow should be obvious now, Ship the simpler version first](https://webassets.linear.app/images/ornj730p/production/8ea3eb8ff10d0e1340e9acc8ad9e021c8d7f3f94-3600x2058.png?q=95&auto=format&dpr=2)

Use comments to:

* provide lightweight feedback that doesn’t belong in an inline comment or formal update
* discuss open questions and resolve threads once decisions are made
* capture meeting takeaways and mention @Linear to update docs, revise descriptions, and create issues

Fixes

* Agent

  You can now search past agent chats from the `Cmd/Ctrl``K` menu
* API

  Fixed initiative filtering by team
* API

  Fixed workflow state positions being unexpectedly reordered when resolving position collisions
* Asks

  Fixed Slack Block Kit messages losing rich content during automatic Ask creation
* Code Block

  Fixed syntax highlighting not appearing when a code block language was set via Markdown paste or the VS Code clipboard
* Comments

  Fixed comment permalinks not scrolling to the target comment after the first click
* Customer requests

  Fixed customer request notifications being sent to users who don’t have access to the private team containing the issue or project
* Editor

  Fixed a performance issue when editing collaborative documents in Firefox
* Editor

  Fixed mentions not being inserted when clicking the mention menu in Safari
* Editor

  Fixed video and audio players no longer stealing focus when a user is typing or has a text field in focus
* Editor

  Fixed pasted GitHub comments rendering as tables instead of plain text
* Filters

  Fixed duplicate filter conditions being added
* GitHub

  Fixed GitHub Enterprise Cloud integration settings not showing all installed organizations
* GitHub

  Fixed the integration settings page linking to github.com instead of the configured enterprise instance
* Issue Views

  Fixed deleting a view from the view details page navigating home instead of back to the views list
* Projects

  Fixed deleting an issue from a project board navigating to My Issues instead of back to the project
* Search

  Fixed search input dropping initial keystrokes when typing immediately after pressing “/”
* Slack

  Fixed Slack table attachments not appearing in synced issue comments
* Triage

  Fixed the Copy submenu on triage suggestions copying the parent issue’s data instead of the suggested issue’s data

Improvements

* Agent

  Agent no longer asks for confirmation on routine bulk updates of up to 5 issues
* API keys

  Improved scope information shown for each API key
* Asks

  Added a browser prompt before leaving an unsubmitted Ask with unsaved changes
* Editor

  Improved @mention hover cards so you can move your cursor into them
* Focus

  Improved grouping so pull requests that close an issue appear under that issue’s project when grouped by project
* GitHub

  Added support for magic words in revert pull request descriptions
* OAuth

  Added a last used date to application OAuth tokens when available
* Projects

  Project activity now shows when Slack channel creation fails, including the reason

MCP server

* Issues

  Issues created through the MCP without a `stateId` now default to the team’s default state, even when triage is enabled, if the user is a member of the team
