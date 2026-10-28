---
title: "Gong – Linear Docs"
source_url: "https://linear.app/docs/gong"
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

# Gong

Automatically create issues from Gong call recordings.

Available to workspaces on our [Enterprise](https://linear.app/pricing.html) plan

![Linear X Gong](https://webassets.linear.app/images/ornj730p/production/940ff2d3f160aeeb393baafb09b22edd78250cb3-2880x1620.png?w=1440&q=95&auto=format&dpr=2)

## Overview[⁠](https://linear.app/docs/gong.html#overview)

The Gong integration automatically creates Linear issues from customer call recordings. Each issue includes a drafted title and description, speaker-attributed excerpts pulled directly from the transcript, and a link to the exact moment in the recording where the request or problem was raised.

Once enabled, Linear reviews new customer-facing calls and identifies meaningful product feedback without requiring anyone to listen to the recording. The integration captures what customers are asking for, adds the relevant context from the conversation, and sends the issue into your team’s [Triage](https://linear.app/docs/triage.html) view for review. This keeps your workflow organized in Linear while leaving calls and transcripts in Gong.

## How it works⁠[⁠](https://linear.app/docs/gong.html#how-it-works)

Linear periodically checks for new Gong recordings and processes new calls that meet specific criteria for analysis. Only customer-facing conversations are included, so internal or private calls and shorter recordings under 10 minutes are automatically skipped.

The system filters out items that aren’t actionable, like sales-related questions, beta access requests, general inquiries, or internal commentary.

Actionable findings that pass these filters are created as issues in Linear. Each issue includes a concise summary, customer motivation for the request, transcript excerpts with speaker attribution and a link directly to the timestamp in the recording for posterity.

Issues are added to your team’s Triage view, where they can be quickly reviewed, categorized, and moved into your existing backlog.

## Configure[⁠](https://linear.app/docs/gong.html#configure)

To set up the integration, navigate into your workspace-level *Settings* > *Integrations* and search for *Gong*. After enabling the Gong integration, navigate to your Gong settings, enable the recording intake and select the team that should receive Gong-generated issues:

![Recording intake settings section on, with a destination team chosen](https://webassets.linear.app/images/ornj730p/production/bc401ef7f3a78e59da4ba456851349d01d9834c4-1444x532.heif?w=1440&q=95&auto=format&dpr=2)

Optionally, you can also provide additional guidance to help route issues to the correct teams or templates. This guidance can include examples, team mentions, or internal rules the Linear Agent should follow when interpreting feedback.
There is also the option to toggle on “Mention call participants in created issues” from the integration settings page.

## Customer requests[⁠](https://linear.app/docs/gong.html#customer-requests)

When customer requests are enabled in your workspace, Gong is capable of creating customers just-in-time as their first request is added. If a customer already exists in Linear that matches the customer on the call, that customer will be re-used for association with the new customer request.

## FAQ[⁠](https://linear.app/docs/gong.html#faq)

Do users in Gong need Linear seats?

No, once an admin configures this integration it will run on all external calls without a seat for itself or other call participants.

What if multiple requests are brought up in the call?

A single call can result in multiple issues when there are multiple distinct findings.

[Previous

Google Sheets](https://linear.app/docs/google-sheets.html)[Next

Intercom](https://linear.app/docs/intercom.html)

* [Overview](https://linear.app/docs/gong.html#overview)
* [How it works⁠](https://linear.app/docs/gong.html#how-it-works)
* [Configure](https://linear.app/docs/gong.html#configure)
* [Customer requests](https://linear.app/docs/gong.html#customer-requests)
* [FAQ](https://linear.app/docs/gong.html#faq)
