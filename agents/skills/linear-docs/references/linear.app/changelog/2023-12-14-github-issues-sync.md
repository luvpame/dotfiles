---
title: "GitHub Issues Sync – Changelog"
source_url: "https://linear.app/changelog/2023-12-14-github-issues-sync"
fetched_at: "2026-10-27T08:17:41.028425+00:00"
---



[Changelog](https://linear.app/changelog.html)

[December 14, 2023](https://linear.app/changelog/2023-12-14-github-issues-sync.html) Share

[## GitHub Issues Sync](https://linear.app/changelog/2023-12-14-github-issues-sync.html)

![GitHub and Linear logos with arrows indicating a two-way sync or communication](https://webassets.linear.app/images/ornj730p/production/0be7cb5beef4d05eb14104cd4300fca003c6da7d-3312x1734.png?q=95&auto=format&dpr=2)

## GitHub Issues Sync[⁠](https://linear.app/changelog/2023-12-14-github-issues-sync.html#github-issues-sync)

We’ve heard your feedback that you would like to manage issues for open source projects in Linear. With GitHub Issues Sync, your OSS issues can now be synced *bidirectionally* between GitHub and Linear. This lets you triage and discuss your community requests in the same place as all of your other work.

* Issues in linked GitHub repositories will show up in Linear.
* Title, description, status, labels, assignee, and comments on the GitHub issue will sync across both applications.
* Reply to GitHub issue comments from Linear via the synced thread or have separate, private discussions in the issue with your teammates.

To start ingesting issues from your OSS repository, set up the integration in [GitHub Integration settings](https://linear.app/settings/integrations/github.html).

## Integrations gallery[⁠](https://linear.app/changelog/2023-12-14-github-issues-sync.html#integrations-gallery)

You can now browse and search for all integrations, including those made by third parties, in the [new integrations gallery](https://linear.app/settings/integrations.html) in workspace settings. Individual integrations settings pages have been updated to include screenshots, a detailed description, and configuration instructions.

Improvements & Fixes

* Fixed an issue preventing renaming favorite folders on touch devices
* Converting between different list types now also works for nested lists
* Fixed a bug where contextual menus would not scroll correctly when using up and down arrow keys
* We now show your next Triage responsibility shift when using PagerDuty
* Fixed a bug in project views where the “Show empty groups” options would not work as intended
* Blocking and blocked issue relations now have a new icon that better indicates whether they are blocked or blocking
* You will now receive a Slack notification for the synced Slack thread that is created in your messages with the Linear Asks app when you create a private ask through Linear Asks app home
* You can now select up to 10 templates to use when creating an issue using the Slack integration. This has been increased from the previous limit of 5.
* Fixed incorrect workflows assigned to a team that prevented issue creation from custom views
* Search shortcuts in the command menu now have an icon to better indicate that you’re searching against a partial set of entities
* Fixed search not showing archived documents
* If cycle automation settings are enabled, issues that are started or completed during a cycle cooldown period will now be assigned to the next cycle if they are not currently in any cycle
* Fixed a problem with connecting project updates to a project channel
* Fixed a problem with filter menu misplaced when the sidebar is collapsed
* Added label, assignee, and project milestone suggestions to the Triage accept dialog
* Linking a GitHub PR now works correctly with multiple connected GitHub organizations
* You can now change the start and end date of individual cycles
* Changed the max width of project documents
* Fixed a broken “View authorized applications” link in OAuth-related email
* [Webhooks] Added support for issue and project update reactions
* [API] Added ability to filter comments by corresponding project update and document content
* [API] Fixed a problem that would cause errors when fetching the added or removed labels of an issue using its history field when the referenced label had been deleted
