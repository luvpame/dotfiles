---
title: "Guest accounts – Changelog"
source_url: "https://linear.app/changelog/2022-07-14-guest-accounts"
fetched_at: "2026-10-27T08:17:41.028425+00:00"
---



[Changelog](https://linear.app/changelog.html)

[July 14, 2022](https://linear.app/changelog/2022-07-14-guest-accounts.html) Share

[## Guest accounts](https://linear.app/changelog/2022-07-14-guest-accounts.html)

![Stylized list of members showing roles including guest and member](https://webassets.linear.app/images/ornj730p/production/02b1e7186dd089867e757efa0a2adb9d7d4ac072-3424x1920.png?q=95&auto=format&dpr=2)

## Guest accounts[⁠](https://linear.app/changelog/2022-07-14-guest-accounts.html#guest-accounts)

Previously, the only way to limit visibility within your Linear organization was to create private teams. We’ve now added another option to limit team visibility: guest accounts.

This team role is ideal for contractors or other workspace members who should only have access to a subset of Linear teams. Guests have full access to team information for all teams which they have joined, including viewing and creating projects as well as creating, editing, and commenting on any issues. They will not be able to see or discover any other teams in the workspace or have access to those issues. Guests can be part of one or multiple teams.

Read more about inviting guests [here](https://linear.app/docs/adding-and-managing-members.html#invite-guests). Guests are paid seats and are available on any of our paid plans.

## Fixes & Improvements[⁠](https://linear.app/changelog/2022-07-14-guest-accounts.html#fixes-and-improvements)

* Customers on our Plus plan are now able to configure SAML SSO for their workspace themselves
* Project updates will now be sent to workspace and project Slack channels if both are configured
* Fixed an issue where a notification would report the wrong issue creator
* Projects are no longer moved to *Started* when issues inside of them are started or completed. You’ll have to manually set the project status to *Started*.
* Fixed a problem where you could not set the upcoming cycle as an active cycle, even when an active cycle did not exist
* Fixed the priority issue sorting in multi-team custom views
* Added additional information about a cycle in the cycle sidebar: cycle name, status and dates
* Added *Current user* as an option for the *Subscribers* issue filter
* Fixed a bug where the button to apply templates to documents didn’t show up
* Fixed a bug where the sub-issue title would be prepopulated with the issue of a previously created issue
* Fixed formatting issues in Slack when mentioning user groups
* Fixed an issue where the *Connect GitHub* button was shown to non admins
* Migration assistant for Jira will not fail anymore if any of the users have invalid email address
