---
title: "Dashboards – Changelog"
source_url: "https://linear.app/changelog/2025-07-24-dashboards"
fetched_at: "2026-10-27T08:17:41.028425+00:00"
---



[Changelog](https://linear.app/changelog.html)

[July 24, 2025](https://linear.app/changelog/2025-07-24-dashboards.html) Share

[## Dashboards](https://linear.app/changelog/2025-07-24-dashboards.html)

## [⁠](https://linear.app/changelog/2025-07-24-dashboards.html#)

[![](https://webassets.linear.app/images/ornj730p/production/167498b3943e158412f9c41f3b226d2600a0b84f-2880x1440.jpg?q=95&auto=format&dpr=2)](https://webassets.linear.app/files/ornj730p/production/4e112eea5d379761f988064e2103a24ecabcfc9f.mp4)

Elapsed00:00Remaining time unknown−--:--

0.25×0.5×0.75×1×1.25×1.5×1.75×2×

Create dashboards to track key metrics for your team or workspace.

Dashboards let you combine data from different insights into a single page view. Use them to monitor operational health across teams and workflows or build reporting dashboards to show how resources are spent across initiatives and projects.

![Bug & Cycle performance dashboard showing a graph of issue volume over time, chart of current open bugs categorized by priority, that there is a median triage time of 58 minutes, and additional graphs for bug resolution time trailing 90d and age of bugs.](https://webassets.linear.app/images/ornj730p/production/8c8a45a96ee7b0eaedccd78907319ceeefa895ba-3600x1638.png?q=95&auto=format&dpr=2)

Dashboards are modular and customizable. You can display insights as charts, tables, or single-number metrics, depending on your needs. Dashboards can be filtered to target a specific team or scope. Drill into specific insights and segments to view the underlying issues and examine patterns or outliers. From there, take action—assign work, update statuses, or triage directly from the issue list.

You can share dashboards with your workspace, to a specific team, or kept private as personal dashboards. To create your first dashboard, go to the [Dashboards tab](https://linear.app/dashboards.html) under *Views* or start from an existing insight and choose *Add to dashboard*.

![The insights sidebar is open showing a single insight, with the contextual dropdown menu open and the "Add to dashboard" option selected](https://webassets.linear.app/images/ornj730p/production/a3929f1efec9775e1ecd2d53a1ad9ad2032b4f60-3600x1638.png?q=95&auto=format&dpr=2)

Dashboards are available on the [Enterprise plan](https://linear.app/pricing.html) or with an enterprise trial starting today. Learn more in the [docs](https://linear.app/docs/dashboards.html) and watch the demo video below.

[![](https://webassets.linear.app/images/ornj730p/production/fdadc29970294afef9df69022dcced981d7b1598-5120x2880.png?q=95&auto=format&dpr=2)](https://webassets.linear.app/files/ornj730p/production/4f479120a8371aa2c35cadb258d9f7ad87906198.mp4)

Elapsed00:00Remaining time unknown−--:--

0.25×0.5×0.75×1×1.25×1.5×1.75×2×

## Quick navigation in Settings[⁠](https://linear.app/changelog/2025-07-24-dashboards.html#quick-navigation-in-settings)

Navigate between pages in [Settings](https://linear.app/settings/account/preferences.html) using the command menu (`Cmd/Ctrl` `K`). From anywhere else in the app, use `O` then `S` to find and open a specific Settings page.

![The command menu in settings showing different settings pages you can quickly navigate to like preferences, notifications, and SLAs](https://webassets.linear.app/images/ornj730p/production/3c2b17b023bc6cac386cfb93c073a3ddf55e1b53-3600x1638.png?q=95&auto=format&dpr=2)

## Notion AI Connector[⁠](https://linear.app/changelog/2025-07-24-dashboards.html#notion-ai-connector)

Search across Linear projects and issues directly from Notion AI. Once you’ve [set up](https://www.notion.com/help/notion-ai-connector-for-linear) the integration, Notion AI will have access to all project and issue details including the title, description, assignee, creator, and issue comments.

Improvements (10)

* Asks

  When a Linear user creates an Ask from Slack, they are now automatically subscribed to the Linear issue if they have access to the issue’s team
* Customer Requests

  It’s now possible to filter by important customer count on issues and projects views
* Customer Requests

  Added a due date and target date display option for customer page requests
* Customer Requests

  Added automatic duplicate name detection when creating customers
* Filters

  You can now filter issue views by invited users
* GitHub

  We now automatically create a personal GitHub integration for the admin installing GitHub in the Linear workspace
* Project templates

  Improved the ability to clear the template that was applied while creating a project
* Projects

  It’s now possible to select multiple projects and add or remove teams in bulk
* Settings

  Improved layout of settings pages on devices with small screens
* Improved the ability to dismiss the app status banner, which shows up in case of service interruptions

Fixes (5)

* Desktop

  Fixed the scroll position being reset when switching tabs after navigating using the command menu
* Editor

  Fixed resizing columns after scrolling a table horizontally
* Editor

  Fixed creating code blocks from ```` ``` ```` in nested lists
* Pull request reviews

  Fixed pull request review comments not syncing properly in some scenarios
* Triage

  Fixed a bug where a team’s explicit priority requirement for an issue to leave Triage could be bypassed if the issue was previously in Triage in a different team

MCP server (3)

* Added pagination to `list_issues`
* Replying to comment threads is now supported
* Fixed text content being truncated in responses unnecessarily

Keyboard shortcuts (1)

* When in Settings, use `Cmd/Ctrl` `K` to navigate between pages
* `O` then `S` to navigate to a specific Settings page when outside of Settings
