---
title: "Coding sessions: environments, browser use, and updated pricing – Changelog"
source_url: "https://linear.app/changelog/2026-08-20-coding-environments"
fetched_at: "2026-10-27T08:17:41.028425+00:00"
---



[Changelog](https://linear.app/changelog.html)

[August 20, 2026](https://linear.app/changelog/2026-08-20-coding-environments.html) Share

[## Coding sessions: environments, browser use, and updated pricing](https://linear.app/changelog/2026-08-20-coding-environments.html)

[![](https://webassets.linear.app/images/ornj730p/production/f7ae17745a2aae2e14f3cc80a4aaa72fe3633c44-1200x800.png?q=95&auto=format&dpr=2)](https://webassets.linear.app/files/ornj730p/production/3922f252288414570e31823dbfc947723a2e59a2.mp4)

Elapsed00:00Remaining time unknown−--:--

0.25×0.5×0.75×1×1.25×1.5×1.75×2×

Linear Agent can now set up, run, and test your code before returning its work. That means fewer handoffs and changes that are further along when they come back to you.

We’re also introducing lower, more transparent pricing, making AI credit usage easier to understand and control.

## **Configurable environments**[⁠](https://linear.app/changelog/2026-08-20-coding-environments.html#configurable-environments)

Coding sessions now automatically adapt to each codebase’s configuration, with broader out-of-the-box support for Python, Ruby, Go, and more.

During a session, Linear detects and installs the toolchains and dependencies it needs to complete the task. Teams can go further by pinning runtime versions, adding setup scripts, and defining environment variables.

To get started, create an environment in [settings](https://linear.app/settings/ai/coding-sessions.html). Visit the [docs](https://linear.app/docs/coding-sessions.html) for more details.

## Browser testing[⁠](https://linear.app/changelog/2026-08-20-coding-environments.html#browser-testing)

Once the application is running, Linear Agent tests its work where users experience it: in the browser.

The agent opens the app, navigates through a flow, and verifies its implementation. It also captures before-and-after screenshots, making visual changes easier to review alongside the code.

Browser testing can catch broken interactions and visual regressions that code review alone might miss. If the agent finds a problem, it can make a fix, rerun the test, and return the work with that validation complete.

![Screenshot of Linear UI](https://webassets.linear.app/images/ornj730p/production/4949ed5cd70ac79c7cb914eb65373f5e494af720-3600x2160.png?q=95&auto=format&dpr=2)

## Transparent pricing[⁠](https://linear.app/changelog/2026-08-20-coding-environments.html#transparent-pricing)

As coding sessions take on more work, costs need to be easy to understand and easy to control.

Starting today, coding sessions use a lower-cost pricing model with two components:

* **Model usage:** Tokens are charged at the provider’s published rates, with no markup
* **Sandbox runtime:** Charged at $0.25 per 20-minute block

Together, model usage and runtime determine the AI credit cost of a session. The usage dashboard shows the breakdown, along with token usage and cost by model.

Admins can also set workspace-wide and per-user spend limits that reset daily, weekly, or monthly. When a limit is reached, additional AI credit usage is paused until the limit resets or an admin increases it.

Learn more about AI credits in the [docs](https://linear.app/docs/ai-credits.html).

Fixes

* Agents

  Fixed an issue where Linear couldn’t find or assign a future cycle when referenced by its number (e.g. “Cycle 13”) in Slack and comments
* Android

  Fixed read AI conversations appearing bold in the conversation picker
* Desktop

  Fixed search and create issue buttons in the sidebar not responding to clicks at narrow window sizes
* Diffs

  Fixed merge queue duration tooltips appearing stuck
* Diffs

  Fixed guide sections with a lot of files in them not being scrollable
* Diffs

  Fixed Linear guest users with a connected GitHub account being able to edit Diff title and description if they have write access to that PR on GitHub
* Diffs

  Removed hover underlines from GitHub code embed header links, kept their link cursors when focused, and added external-link indicators to file names
* Diffs

  Fixed repeated review cache errors when IndexedDB is unavailable

Improvements

* Asks

  Added a per-channel Asks setting that posts a message mentioning the new assignee in the synced Slack thread when an Ask is assigned
* Authentication

  Improved pending SAML domain verification from 24 hours to seven days
* Diffs

  Improved meaningful change count on PR tooltips as well
* IOS

  Improved error messages for unsupported media formats
* Issues

  Added the full issue copy menu to the issue header URL button
* Team Home

  Initiative documents pinned to a team’s overview now also appear in the team’s documents tab
* Views

  Added ability to subscribe to events in project views and receive notifications in Inbox or Slack

Keyboard shortcuts

* Issues

  Open a GitHub-synced issue in GitHub with `O``G`
* Issues

  Fixed `Cmd/Ctrl``Up/Down` scrolling to the top or bottom of an issue after editing its title or description
