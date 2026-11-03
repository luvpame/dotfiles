---
title: "Advanced filters and share issues in private teams – Changelog"
source_url: "https://linear.app/changelog/2026-02-13-advanced-filters-and-share-issues-in-private-teams"
fetched_at: "2026-10-27T08:17:41.028425+00:00"
---



[Changelog](https://linear.app/changelog.html)

[February 13, 2026](https://linear.app/changelog/2026-02-13-advanced-filters-and-share-issues-in-private-teams.html) Share

[## Advanced filters and share issues in private teams](https://linear.app/changelog/2026-02-13-advanced-filters-and-share-issues-in-private-teams.html)

![Abstract filter graphic, blurred on left side and wide, to a defined point on the right](https://webassets.linear.app/images/ornj730p/production/3c1276b995a06c453e9170248239448b5c1eac30-3600x2080.png?q=95&auto=format&dpr=2)

Refine your searches, views, and dashboards with advanced filters. Combine multiple `AND`/`OR` conditions to define exactly what you want to see.

For example, track high-priority bugs for prospective customers in a single view by combining `Priority`, `Label`, and `Customer status` filters.

[Subscribe](https://linear.app/docs/custom-views.html#issue-view-subscriptions) to a view to get notified when issues match your conditions, or use advanced filters to power targeted dashboards.

Get started by choosing *advanced filter* from the filter menu, or use *AI filter* to describe what you’re looking for in natural language.

![Shows advanced filter group defining an or condition](https://webassets.linear.app/images/ornj730p/production/76a0de66dd1198cee29f081030c7437c78098d41-3600x1434.png?q=95&auto=format&dpr=2)

## Share issues from private teams[⁠](https://linear.app/changelog/2026-02-13-advanced-filters-and-share-issues-in-private-teams.html#share-issues-from-private-teams)

You can now share individual issues from private teams with specific users outside of the team. This is especially useful when bringing collaborators on to solve individual problems for highly sensitive teams, like security or HR. You can assign them a specific issue from your team without giving them access to the rest of the team’s data.

Shared issues will have a banner prominently displayed to indicate who that issue is visible to.

Private issue sharing is available on Enterprise plans. Learn more in our [docs](https://linear.app/docs/private-teams.html#share-issues-from-a-private-team).

![A shared issue from an HR team: Finalize compensation review timeline](https://webassets.linear.app/images/ornj730p/production/d6e6d60f6a7b28110527c5d6dfabe2706bf66f5f-3600x1720.png?q=95&auto=format&dpr=2)

## Create projects and initiatives on Android and iOS[⁠](https://linear.app/changelog/2026-02-13-advanced-filters-and-share-issues-in-private-teams.html#create-projects-and-initiatives-on-android-and-ios)

Capture ideas on the go by creating new projects and initiatives on Linear’s mobile apps. Write project summaries and properties to express your intent, then build out full descriptions and milestones later.

## Gemini Enterprise connector[⁠](https://linear.app/changelog/2026-02-13-advanced-filters-and-share-issues-in-private-teams.html#gemini-enterprise-connector)

Gemini Enterprise users can now create issues from Gemini, and access data from their existing issues and projects. Learn more in our [docs](https://linear.app/integrations/gemini-enterprise.html).

Improvements

* Agent

  Linear Agent for Slack can now add images from a conversation to existing entities
* Android

  Added ability to copy, edit, and remove issue link attachments via long-press menu
* Desktop

  Added option to show notification count in app dock
* Importers

  Improved handling of importing closed or done issues; we will now no longer import issues as archived if active parent/sub-issues exist
* Insights

  Tables on insights using a slice related to a date (like slice by “Created at”) will be sorted from the most recent date to the oldest date top to bottom
* IOS

  Users can now add link attachments to issues directly from the issue screen
* Performance

  Improved performance when using certain browser security extensions
* Triage Intelligence

  Issue suggestions popover now shows created/completed timestamps to help identify older issues that may be less relevant

API

* Customers

  `CustomerNeed.url`, deprecated in December 2024 in favor of the `attachmentUrl` field, is now removed
* Markdown

  Videos from websites like YouTube and Loom will automatically be turned into embeds if added as `![](https://linear.app/changelog/link/to/video)`

MCP server

* Added project resources to MCP responses
* Added the ability to list project members

Fixes

* Attachments

  Fixed Jira link attachments overriding custom link titles
* Customer Requests

  Fixed customer requests being hidden after restoring an issue from an archived project
* Editor

  You will now be prompted to save or discard unsaved editor changes when closing or refreshing Linear
* Editor

  Code blocks are now visible when printing
* GitHub

  Fixed GitHub sync not updating the issue body when the description was updated via the API
* GitHub

  Fixed GitHub integration configuration page that was redirecting users to a desktop app
* Triage

  Fixed alignment of spacing in triage inbox with notification inbox
* Updates

  Fixed project update drafts that will no longer be lost when opening Linear in another tab
* Slack

  Fixed Slack notifications toggle that could get stuck in an indefinite loading state
