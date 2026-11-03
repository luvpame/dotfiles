---
title: "Asks fields and Triage routing – Changelog"
source_url: "https://linear.app/changelog/2025-06-05-asks-fields-and-triage-routing"
fetched_at: "2026-10-27T08:17:41.028425+00:00"
---



[Changelog](https://linear.app/changelog.html)

[June 5, 2025](https://linear.app/changelog/2025-06-05-asks-fields-and-triage-routing.html) Share

[## Asks fields and Triage routing](https://linear.app/changelog/2025-06-05-asks-fields-and-triage-routing.html)

![Asks template showing new Asks fields for platform, customer, and priority. The platform field is marked as required.](https://webassets.linear.app/images/ornj730p/production/8eab25d4230b563799367ad97a134a5dc1c7996d-3600x1800.png?q=95&auto=format&dpr=2)

## Asks fields[⁠](https://linear.app/changelog/2025-06-05-asks-fields-and-triage-routing.html#asks-fields)

Customize your intake forms for [Asks](https://linear.app/features/asks.html). Let users set priority, customer, or due date and allow them to upload files when submitting new Asks. Additionally, you can expose any label group as a dropdown field to help with up-front categorization.

Asks fields can be added to any existing issue template.

![Asks form in Slack showing a customized layout with a required field for Platform (which selects a label within the platform label group) and optional fields to upload files and attach a customer to the Ask](https://webassets.linear.app/images/ornj730p/production/7f18c68ea8505ad616e30f868836d6a29f905e84-3600x1800.png?q=95&auto=format&dpr=2)

## Triage routing[⁠](https://linear.app/changelog/2025-06-05-asks-fields-and-triage-routing.html#triage-routing)

Automatically route Triage issues to the right team or assignee based on predefined rules. You can create triggers from nearly any combination of parameters including the priority, creator, template, project, due date or SLA status, then choose how the issue should be processed. Use rules to:

* Assign issues to specific members or agents
* Mark specific issues as high-priority
* Move issues to their appropriate teams

Configure Triage rules from *Team settings > Triage.*

![Triage rules in the Rider App team showing one rule that marks issues from specific customers as high priority and another that moves any issues with an iOS label to the Mobile team](https://webassets.linear.app/images/ornj730p/production/6a05e901b97086b11f7b93967fd3ef74be447968-3600x1800.png?q=95&auto=format&dpr=2)

When combined, Asks fields and Triage routing eliminate manual work and help you scale intake workflows. Users fill out what they know and automations send the issue to the right team or assignee.

Asks is available on business and enterprise plans. Triage routing is available on enterprise plans. To try either of these features, start an [enterprise trial](https://linear.app/pricing.html).

## ChatGPT Deep Research integration[⁠](https://linear.app/changelog/2025-06-05-asks-fields-and-triage-routing.html#chatgpt-deep-research-integration)

Access your Linear data in ChatGPT. Ask questions, analyze trends, and get insights across your entire workspace when running deep research queries. [Available](https://help.openai.com/en/articles/11487775-connectors-in-chatgpt#h_3aaded1905) for ChatGPT Plus and Pro subscribers.

## Linear MCP server available in Cursor 1.0[⁠](https://linear.app/changelog/2025-06-05-asks-fields-and-triage-routing.html#linear-mcp-server-available-in-cursor-1.0)

Linear now supports Cursor’s one-click MCP server installs with OAuth2 based authentication. Install Linear from [Cursor’s Tools directory](https://docs.cursor.com/tools) or [open Cursor directly](cursor://anysphere.cursor-deeplink/mcp/install?name=Linear&config=eyJ1cmwiOiJodHRwczovL21jcC5saW5lYXIuYXBwL3NzZSJ9).

Fixes (16)

* Archive

  Fixed the broken layout of archived issues in some scenarios
* Asks

  Fixed an issue where users mentioned in Slack on the synced thread for a private Ask would not be notified in Linear
* Customers

  Substring matches are now properly returned when searching for customers in a Slack dialog
* Documents

  Fixed the “updated by” field on documents to be set correctly
* Editor

  Fixed a bug where it was not possible to select in front of a mention at the start of a heading
* Editor

  Fixed comments left on wide tables to correctly scroll into view.
* Editor

  Fixed a bug where changing code block languages failed after editing the document
* Editor

  Removed inline comments when duplicating documents.
* Inline Comments

  Fixed a problem where it sometimes wasn’t possible to edit inline comments
* Issue page

  Clicking the issue ID in the page title no longer removes the navigation arrows from the issue page.
* Labels

  When creating a new label, color selection changes are immediately visible in the list
* Notifications

  Users subscribed to views filtered by the added to cycle period filter are now correctly notified when a new issue is added to the view
* OAuth apps

  The OAuth app details page now always shows the “App user” if installed, regardless of the number and timing of member installations.
* Projects

  Fixed an issue where project start and target dates could not be cleared or removed from the date edit modal
* Projects

  Fixed overdue status calculation for projects with quarterly or monthly target dates
* Shortcuts

  Fixed a problem with clashing shortcuts for reminding and snoozing notifications. `H` is now used for snoozing and `H Shift` for reminding about issues/projects, etc.

Improvements (19)

* Android

  Introduced shortcuts for “Create issue” and “Search”
* Android

  Added the ability to download media content (images and videos)
* Archive

  The page header no longer overflows the screen when adding filters
* Customers

  Customers with the same name now appear first when merging customers
* Customers

  Customer statuses can now be customized
* Editor

  Miro boards can now be embedded in Linear documents, comments, and issue descriptions.
* iOS

  Added new buttons to control indentation level when editing lists
* iOS

  Added display settings to project lists. Customize the properties that display on each row, as well as whether to include closed projects.
* iOS

  You can now filter your teams by their identifier instead of just by name.
* Notifications

  Improved clarity of push notifications for text-free comments
* Notifications

  Issues that only momentarily match views won’t trigger view notifications
* OAuth apps

  The OAuth app details page now shows how many additional members installed the app, beyond the first 10 displayed users.
* Project Views

  Team quick filters are now structured to match the parent/sub-team hierarchy
* Projects

  You will now see all initiatives as individual controls in the project details sidebar
* Quick filters

  The hover animation now feels snappier as it no longer has a quick fade-out
* Templates

  Added an option to clear the applied template when creating issues
* Sub-issues

  We now preserve the child team when making a copy of an issue
* Search

  Issues and projects show more properties in search
* Mobile

  Users can now configure which notifications they receive in the mobile app from the mobile app.

API (5)

* Webhooks

  Added `syncedWith` on `Issue` and `Comment` webhooks to unify with GraphQL responses.
* Webhooks

  Comment webhooks now contain `botActor` to indicate when the comment was created with `actor=application`
* `createAsUser` and `displayIconUrl` inputs are now respected when creating comments in synced Slack threads
* The `gitHubUserId` field is now exposed on `User` when the user has linked their GitHub account to their Linear account.
* We now support using the `createAsUser` parameter with `actor=app` OAuth tokens.

Keyboard Shortcuts (2)

* Fixed the Move Up/Down keyboard shortcut not working on lists without any grouping
* You can navigate back from full-page search using `Escape`.
