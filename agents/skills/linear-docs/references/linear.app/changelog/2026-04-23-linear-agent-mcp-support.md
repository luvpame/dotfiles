---
title: "Linear Agent MCP support – Changelog"
source_url: "https://linear.app/changelog/2026-04-23-linear-agent-mcp-support"
fetched_at: "2026-10-27T08:17:41.028425+00:00"
---



[Changelog](https://linear.app/changelog.html)

[April 23, 2026](https://linear.app/changelog/2026-04-23-linear-agent-mcp-support.html) Share

[## Linear Agent MCP support](https://linear.app/changelog/2026-04-23-linear-agent-mcp-support.html)

![An illustration showing the Linear Agent logo and a variety of MCP server integrations](https://webassets.linear.app/images/ornj730p/production/5f56d5576fa837140978cbe49762d0ac962fcbbd-1800x1040.png?q=95&auto=format&dpr=2)

[Linear Agent](https://linear.app/changelog/2026-03-24-introducing-linear-agent.html) can now connect to your tools via MCP, giving it access to data and actions beyond your Linear workspace. Bring external context into your workflows to investigate issues, plan projects, write specs, and draft updates grounded in your full context.

For example:

* Pull meeting takeaways from **Granola** into a project update and create follow-up issues
* Use enterprise context from **Glean** to draft a more complete project spec
* Turn interview notes from **Notion** into customer requests
* Use **PostHog** data to validate a product hypothesis

![A screenshot of a Linear Agent prompt that says "Granola, create issues from my last meeting"](https://webassets.linear.app/images/ornj730p/production/02c4982db4c548da64c74821241e1c9e57501441-3600x1920.png?q=95&auto=format&dpr=2)

Admins can control access with allowlists and workspace-level MCP permissions. Connect servers in your agent personalization settings or within triage [automations](https://linear.app/docs/triage.html#automation). See the [docs](https://linear.app/docs/linear-agent.html#connect-mcp-servers) for supported servers and setup instructions.

## Improvements to Linear Agent[⁠](https://linear.app/changelog/2026-04-23-linear-agent-mcp-support.html#improvements-to-linear-agent)

We’re continuously improving Linear Agent and adding new capabilities and features.

* Select text anywhere in Linear and press `⌘``J` to send it directly to the agent as context
* Agent chat now opens in a maximized overlay, so it feels like a natural extension of the toolbar chat instead of a separate page

## More control over sharing issues[⁠](https://linear.app/changelog/2026-04-23-linear-agent-mcp-support.html#more-control-over-sharing-issues)

We recently introduced [issue-level sharing](https://linear.app/changelog/2026-02-13-advanced-filters-and-share-issues-in-private-teams.html#share-issues-from-private-teams), which lets teams share individual issues from private teams with guests and members who don’t have team-level access.

This update gives team owners more control over how that access is managed. Team owners can now configure who can share issues with non-members in team settings. Sub-issues also no longer inherit the parent issue’s share state and can be shared independently.

Issue-level sharing is available on Enterprise plans. Learn more in our [docs](https://linear.app/docs/private-teams.html#share-issues-from-a-private-team).

Fixes

* Agents

  Fixed a case where maximizing the agent panel could leave the main view shrunken
* API

  Enabled webhooks now show the correct status dot in API settings
* API

  Agent delegation webhooks are now retried after an initial failed delivery
* Billing

  Fixed an issue where a deleted Stripe coupon on a subscription could block plan changes
* Editor

  Issue titles now auto-generate correctly from template boilerplate when opening the composer with a template
* Email

  Invitation and authentication emails are no longer delayed when bulk sending is throttled
* Intercom

  Intercom conversations are no longer reopened when the linked Linear issue is marked as a duplicate
* Issue Templates

  Applying a template in the issue composer no longer clears pre-filled fields like project when the template doesn’t specify them
* Issue Templates

  Fixed an error when editing templates containing issues with legacy invalid descriptions
* Issues

  Printing or exporting an issue to PDF now includes all pages
* Slack

  Bot messages in Slack threads now sync correctly to Linear instead of appearing as empty comments
* Slack

  Issue links posted to Slack now show the correct title for teams with keys that start with a digit
* Slack

  User group mentions in Slack asks now resolve to the group name instead of showing the ID in Linear
* Slack

  Slack unfurls now work for org-less issue URLs such as `linear.app/issue/LIN-123`
* Triage

  Issues accepted from a parent team’s triage no longer auto-move to a sub-team based on the assignee’s membership
* Triage

  Fixed a bug where SLAs could be skipped for issues routed across teams by triage rules
* Triage Rules

  Fixed triage rules with a project action not saving
* Views

  Creating a new issue from a sub-team custom view now defaults to the correct team
* Views

  Fixed a crash when opening very large views or dashboards
* Workflows

  Fixed release automation updates failing with a spurious “Team ID is required” error
