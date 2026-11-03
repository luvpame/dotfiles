---
title: "Triage responsibility – Changelog"
source_url: "https://linear.app/changelog/2023-10-12-triage-responsibility"
fetched_at: "2026-10-27T08:17:41.028425+00:00"
---



[Changelog](https://linear.app/changelog.html)

[October 12, 2023](https://linear.app/changelog/2023-10-12-triage-responsibility.html) Share

[## Triage responsibility](https://linear.app/changelog/2023-10-12-triage-responsibility.html)

![Triage view open with a dropdown showing that Kenneth is the current assignee responsible for triaging issues, and Leela will take over next week respon](https://webassets.linear.app/images/ornj730p/production/d9ba17e720467c7a48dec0918b0d1b73ba2408d0-3312x1734.png?q=95&auto=format&dpr=2)

## Triage responsibility[⁠](https://linear.app/changelog/2023-10-12-triage-responsibility.html#triage-responsibility)

You can now enable triage responsibility to define how incoming issues and requests are handled in [Triage](https://linear.app/docs/triage.html). When an issue is added to Triage, you can either notify or assign the issue to specific workspace members. We recommend notifications for most product teams, but assignment works well for teams that typically handle small requests that anyone can pick up. If your team uses PagerDuty, you can connect a PagerDuty schedule to automatically rotate who is responsible for triage.

Triage responsibility is indicated in issue history, so anyone can easily see who was responsible for handling an issue. We recommend this feature for any team using Triage.

To start using triage responsibility, go to your team’s Triage inbox and click the unassigned icon in the header or to the team’s triage settings page.

## Sidebar filters & Insights everywhere[⁠](https://linear.app/changelog/2023-10-12-triage-responsibility.html#sidebar-filters-and-insights-everywhere)

We’ve added overview sidebars across all views in the app, including My Issues, team issue views, and project views. Previously only available on custom views and roadmaps, sidebars show you essential details about the set of issues or projects in your view and let you apply quick filters. Open the sidebar from any view with `Cmd/Ctrl` `I`.

[Linear Insights](https://linear.app/features/insights.html) is now also available across all issue and project views for Plus plan members.

## View subscriptions[⁠](https://linear.app/changelog/2023-10-12-triage-responsibility.html#view-subscriptions)

Subscribe to get notified of key changes in the views you care about most. Opt-in to receive a notification when issues are added to the view or when issues are completed or canceled. This makes it easy to track your most important custom views such as high-priority bugs or issues ready for review. You can also enable notifications in the current cycle, backlog, label views, and user profiles. Subscribe to notifications directly from the view and manage subscriptions in [notification settings](https://linear.app/settings/account/notifications.html).

### Also new:[⁠](https://linear.app/changelog/2023-10-12-triage-responsibility.html#also-new:)

💼 Set a default project template for a team
👆 Swipe gestures to close sidebars on touch devices
🗂️ Filter projects and issues by template

Fixes

* The Sentry integration will no longer create new issues in Linear if the same issue already exists, including if the existing issue is closed.
* [API] Added an ability to filter issues and projects by applied template
* Fixed a bug where “Show empty group” display preference on projects board would not work correctly
* Fixed a bug where issues would jump in and out of the list if moved from triage to another team.
* Fixed a problem with the project creation modal not suggesting the correct team based on context.
* Improved keyboard navigation and mobile layout of the SLA settings page
* Fixed desktop notification username not being rendered correctly
* Fixed keyboard focus not visible in team sidebars on some items.
* Fixed the sizes of the emoji picker and icon palette on mobile device screen sizes
* Fixed breaking apart blockquotes in the middle
* Fixed a bug where pull/merge requests added manually to issues as references would replace the issue’s generated git branch.
* Fixed an issue where the cycles archive would be sorted incorrectly
* We improved keyboard shortcut support for creating and managing projects.
* Fixed an issue where it would be hard to scroll issue lists on some Android devices
* Fixed a problem with email unsubscribe links in digest emails
* Triage actions are no longer visible after an issue is moved from triage to a different state.
* Fixed a bug that would cause an exception when using time actions while in CEST timezone.
* Ensure consistent hover style for issue history timestamps and comment information
* Fixed filtering when editing custom project views
* Added functionality to restore project update draft when there is an error submitting
* Fixed a problem with create view header not being draggable on Desktop
* Added an action to the Cmd+K menu for creating an issue that’s related to the current one.
* Fixed a bug where adding a second PR while the issue’s status was in-review would not link the PR.
* Fixed issue where new views wouldn’t inherit the proper team
* Improved template selection when using “Create issue from template…” and “Create project from template…” commands
* It’s now possible to copy a URL to a project template from the templates list.
* Fixed applying template to an existing issue from the options menu in issue page header
* Removed double scroll bar in SLAs and Webhooks settings pages
* Fixed comment formatting toolbar being hidden too aggressively
* Fixed alignment of the close button on toasts
* Fixed a focus issue with quick filters, which would not allow quick pick at issues
* Improved consistency of cancel button style in custom view edit header
* Saving and updating custom views is now faster with optimistic behavior.
* Save custom views optimistically to improve app speed
* Fixed a bug where issue history entries would not be created on issues recently created by integrations
* Clarified copy when selecting teams to create projects in
* Added missing hover style for checkbox
* Improved the selected background shade color in the Classic Dark theme
* Fixed a bug that showed an extra attachment when adding a link to an issue in some cases.
* The project field is now always displayed in the issue sidebar and creation dialog.
* Repeat column labels in notification settings to avoid losing context while scrolling down
* Issue descriptions are now trimmed when you create issues.
* Added a little easter egg when changing theme holding meta key
* Fixed a bug where the selected item wouldn’t clear when clicking the sidebar link on Inbox & triage pages
* Fixed email links to inbox notifications not correctly opening the notification
* We now only send Linear notifications for activity in synced Slack<>Linear comment threads if you participate on the thread from Linear. If you engage with the thread exclusively in Slack, you will not be notified by Linear about activity in the synced thread.
* Improved avatar groups with nicer styling and animations
* Fixed problems using templates with sub-issues with “Create more” option
* Fixed sorting of sub-issues created through a default template
* We will no longer send a reminder to post a project update if anyone posted one recently. Previously we only considered whether the project lead had posted one.
* Removed the “Changes saved” indicator on issue pages, since it’s redundant with all editing being fully collaborative and realtime
* Cleaned up focus states and search box alignment in the project roadmap creation modal
* Removed “None” option in “Closed projects” dropdown in display options when on the Closed tab in a project list view
* Improved empty states for All projects and Team projects views
