---
title: "Text attribution and agent-assisted editing – Changelog"
source_url: "https://linear.app/changelog/2026-07-23-agent-assisted-editing"
fetched_at: "2026-10-27T08:17:41.028425+00:00"
---



[Changelog](https://linear.app/changelog.html)

[July 23, 2026](https://linear.app/changelog/2026-07-23-agent-assisted-editing.html) Share

[## Text attribution and agent-assisted editing](https://linear.app/changelog/2026-07-23-agent-assisted-editing.html)

![a document and an agent panel showing the prompt to edit ](https://webassets.linear.app/images/ornj730p/production/15b9a90d9ef28e617836383f0b295536c437b4b1-3600x2080.png?q=95&auto=format&dpr=2)

Documents and project descriptions are critical context for your teams and agents.

You can now edit text with [Linear Agent](https://linear.app/docs/linear-agent.html), and use [Loops](https://linear.app/docs/loops.html) to keep docs and project descriptions up-to-date. Author name indicators let you check if text was written by a colleague or added by a loop.

When editing, changes you make through Linear Agent highlight separately so they’re easy to review. If you need to revert to an earlier version, restore to any previous checkpoint from version history.

Show author names or open version history from the `⌘`/`Ctrl` + `K` menu, or in document display options. Learn more in our [documentation](https://linear.app/docs/project-documents.html#edit-documents).

## Refreshed issue sidebar[⁠](https://linear.app/changelog/2026-07-23-agent-assisted-editing.html#refreshed-issue-sidebar)

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
