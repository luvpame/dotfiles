---
title: "Linear for Microsoft Teams – Changelog"
source_url: "https://linear.app/changelog/2026-04-16-linear-for-microsoft-teams"
fetched_at: "2026-10-27T08:17:41.028425+00:00"
---



[Changelog](https://linear.app/changelog.html)

[April 16, 2026](https://linear.app/changelog/2026-04-16-linear-for-microsoft-teams.html) Share

[## Linear for Microsoft Teams](https://linear.app/changelog/2026-04-16-linear-for-microsoft-teams.html)

[![](https://webassets.linear.app/images/ornj730p/production/272e7804f2703e6243b843cf2ea1a8b4e7f1de4e-3840x2160.jpg?q=95&auto=format&dpr=2)](https://webassets.linear.app/files/ornj730p/production/de2b6082124d14723003096c177d2b98a736cbab.mp4)

Elapsed00:00Remaining time unknown−--:--

0.25×0.5×0.75×1×1.25×1.5×1.75×2×

Mention **@Linear** in any Microsoft Teams channel to turn your conversations into actionable work.

You can ask Linear to make changes directly in Linear, or pull information from Linear into Teams. Try it by sending a message like:

* **@Linear** file a bug for this and assign it to me
* **@Linear** what’s the latest progress on our billing API project?
* **@Linear** create issues for each feature request mentioned in this video

### Keep everyone up to date on progress[⁠](https://linear.app/changelog/2026-04-16-linear-for-microsoft-teams.html#keep-everyone-up-to-date-on-progress)

Connect your Linear projects to Teams channels to keep everyone aligned. After connecting, project notifications like updates will automatically post to Teams.

![project update in Teams showing progress since march 19th, with a description of changes in the core performance project. ](https://webassets.linear.app/images/ornj730p/production/de21aba5590c771b7e55e6ac87c43447275a38c6-3600x1920.png?q=95&auto=format&dpr=2)

Install Linear for Microsoft Teams in [settings](https://linear.app/settings/integrations/microsoft-teams.html), or learn more in our [documentation](https://linear.app/integrations/microsoft-teams.html).

## Custom coding tool integrations[⁠](https://linear.app/changelog/2026-04-16-linear-for-microsoft-teams.html#custom-coding-tool-integrations)

Linear already supports [one-click integrations](https://linear.app/changelog/2026-02-26-deeplink-to-ai-coding-tools.html) to open issues in popular tools like Claude Code, Codex and Cursor. To better support custom workflows and new tools, we’ve added support for custom coding tool integrations.

Custom coding tool integrations let you open issues in tools that aren’t supported out of the box. You can configure them in two ways:

* Launch a tool using a URL with query parameters
* Run a local command from the desktop app

Add a new custom coding tool in [preferences](https://linear.app/settings/account/preferences/coding-tools.html), or learn more in our [documentation](https://linear.app/docs/assigning-issues.html#open-issues-in-coding-tools).

## Sync multiple Slack threads to an issue[⁠](https://linear.app/changelog/2026-04-16-linear-for-microsoft-teams.html#sync-multiple-slack-threads-to-an-issue)

When an issue is reported in Slack, either through Asks or the Linear Agent, a synced thread is added to that issue to enable follow-up communication.

Now you can sync an issue to multiple Slack threads when there are multiple reports or requests for the same issue. When the issue is completed, every synced thread receives an update with the outcome.

Connect a new Slack thread to an issue by mentioning **@Linear** or using the “Link to existing issue” option in the Slack integration.

Fixes

* Agent

  Fixed text selection escaping the agent conversation panel into the document editor when dragging upward
* Agent

  Fixed the assignee field not showing “No assignee” when the issue is delegated to an agent
* Asks

  Fixed a bug where “Manage team templates” could link to an inaccessible page in private teams.
* Command Menu

  Fixed labels not appearing as suggestions when typing in `Cmd/Ctrl` `K`
* Comments

  Fixed a bug where inline comments in documents were not clickable
* Custom Views

  Fixed an issue that prevented transferring ownership of custom views
* Customer requests

  We no longer send an Inbox notification when a customer request is moved to a new issue after the original issue is marked as a duplicate
* Customers

  Fixed customer status filter showing incorrect result counts on the Customers page
* Documents

  Fixed a bug where document header icons could overlap with long titles on narrow screen widths
* Editor

  Fixed an issue where images and videos could display a permanent loading spinner in the editor
* GitHub

  Fixed silent integration connection errors for GitHub; a proper error now displays when appropriate
* GitHub

  Fixed an issue where reconnecting a GitHub organization would fail if a different user than the original integration creator performed the reconnect
* Importer

  Fixed a bug in the Jira importer that caused typing in the JQL filter field to be very slow
* Inbox

  Fixed issue details sidebar flashing when switching between issue notifications
* Inbox

  Fixed a visual glitch where the “added as project member” notification showed both a highlight ring and a blue dot on the members pill
* Inbox

  Fixed keyboard focus being lost in Inbox after deleting notifications
* Integrations

  Fixed Salesforce workspace selection getting stuck during setup
* Issue Templates

  Fixed form templates not respecting the relevant project when creating an issue from within a project view
* Labels

  Fixed clicking on issue counts in team label settings occasionally not opening the list of issues with that label
* Labels

  Fixed labels not showing all options on the first open of the issue create and triage accept modals
* Performance

  Fixed a crash for some invited users on first login
* Project Updates

  Fixed an issue where the project update composer would occasionally lose focus while typing if the same update was open in multiple tabs
* Projects

  Fixed project pages always returning to the Overview tab instead of preserving the last visited tab
* Pulse

  Fixed Pulse creation getting stuck when no projects are available in the workspace
* Search

  Fixed project search dropping matching results mid-typing if the project name contained `&` or `+`
* Settings

  Fixed BAA document download being unavailable after enabling HIPAA compliance
* Settings

  Fixed incorrect help documentation link on Documents settings page
* Settings

  Fixed content shift caused by scrollbar appearing/disappearing on integration settings pages
* Settings

  Fixed a bug where the create issue shortcut could be triggered while adding members
* Slack

  Fixed a bug where customer requests created from Slack threads could display No Customer instead of the channel’s linked customer
* Slack

  Fixed agent-posted replies not appearing in synced Slack threads
* Teams

  Retired teams are now correctly not counted towards team limits on Basic and Free plans
* Themes

  Fixed Ask Linear toolbar text being unreadable on dark sidebar backgrounds with custom themes
* Themes

  Fixed theme import modal not closing after saving a legacy comma-separated theme
* Timeline

  Fixed some display options that were not responding to clicks
* Triage

  Fixed triage issues jumping to the top of the list when moved to another team’s triage
* Triage

  Fixed a bug where round robin assignment could skip some users
* Triage Intelligence

  Fixed label filters in Triage Intelligence settings not showing team-specific labels
* Triage Rules

  Fixed triage rules incorrectly showing “Deleted label” for team-scoped labels
* Updates

  Fixed update submission dialog briefly flashing an empty input before closing
* Views

  Fixed some missing cycles from sub-teams when grouping an issue list by cycles
* Webhooks

  Fixed team-scoped webhooks not delivering document events for issue and cycle documents
* Workspace menu

  Fixed new workspaces not appearing in the workspace switcher on other clients until refresh

Improvements

* Agent

  It’s now easier to change your default home view on new tab from Linear Agent to other options like Inbox
* Agent

  Agent toolbar notification pips now use blue color to match inbox unread indicators
* Editor

  Titles are now automatically suggested when creating an issue from a comment
* Insights

  The Insights panel now fills the full height of the sidebar
* Integrations

  OAuth and integration popups now open centered over the current browser window instead of the primary screen
* Milestones

  Simplified project milestone deletion to use a simple confirmation dialog instead of requiring typed confirmation
* Performance

  Improved performance when loading issue views in large workspaces
* Project Updates

  Removed milestones no longer appear in project update progress menu
* Pulse

  Pulse entries now lead with a one-sentence takeaway for faster scanning
* Pulse

  Project popovers now show the project’s teams

MCP server

* Fixed an issue where MCP OAuth connections could disconnect after ~1 day

API

* Fixed initiative and project filtering by `healthWithAge`
* Fixed `documentUpdate` mutation failing when called with a URL-style document identifier instead of a UUID

Keyboard shortcuts

* Added keyboard shortcut `Shift` `Cmd/Ctrl` `6` for converting text to a collapsible section
