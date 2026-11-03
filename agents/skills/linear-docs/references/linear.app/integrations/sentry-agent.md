---
title: "Sentry Agent Integration – Linear"
source_url: "https://linear.app/integrations/sentry-agent"
fetched_at: "2026-10-27T08:17:41.028425+00:00"
---



1. [Integrations](https://linear.app/integrations.html)
2. Sentry Agent

# Resolve Linear Issues with Seer by Sentry

![Sentry agent connects to the issue and responds in real time](https://webassets.linear.app/images/ornj730p/production/c91be42b367e7f68405d182a29d2e13e34b716e6-3000x1920.png?q=95&auto=format&dpr=2)

![Sentry agent connects to the issue and responds in real time](https://webassets.linear.app/images/ornj730p/production/c91be42b367e7f68405d182a29d2e13e34b716e6-3000x1920.png?q=95&auto=format&dpr=2)

![Sentry runs analysis and explains the root cause directly in the thread](https://webassets.linear.app/images/ornj730p/production/0b9f12a844d8dc936d2ca297c941b0184be8a7d5-3000x1920.png?q=95&auto=format&dpr=2)

## Overview[⁠](https://linear.app/integrations/sentry-agent.html#overview)

The Sentry Agent helps teams resolve issues faster by bringing Seer’s root cause analyses directly into Linear. When you mention the agent in a Linear issue, it runs diagnostics in Sentry and posts back insights so you can quickly understand and act on problems without switching tools.

## How it works[⁠](https://linear.app/integrations/sentry-agent.html#how-it-works)

The Sentry Agent integration connects Sentry’s debugging insights with Linear’s issue tracking so teams can investigate and resolve problems without leaving their workflow. Once configured through secure OAuth, the agent listens for activity from both Sentry and Linear via webhooks, handling events like issue detail requests or Seer issue fix operations.

When triggered, it can initiate Seer runs in Sentry, generating root cause analyses that are posted back into Linear issues alongside other context so developers can quickly understand what went wrong and how to fix it.

## Configure[⁠](https://linear.app/integrations/sentry-agent.html#configure)

### Install the Agent[⁠](https://linear.app/integrations/sentry-agent.html#install-the-agent)

Start by installing the Sentry Agent in your Linear workspace. You’ll be prompted to connect both Linear and Sentry through their respective OAuth flows. These flows are mapped to your end user ensuring that users access is limited to only the environments they have permissions to.

### Authorize Access[⁠](https://linear.app/integrations/sentry-agent.html#authorize-access)

During setup, you’ll grant the agent access to your Linear workspace and your Sentry account. This ensures it can fetch issue data, run Seer analyses, and post results back into Linear issues. You’ll see explicit prompts to approve these permissions during the OAuth process.

### Verify Webhooks[⁠](https://linear.app/integrations/sentry-agent.html#verify-webhooks)

The integration relies on webhook activity from both Linear and Sentry (for things like agent mentions, issue updates, and installation events). These are automatically configured during setup, with all incoming requests verified using HMAC signatures to prevent spoofing.

### Requirements[⁠](https://linear.app/integrations/sentry-agent.html#requirements)

You’ll need to be an admin in your Linear workspace to install the app, and a Sentry org member with permissions to approve OAuth apps for your org.

Each user interacting with the agent in Linear will need to authenticate their own Sentry account so the integration can perform Seer runs or retrieve issue details tied to that user.

Website
[sentry.io](https://sentry.io/integrations/sentry-linear-agent/)

Category
[Agents](https://linear.app/integrations/agents.html)

Resources

[Documentation](https://docs.sentry.io/organization/integrations/issue-tracking/sentry-linear-agent/)

[Open website](https://sentry.io/sentry-apps/linear-sentry-agent/external-install/)

#### You might be interested in

[Browse all integrations](https://linear.app/integrations.html)

* [![Cursor icon](https://webassets.linear.app/images/ornj730p/production/66a992ec6b5036e3d3c71793e2f4305e039ce187-2048x2048.png?w=256&q=95&auto=format&dpr=2)

  Cursor

  By Cursor

  Turn issues into pull requests with Cursor cloud agents](cursor.html)
* [![Devin icon](https://webassets.linear.app/images/ornj730p/production/30ce4517f876ac3e290a80f4cfb0b7b3b8c998b7-320x320.svg?w=256&q=95&auto=format&dpr=2)

  Devin

  By Cognition

  Automate work from issue to tested PR with Devin](devin.html)
* [![GitHub Copilot icon](https://webassets.linear.app/images/ornj730p/production/c275964a06f4f86e5d5333a7cd0755746f8601d7-320x320.svg?w=256&q=95&auto=format&dpr=2)

  GitHub Copilot

  By GitHub

  Turn Linear issues into code with GitHub Copilot coding agent](github-copilot.html)

## Build your own agents

Create your own integration with Linear’s API and submit it to the directory.

[Start building](https://linear.app/developers/agents.html)

## Build your own agents

Create your own integration with Linear’s API and submit it to the directory.
