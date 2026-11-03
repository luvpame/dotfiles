---
title: "Introducing Linear Agent – Changelog"
source_url: "https://linear.app/changelog/2026-03-24-introducing-linear-agent"
fetched_at: "2026-10-27T08:17:41.028425+00:00"
---



[Changelog](https://linear.app/changelog.html)

[March 24, 2026](https://linear.app/changelog/2026-03-24-introducing-linear-agent.html) Share

[## Introducing Linear Agent](https://linear.app/changelog/2026-03-24-introducing-linear-agent.html)

[![](https://webassets.linear.app/images/ornj730p/production/7f2d7219355b015e6b32632ae3827b2e0f50aa8e-1920x960.png?q=95&auto=format&dpr=2)](https://webassets.linear.app/files/ornj730p/production/c8530d6578e71e2e6c1461778f1fe599bb5f0e00.mp4)

Elapsed00:00Remaining time unknown−--:--

0.25×0.5×0.75×1×1.25×1.5×1.75×2×

[Try Linear Agent](https://linear.app/agent.html)

*We’re excited to share the next major step in Linear’s evolution. For the vision behind Linear Agent, read [the letter from our CEO, Karri](https://linear.app/next.html).*

As execution accelerates, the bottleneck in product development shifts toward judgment: deciding exactly what to build and where your team’s time, attention, and tokens are best spent.

Your workspace already contains much of the context needed to drive good product decisions, but getting to it means reading through threads, combing the backlog, reviewing customer requests, and piecing together what’s relevant.

Linear Agent brings all of that context within reach.

Built directly into Linear, and accessible everywhere, Linear Agent understands your roadmap, issues, and code. It can help you synthesize context, make recommendations, and take action.

![Inline agent session examples, creating issues from an uploaded video](https://webassets.linear.app/images/ornj730p/production/7fc0d29a391b03f9e66c2c785c8b6e98b49dd3ef-3600x2560.png?q=95&auto=format&dpr=2)

For example, when starting a new project, instead of manually researching past feature requests, you can ask Linear to find related issues, group them by relevance, and pull the right ones in. From there, ask it to extract common requirements across customer requests and scope out a starting point for your spec — all in a few minutes.

Linear Agent is powered by frontier language models and fully grounded in the context of your workspace. Use it to supercharge your everyday workflows:

* In Slack, send: *“@Linear* *Make issues based on the discussion here and assign them to me”*
* When writing a project update, tell it: *“I’m writing an update for this project. What’s changed recently, and what should I include?”*
* When planning your next cycle: *“Read this backlog and pull out repeated themes that we can prioritize”*
* When you come back from time off and need to know what’s going on: *“Is anything at risk or falling behind that I should be aware of?”*

Linear Agent works with you wherever you are. Open a chat from the bottom-right of the desktop app (shortcut `Cmd/Ctrl + J`) or the mobile app, or mention `@Linear` in any comment or reply. It’s also available in [Slack](https://linear.app/docs/slack.html#linear-agent-for-slack) and [Microsoft Teams](https://marketplace.microsoft.com/en-us/product/WA200010301?tab=Overview).

## Skills and Automations[⁠](https://linear.app/changelog/2026-03-24-introducing-linear-agent.html#skills-and-automations)

As you use Linear Agent, you’ll find workflows worth repeating. When a conversation gets you to a good result, you can ask Linear to save it as a reusable skill. This is especially useful for recurring workflows, like catching up on projects or drafting issues from meeting notes. Run a skill from the skills menu in any chat or with a slash command. Linear will also automatically use skills when it thinks they are applicable.

![Skill loaded in agent chat by pressing / and selecting "Split into sub-issues" skill](https://webassets.linear.app/images/ornj730p/production/be942ac7b04dbbe2a45b02838852f495c237cd51-3600x1920.png?q=95&auto=format&dpr=2)

You can also trigger agent workflows automatically when issues enter triage. Every new issue adds context to your workspace, and Linear can intelligently help you refine, synthesize, or act on it.

Automations are available on Business and Enterprise plans.

![Customer context automation adding a summary of customer impact to the issue entering triage](https://webassets.linear.app/images/ornj730p/production/fc989a7efb1e16a5ac8aca92c4ac1502fcad3fc1-3600x1982.png?q=95&auto=format&dpr=2)

## Code Intelligence (coming soon)[⁠](https://linear.app/changelog/2026-03-24-introducing-linear-agent.html#code-intelligence-(coming-soon))

We’re also announcing Code Intelligence, a capability that extends Linear Agent’s understanding to your codebase. Once enabled, it supports code-aware tasks like diagnosing app functionality and designing technical specifications.

Non-technical teammates can ask questions they’d normally have to track down an engineer to answer — how a feature works, who owns a system, what recently changed — and get a reliable response.

Code Intelligence is coming soon to Business and Enterprise plans.

![Agent chat open, user asking a question about their codebase -- how does the payments service handle failed transactions?](https://webassets.linear.app/images/ornj730p/production/0708264e2d939cd6bc059a8909283f86c18d7abc-3600x1920.png?q=95&auto=format&dpr=2)

## Availability and pricing[⁠](https://linear.app/changelog/2026-03-24-introducing-linear-agent.html#availability-and-pricing)

Linear Agent is now available in **public beta** for all teams. Agent and Skills are included on all Linear plans. Automations and Code Intelligence are available on Business and Enterprise.

During the beta period, all features are available at no additional cost as we refine and expand the product.

At general availability, we expect chat functionality — in-app, in comments, Slack, and Microsoft Teams — to remain included in the base seat price. High-volume compute capabilities like Automations and Code Intelligence may move to usage-based pricing beyond a certain threshold.

We’ll provide clear advance notice before any pricing changes take effect. [Reach out](https://linear.app/contact.html) if you have any questions.

Improvements

* Asks

  Slack channel mentions in form submissions now display the channel name with a link (instead of ID)
* Documents

  Added hover tooltips showing user names in multi-user version history
* Editor

  Added a command to change displayed properties (milestones, projects, etc.)
* Editor

  Added syntax highlighting for ReScript (.res, .resi) files
* Editor

  Milestones now appear in the @-mention menu when writing project updates
* Editor

  Improved text selection when mentions are at the start and end of lines
* OAuth

  Clarified webhook warning to indicate reauthorization is required for existing installations
* Projects

  Added `Description` field to display options for `Projects` list views
* Settings

  Added search to the timezone selector in team settings
* Triage Rules

  Added support for removing an issue’s assignee

Fixes

* Cycles

  Fixed right side overflow in cycle detail view
* Cycles

  Fixed cycle tabs only showing the team name instead of the cycle name
* Exports

  Fixed Google Sheets exports failing when spreadsheets exceed size limits; exports are now disabled with notification and can be re-enabled with a fresh sheet
* GitHub

  Fixed issue attachment links not updating after repository renames
* Importers

  Fixed projects imported from Shortcut epics being incorrectly archived across shared teams
* Initiatives

  Fixed manual sort order not persisting when reordering sub-initiatives in custom initiative views
* iOS

  Fixed date mentions using incorrect time zone
* iOS

  Fixed initiative reminder notifications opening an unsupported page instead of the update composer
* Issues

  Restored the copy branch name button in the post-creation toast
* Issues

  Fixed blank description and activity feed during initial load
* Issues

  Fixed project property from templates not applying via template URLs
* Milestones

  Fixed Slack notifications no longer showing progress percentage for removed milestones
* Notifications

  Fixed view subscription notifications for due date window filters so issues now trigger when entering a bounded range
* Projects

  Fixed project association being removed when creating issues for teams not yet in the project; now prompts to add the team
* Security

  API keys now persist across suspend/unsuspend cycles (inactive while suspended)
* Settings

  Fixed a bug causing the admin modal to appear empty on first open
* Triage

  Fixed a sporadic 404 when moving issues between teams

API

* GraphQL subscriptions can now be used with the API
* Added filtering to issue created/updated GraphQL subscriptions
* Added the `Team.parent` field in the public API
* Added validation of template `descriptionData` against the ProseMirror schema to reject invalid node types

MCP server

* Added support for pagination in the `list_comments` tool via `cursor`, `limit`, and `orderBy` parameters
* Improved initiatives to now return and accept multiple parent initiatives instead of a single parent

Keyboard shortcuts

* Use `G` then X to open the team archive
* `Cmd`/`Ctrl` `J` now opens Linear Agent
