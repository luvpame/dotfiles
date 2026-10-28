---
title: "Origin integration"
source_url: "https://linear.app/docs/origin"
fetched_at: "2026-10-27T08:17:41.028425+00:00"
---



* Getting started
* Intake
* Projects and initiatives
* Issues and cycles
* Coding and review
* Agents and automation
* Insights and outcomes
* Working in Linear
* Integrations

  + [![Integration Directory](https://webassets.linear.app/images/ornj730p/production/9b68e0a012db8709a0b436cf9f3e9667e318ae9d-16x16.svg?q=95&auto=format&dpr=2)Integration Directory](integration-directory.html)
  + [![Airbyte](https://webassets.linear.app/images/ornj730p/production/37fa8000e5f87ed22f21256bbbe026370ae93c16-16x16.svg?q=95&auto=format&dpr=2)Airbyte](airbyte.html)
  + [![Discord](https://webassets.linear.app/images/ornj730p/production/c6475146f9bc5a1499c0211e734e36025dc7f974-16x16.svg?q=95&auto=format&dpr=2)Discord](discord.html)
  + [![Figma](https://webassets.linear.app/images/ornj730p/production/39805ebc1087ba353c212f48ca3b2e7810670c7f-16x16.svg?q=95&auto=format&dpr=2)Figma](figma.html)
  + [![Front](https://webassets.linear.app/images/ornj730p/production/3e98d5afaf83119d0934475d6e4168abce295eb4-16x16.svg?q=95&auto=format&dpr=2)Front](front.html)
  + [![GitHub](https://webassets.linear.app/images/ornj730p/production/281c20337377c02a254eed2aaa191c0dfcf0cb8f-16x16.svg?q=95&auto=format&dpr=2)GitHub](github-integration.html)
  + [![GitLab](https://webassets.linear.app/images/ornj730p/production/52b23c9d3b77865a403059dbaea9b187f5edb24a-16x16.svg?q=95&auto=format&dpr=2)GitLab](gitlab.html)
  + [![Google Sheets](https://webassets.linear.app/images/ornj730p/production/9b42494e63e94c3a36ea50357abb89eac48de4b6-16x16.svg?q=95&auto=format&dpr=2)Google Sheets](google-sheets.html)
  + [![Gong](https://webassets.linear.app/images/ornj730p/production/8d8ad9d8e3ff9cb949c365ff2a56e91670b06d7d-16x16.svg?q=95&auto=format&dpr=2)Gong](gong.html)
  + [![Intercom](https://webassets.linear.app/images/ornj730p/production/6043dcf4ee20fb820fa71f17f9d9c99fb38a6244-16x16.svg?q=95&auto=format&dpr=2)Intercom](intercom.html)
  + [![Jira](https://webassets.linear.app/images/ornj730p/production/b4ed29b2721bb179949f9f22d0a90b775eda1d73-16x16.svg?q=95&auto=format&dpr=2)Jira](jira.html)
  + [![Microsoft Teams](https://webassets.linear.app/images/ornj730p/production/9ad8a23671491d788b8da7afceec1ae7278f9d68-16x16.png?q=95&auto=format&dpr=2)Microsoft Teams](microsoft-teams.html)
  + [![Notion](https://webassets.linear.app/images/ornj730p/production/3f74f298541c9330cef4ff4e9e4d881f04a6cac6-16x16.svg?q=95&auto=format&dpr=2)Notion](notion.html)
  + [![Origin](https://webassets.linear.app/images/ornj730p/production/3a9fb15c81c930989690570ed256bebbf4f1ea99-16x16.svg?q=95&auto=format&dpr=2)Origin](origin.html)
  + [![Salesforce](https://webassets.linear.app/images/ornj730p/production/25efb8b0008d88966f8892be5965b1eb1ea5b646-16x16.svg?q=95&auto=format&dpr=2)Salesforce](salesforce.html)
  + [![Sentry](https://webassets.linear.app/images/ornj730p/production/61f628718b18e99cc4b65c9e9197727813646fff-16x16.svg?q=95&auto=format&dpr=2)Sentry](sentry.html)
  + [![Slack](https://webassets.linear.app/images/ornj730p/production/b72b74457ec6124a93ae825b3e10e40ce4dfd314-16x16.svg?q=95&auto=format&dpr=2)Slack](slack.html)
  + [![Zapier](https://webassets.linear.app/images/ornj730p/production/641f65d05b4ad72de980b71a52d92f20c672f7e9-16x16.svg?q=95&auto=format&dpr=2)Zapier](zapier.html)
  + [![Zendesk](https://webassets.linear.app/images/ornj730p/production/bdb234238f4691a632ddf95d34953d3691d1ec23-16x16.svg?q=95&auto=format&dpr=2)Zendesk](zendesk.html)
* Administration
* Importers

# Origin

![Linear X Cursor](https://webassets.linear.app/images/ornj730p/production/f7fb416a3e0e1717784738fc13f6be0ce0ffbe01-1200x675.png?w=1440&q=95&auto=format&dpr=2)

## Overview[⁠](https://linear.app/docs/origin.html#overview)

Linear’s Origin integration keeps your issues and pull requests in sync. Link an Origin pull request to a Linear issue, and Linear updates the issue’s status as the PR moves from draft to review to merged, so nobody has to change statuses by hand.

Every linked PR appears on its issue in Linear, with a link back to the issue from the PR in Origin. Anyone looking at either side can see where the work stands.

## Configure[⁠](https://linear.app/docs/origin.html#configure)

A Linear workspace owner or admin can enable the Origin integration in [Settings](https://linear.app/settings/integrations/origin.html).

Once it’s enabled, members can link pull requests to issues and teams can set up workflow automations.

#### Linking pull requests[⁠](https://linear.app/docs/origin.html#linking-pull-requests)

Link a PR to a Linear issue by including the issue ID in the branch name or PR title. To link more than one PR, or to link an issue after the PR already exists, use a magic word like “fixes” followed by the issue ID in the PR description: `Fixes LIN-123`.

Linking creates a reference to the PR on the Linear issue and a link back to Linear from the PR.

#### Status automations[⁠](https://linear.app/docs/origin.html#status-automations)

Workflow automations are set per team and move issues through your workflow as their PRs progress. For example, an issue can move to *In Progress* when a PR is opened and to *Done* when it’s merged. Configure each team-specific automation by navigating into the team-level *Settings* > *Workflows & automations*.

Members can also turn on personal automations in their [preferences](https://linear.app/docs/account-preferences.html#on-move-to-started-status-assign-to-yourself), which auto-assign the issue to them and move it to *In Progress* when they open a linked PR.

[Previous

Notion](https://linear.app/docs/notion.html)[Next

Salesforce](https://linear.app/docs/salesforce.html)

* [Overview](https://linear.app/docs/origin.html#overview)
* [Configure](https://linear.app/docs/origin.html#configure)
* [Linking pull requests](https://linear.app/docs/origin.html#linking-pull-requests)
* [Status automations](https://linear.app/docs/origin.html#status-automations)
