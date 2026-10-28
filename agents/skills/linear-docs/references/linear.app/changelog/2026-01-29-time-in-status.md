---
title: "Time in status – Changelog"
source_url: "https://linear.app/changelog/2026-01-29-time-in-status"
fetched_at: "2026-10-27T08:17:41.028425+00:00"
---



[Changelog](https://linear.app/changelog.html)

[January 29, 2026](https://linear.app/changelog/2026-01-29-time-in-status.html) Share

[## Time in status](https://linear.app/changelog/2026-01-29-time-in-status.html)

![a screenshot of the time in status UI](https://webassets.linear.app/images/ornj730p/production/e3d311d10fbbce382a9142fd6dab1a25198b3023-3600x2080.png?q=95&auto=format&dpr=2)

Time spent in individual statuses is now tracked and available throughout Linear. Hover over any issue’s status indicator to see the cumulative time it’s spent in each status. You can use this to spot where things are getting stuck, identify bottlenecks, and optimize your development process.

On lists and boards, you can see how long items have been in their current status. Order by `time in status` to surface blocked work, or filter by conditions like `In Review > 7 days` to catch issues that have fallen through the cracks.

In Insights and Dashboards, analyze the time spent in any status and slice by time period or other attributes to see how performance changes and differs across your workspace. Use this to quickly uncover systemic bottlenecks and outliers.

![A screenshot of time in status in the Insights panel](https://webassets.linear.app/images/ornj730p/production/11a1b1a2e88cb42d8567c3f7ecc0f148e75e8768-3600x2328.png?q=95&auto=format&dpr=2)

Time in status is available as a [display option](https://linear.app/docs/display-options.html) in views, and as a new measure in [Insights](https://linear.app/docs/insights.html).

## Jira Epic sync[⁠](https://linear.app/changelog/2026-01-29-time-in-status.html#jira-epic-sync)

We’ve upgraded our [Jira](https://linear.app/integrations/jira.html) integration to support bi-directional syncing between Jira Epics and Linear projects. Changes to properties like status, target date, and description automatically reflect in both applications, so you don’t have to update them manually.

Configure the Jira integration from your Linear workspace’s [integration settings](https://linear.app/settings/integrations/jira.html).

Fixes

* Boards

  Fixed horizontal scroll position not being restored on the board view when using rows grouping
* Comments

  Fixed showing both when a comment was created and edited
* Editor

  Fixed slash command sub-menus to be selectable using the mouse (instead of just the enter key)
* Editor

  Fixed drag-to-reorder todo items not working in Firefox
* Filters

  Fixed incident.io link filters failing to match issues
* Integrations

  Fixed connecting Slack channels from the desktop app
* Issues

  Fixed issue properties overflowing at certain screen widths
* Projects

  Fixed a bug where milestone content or other data could be lost during project creation if the server returned an error
* Settings

  Fixed label search not updating correctly when switching between workspace and team label pages
* Settings

  Fixed team member lists not refreshing after members were added or removed

Improvements

* Android

  Added support for creating a project and editing project title and summary
* Android

  Added the ability to filter inbox notifications by category
* Importers

  Issue numbers are now preserved from the source tool during imports when the destination team is empty, even if the team was created outside the import flow
* Integrations

  Improved error notifications when Linear can’t connect to a self-managed GitLab instance
* iOS

  Added support for creating a project and editing project title and summary
* iOS

  You can now toggle todo checkboxes in issue descriptions without entering the editor
* Issues

  Improved assignee search by ranking Project and Team members higher than others
* Lightbox

  Improved zoom controls for the image lightbox

MCP server

* In `update_issue`, allowed `assignee` and `delegate` to be set to `null` to remove them.
* In `update_project`, allowed `lead` to be set to `null` to remove it
