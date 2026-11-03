---
title: "More ways to run and share Loops – Changelog"
source_url: "https://linear.app/changelog/2026-10-22-slack-and-github-loops"
fetched_at: "2026-10-27T08:17:41.028425+00:00"
---



[Changelog](https://linear.app/changelog.html)

[October 22, 2026](https://linear.app/changelog/2026-10-22-slack-and-github-loops.html) Share

[## More ways to run and share Loops](https://linear.app/changelog/2026-10-22-slack-and-github-loops.html)

[![](https://webassets.linear.app/images/ornj730p/production/2de4d32335588139d6e122a64b89bed3e2ff9076-1920x1080.png?q=95&auto=format&dpr=2)](https://webassets.linear.app/files/ornj730p/production/9e1278d821662e7bea1b814dc3cbb89f28671943.mp4)

Elapsed00:00Remaining time unknown−--:--

0.25×0.5×0.75×1×1.25×1.5×1.75×2×

Loops automate product work by responding to changes in Linear and connected tools. You can now trigger them from Slack and GitHub, share them as templates, and customize their reasoning levels.

### Slack and GitHub triggers[⁠](https://linear.app/changelog/2026-10-22-slack-and-github-loops.html#slack-and-github-triggers)

Events in Slack and GitHub can now start loops automatically, so work can move forward without someone having to notice an update and take action.

Set up a loop to answer product questions in a Slack channel, or draft a QA plan when a GitHub pull request gets a “ready for testing” label.

Learn how to get started with Loops in the [docs](https://linear.app/docs/loops.html).

### Custom loop templates[⁠](https://linear.app/changelog/2026-10-22-slack-and-github-loops.html#custom-loop-templates)

You can now save loops as templates for others in your workspace to use. For example, share your team’s bug-triage loop so other teams can adapt it without starting from scratch.

To create a template, open a loop’s menu and select **Save as template**. It will appear alongside Linear’s built-in templates when someone in your workspace creates a new loop.

### Reasoning levels[⁠](https://linear.app/changelog/2026-10-22-slack-and-github-loops.html#reasoning-levels)

Choose how much reasoning each loop uses to balance speed, cost, and task complexity. Keep routine work fast and cost-efficient, and reserve deeper reasoning for more demanding tasks.

**Auto** uses your workspace’s default setting, or select **Low**, **Medium**, or **High** for more control.

## Figma MCP server[⁠](https://linear.app/changelog/2026-10-22-slack-and-github-loops.html#figma-mcp-server)

Linear Agent can now read and update Figma designs. Share a frame to turn a design into implementation requirements, or ask the agent to create a design proposal from an issue.

Learn more and get connected on the [Figma integration page](https://linear.app/integrations/figma.html#configure).

## Cursor Origin sync[⁠](https://linear.app/changelog/2026-10-22-slack-and-github-loops.html#cursor-origin-sync)

You can now keep Linear issues in sync with PRs in your Cursor Origin repos. Use a phrase like “Fixes PROD-120” in the PR title or description, and status automations in Linear automatically update the issue as work progresses.

Learn more in our [docs](https://linear.app/integrations/origin.html).

Fixes

* Authentication

  Fixed SCIM role group setup failing or removing existing roles before users were provisioned
* Diffs

  Added a Resolve conflicts button that opens a draft in agent chat from the pull request header
* Drafts

  Creating an issue from a draft no longer clears the draft’s content when creation fails
* Editor

  Fixed a startup crash caused by invalid code syntax theme preferences
* GitHub

  Prevented automatic closure of merge-queued PRs when linked issues were canceled or marked Duplicate
* Insights

  Fixed the fullscreen drill on large team issue views and server-backed custom views now shows every issue the insight counted, including sub-issues and triage issues
* Integrations

  Fixed out-of-office days from Google Calendar sometimes showing a day early, a day late, or as two days instead of one
* Issues

  Fixed sub-issues created through MCP or Linear Agent missing their parent’s project when eligible to inherit it
* OAuth

  Fixed client-credentials tokens granting access to public teams outside the app user’s selected teams
* Projects

  Excluded completed and other inactive projects from initiative active-project health counts
* Teams

  Fixed preserving team settings description edits through refresh and sync updates
* Templates

  Fixed issues created from a project template landing in Triage instead of their template status when the creator was not a member of a team
* Views

  Fixed boards grouped by release or customer briefly disappearing and scrolling back to the top when a card moved between columns

Improvements

* Diffs

  Added Pending and Drafts filters in Diff to find comments you have not sent yet
* Diffs

  Added a sidebar badge when a personal GitHub account needs connecting or reconnecting
* Diffs

  Improved multi-line code selection highlights in diffs and attached code previews
* Editor

  Added scannable images for QR codes drawn as text in code blocks, with a toolbar button to switch between image and text while editing
* Filters

  Added initiative lead team filters to project views
* GitHub

  Pull request activity shows running Codex reviews from 👀 reactions
* Imports

  Improved the ability to scope Asana imports to a specific projects
* Inbox

  “Delete all completed” now also removes review requests you already handled
* Issues

  Added T3 Code as an option for opening issues
* Labels

  Label groups can now be designated as multi-select instead of single-select. Use this in scenarios where multiple labels are expected to be applied to an object at the same time.
* Linear Agent

  The agent can now rename it’s current chat
* Loops

  Added a “Create new loop” action to the `Cmd/CtrlK` command menu
* Triage

  Added BetterStack as a supported schedule for triage responsibility
* Triage

  Improved the triage responsibility schedule to now show your upcoming shift while you are on the current shift

MCP server

* You can now assign users by part of their name, and a name that matches more than one user returns the possible matches
* We’ve added customer lookup by domain and external IDs

API

* OAuth

  Fixed OAuth token refresh to return `invalid_grant` for expired, revoked, or unknown refresh tokens, so apps can prompt users to reconnect
* Projects

  Fixed project template label defaults differing between the web and API after converting a label group to single-select
