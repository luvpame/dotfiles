---
title: "Linear Asks – Linear Docs"
source_url: "https://linear.app/docs/linear-asks"
fetched_at: "2026-10-27T08:17:41.028425+00:00"
---



* Getting started
* Intake

  + [![Triage](https://webassets.linear.app/images/ornj730p/production/712fe7305132a7021337266b62cd829a642d87f0-16x16.svg?q=95&auto=format&dpr=2)Triage](triage.html)
  + [![Linear Asks](https://webassets.linear.app/images/ornj730p/production/f804eb9398d8f30985150f15604b8c225e477217-16x16.svg?q=95&auto=format&dpr=2)Linear Asks](linear-asks.html)
  + [![Asks with Slack](https://webassets.linear.app/images/ornj730p/production/3b3e7392cce7262c88707235ad4d3d868411d05b-16x16.svg?q=95&auto=format&dpr=2)Asks with Slack](linear-asks-slack.html)
  + [![Asks with Email](https://webassets.linear.app/images/ornj730p/production/c1b6cdc0449d107875a65baa2db023c8fcee7ae2-16x16.svg?q=95&auto=format&dpr=2)Asks with Email](linear-asks-email.html)
  + [![Asks Web Forms](https://webassets.linear.app/images/ornj730p/production/1f86e4f40e7338953c7f22fc78385aa48cd2fbfa-16x16.svg?q=95&auto=format&dpr=2)Asks Web Forms](linear-asks-web-forms.html)
  + [![Customer Requests](https://webassets.linear.app/images/ornj730p/production/daf62f3b5f67e7fd71f9ca25ee45dc565d4232cb-17x16.svg?q=95&auto=format&dpr=2)Customer Requests](customer-requests.html)
* Projects and initiatives
* Issues and cycles
* Coding and review
* Agents and automation
* Insights and outcomes
* Working in Linear
* Integrations
* Administration
* Importers

# Linear Asks

Asks turns requests like bug reports, questions, and IT needs into actionable issues in Linear.

Available to workspaces on our [Business](https://linear.app/pricing.html) and [Enterprise](https://linear.app/pricing.html) plans. Additional features available to Enterprise workspaces through Advanced Linear Asks.

![Linear logo and Asks logo](https://webassets.linear.app/images/ornj730p/production/cafe02ae27a254a6eda1dc00b00d91d063cd7656-2880x1620.png?w=1440&q=95&auto=format&dpr=2)

## Overview[⁠](https://linear.app/docs/linear-asks.html#overview)

Linear Asks helps organizations manage internal requests that would otherwise be scattered across chat, email, and ad-hoc forms.

Once enabled, asks can be submitted through Slack, email, or web forms. Each ask becomes an issue in Linear, where teams can triage, prioritize, assign, and respond using their existing workflows.

## Purpose and use cases[⁠](https://linear.app/docs/linear-asks.html#purpose-and-use-cases)

Linear Asks is designed for internal requests. It’s especially useful for:

* Engineering teams receiving bug reports from non-technical teammates
* IT and support teams handling hardware, access, and setup requests
* Operations and HR teams managing internal requests from across the company
* Product and design teams collecting feedback and feature requests

By supporting request intake through familiar surfaces, Asks makes it easy for people to ask for help without changing how they already work.

## Multi-channel request intake[⁠](https://linear.app/docs/linear-asks.html#multi-channel-request-intake)

Linear Asks supports three intake surfaces: Slack, email, and web forms.

Use Slack when requests already happen in channels or direct messages. Use email when your team already works from an inbox. Use web forms when you want a more structured submission flow.

Jump to:

* [Slack docs](https://linear.app/docs/linear-asks-slack.html)
* [Email docs](https://linear.app/docs/linear-asks-email.html)
* [Web Forms docs](https://linear.app/docs/linear-asks-web-forms.html)

### Slack Asks[⁠](https://linear.app/docs/linear-asks.html#slack-asks)

People can submit Asks directly from Slack, turning messages into issues without leaving the conversation.

People can also start an Ask with the `/ask` slash command.

When an Ask is created for a Linear team, it starts in the team’s Triage for review, prioritization, and assignment.

Asks created from Slack keep a synced comment thread between Linear and Slack, so replies in either place stay connected.

Learn more in our [Slack Asks docs](https://linear.app/docs/linear-asks-slack.html).

### Email Asks[⁠](https://linear.app/docs/linear-asks.html#email-asks)

Each incoming email creates a new issue in Linear using the email subject as the title and the message body as the description.

Teams can use a Linear-provided intake address or set up a custom email address that forwards into Linear.

A synced thread appears in the issue, so teams can reply from Linear and continue the conversation over email.

Learn more in our [Email Asks docs](https://linear.app/docs/linear-asks-email.html).

### Web Asks[⁠](https://linear.app/docs/linear-asks.html#web-asks)

People in your identity provider can submit Asks through web forms after signing in to your Asks site.

Each submission creates an issue in Linear and sends the requester an email confirmation.

Replies continue through a synced thread, so the requester and the team can stay in touch after submission.

Learn more in our [Web Forms Asks docs](https://linear.app/docs/linear-asks-web-forms.html).

## Linear Asks vs Advanced Linear Asks[⁠](https://linear.app/docs/linear-asks.html#linear-asks-vs-advanced-linear-asks)

Asks is available on both Business and Enterprise plans, with additional features for Enterprise workspaces through Advanced Linear Asks.

| Feature | Business (Linear Asks) | Enterprise (Advanced Linear Asks) |
| --- | --- | --- |
| Email intake & replies | ✔ | ✔ |
| Custom email domains | ✔ | ✔ |
| Private Asks (DMs & Linear Asks bot) | ✔ | ✔ |
| Asks fields | ✔ | ✔ |
| Form templates support | ✔ | ✔ |
| Additional [Slack](https://linear.app/docs/linear-asks-slack.html#linear-asks-vs-advanced-linear-asks) functionality | — | ✔ |
| Web forms | — | ✔ |

## Shared concepts[⁠](https://linear.app/docs/linear-asks.html#shared-concepts)

A few concepts apply across all Asks surfaces:

#### Shared workflow[⁠](https://linear.app/docs/linear-asks.html#shared-workflow)

No matter where an Ask starts, it becomes an issue in Linear. Teams can triage, prioritize, assign, and respond using the same workflows they already use for other work.

#### Synced conversations[⁠](https://linear.app/docs/linear-asks.html#synced-conversations)

Slack, email, and web forms can keep the requester conversation connected to the issue, so updates and replies stay in sync across surfaces.

#### Templates[⁠](https://linear.app/docs/linear-asks.html#templates)

Templates can help standardize intake and apply default issue properties when new Asks are created. Learn more about [templates](https://linear.app/docs/issue-templates.html).

## Next steps[⁠](https://linear.app/docs/linear-asks.html#next-steps)

To set up or customize a specific intake surface, continue to our [Slack](https://linear.app/docs/linear-asks-slack.html), [Email](https://linear.app/docs/linear-asks-email.html) or [Web Forms](https://linear.app/docs/linear-asks-web-forms.html) documentation.

[Previous

Triage](https://linear.app/docs/triage.html)[Next

Asks with Slack](https://linear.app/docs/linear-asks-slack.html)

* [Overview](https://linear.app/docs/linear-asks.html#overview)
* [Purpose and use cases](https://linear.app/docs/linear-asks.html#purpose-and-use-cases)
* [Multi-channel request intake](https://linear.app/docs/linear-asks.html#multi-channel-request-intake)
* [Slack Asks](https://linear.app/docs/linear-asks.html#slack-asks)
* [Email Asks](https://linear.app/docs/linear-asks.html#email-asks)
* [Web Asks](https://linear.app/docs/linear-asks.html#web-asks)
* [Linear Asks vs Advanced Linear Asks](https://linear.app/docs/linear-asks.html#linear-asks-vs-advanced-linear-asks)
* [Shared concepts](https://linear.app/docs/linear-asks.html#shared-concepts)
* [Shared workflow](https://linear.app/docs/linear-asks.html#shared-workflow)
* [Synced conversations](https://linear.app/docs/linear-asks.html#synced-conversations)
* [Templates](https://linear.app/docs/linear-asks.html#templates)
* [Next steps](https://linear.app/docs/linear-asks.html#next-steps)
