---
title: "Mobile app redesign – Changelog"
source_url: "https://linear.app/changelog/2025-10-16-mobile-app-redesign"
fetched_at: "2026-10-27T08:17:41.028425+00:00"
---



[Changelog](https://linear.app/changelog.html)

[October 16, 2025](https://linear.app/changelog/2025-10-16-mobile-app-redesign.html) Share

[## Mobile app redesign](https://linear.app/changelog/2025-10-16-mobile-app-redesign.html)

[![](https://webassets.linear.app/images/ornj730p/production/373bf700ac3ce3d8006253f29aa29dac46168ad6-1920x960.png?q=95&auto=format&dpr=2)](https://webassets.linear.app/files/ornj730p/production/a92afa8b13f8dbec818bae657db6eb64e800bcd6.mp4)

Elapsed00:00Remaining time unknown−--:--

0.25×0.5×0.75×1×1.25×1.5×1.75×2×

We’ve refreshed our iOS and Android apps with a new visual design system. Both now use a custom frosted glass material that adds depth and contrast to the UI.

![A photo of the new nav bar on iOS](https://webassets.linear.app/images/ornj730p/production/10c1be6e7b8918ed7b3dbca46de676dd4c29abda-3600x2026.png?q=95&auto=format&dpr=2)

Navigation has been rebuilt with a new bottom toolbar for quick access to core workflows. You’ll also now find a “Create Issue” button at the top of every screen.

Update now in the [App Store](https://apps.apple.com/app/linear-mobile/id1645587184) and [Play Store](https://play.google.com/store/apps/details?id=app.linear).

## Factory agent[⁠](https://linear.app/changelog/2025-10-16-mobile-app-redesign.html#factory-agent)

Users of Factory AI coding agents can now access them directly within Linear. Delegate an issue to Factory to spin up a remote workspace and launch a coding agent.

![A screenshot of the Factory agent inside Linear asking the user to select a remote workspace](https://webassets.linear.app/images/ornj730p/production/34af7551c2b1fc3be79c946b2b7d22579cfc4e92-3600x1468.png?q=95&auto=format&dpr=2)

Factory’s remote workspaces allow you to create custom development environments for coding agents, so you can delegate several Linear issues simultaneously to run in consistent, isolated environments. Learn more about Factory in our [Integration Directory](https://linear.app/integrations/factory.html).

## Issue SLAs now available on Business plans[⁠](https://linear.app/changelog/2025-10-16-mobile-app-redesign.html#issue-slas-now-available-on-business-plans)

Workspaces on the Business plan can now use SLAs to set clear expectations on when time-sensitive work should be completed.

SLAs apply automatically to issues based on configurable rules. When an SLA is at risk or becomes breached, issue subscribers receive immediate notifications. Learn more about SLAs in our [docs](https://linear.app/docs/sla.html).

Improvements

* Avatars

  Added a more diverse set of colors for user avatars where the user hasn’t added a picture
* Insights

  Tweaked the design of the burn-up charts
* Editor

  Improved the icon for Convert-to-Issues actions to make it more recognizable
* Issues

  Added action in the menu to copy comment content to clipboard
* Issues

  Improved dragging issues to labels from different teams to show a disabled drop indicator instead of allowing the drop and showing an error message
* Sentry

  Improved the issue creation process with the Sentry integration, allowing agents with access to the selected team to show up as assignment options
* Views

  Improved grouping of single-project views by milestone
* Webhooks

  OAuth apps can now subscribe to webhooks for when users authorize their app or revoke tokens for their app

Fixes

* Agents

  Agent sessions will no longer be deleted when an associated comment or issue is deleted
* Command Menu

  Fixed search results showing reliably when pasting into the command menu
* Comments

  Fixed Figma embeds in comments that are now cached properly
* Cycles

  Fixed collapsing groupings on Cycles now persisting when navigating between tabs or pages
* Desktop

  Fixed inline code formatting in the desktop tab
* Editor

  Fixed issue with creating and removing collapsible sections
* Insights

  Fixed issue count accuracy for segmented bar charts with multi-valued dimensions such as segmenting by labels
* Insights

  Fixed the hover line on burn-up charts, which wouldn’t show correctly in some themes
