---
title: "LineGuard Integration – Linear"
source_url: "https://linear.app/integrations/lineguard"
fetched_at: "2026-10-27T08:17:41.028425+00:00"
---



1. [Integrations](https://linear.app/integrations.html)
2. LineGuard

# Enforce required fields and process rules on every issue change

![lineguard builder in action](https://webassets.linear.app/images/ornj730p/production/eb3fba690dfc79c614720fd49e23a07c18576739-1600x1000.png?q=95&auto=format&dpr=2)

![lineguard builder in action](https://webassets.linear.app/images/ornj730p/production/eb3fba690dfc79c614720fd49e23a07c18576739-1600x1000.png?q=95&auto=format&dpr=2)

![lineguard showing rule steps](https://webassets.linear.app/images/ornj730p/production/bf2a79df36b1949a0a819d05dda83cd3994cfb24-1600x1000.png?q=95&auto=format&dpr=2)

![lineguard audit logs page](https://webassets.linear.app/images/ornj730p/production/5a0a7226cc073b69bd00b9748bd01a1038c67235-1600x1000.png?q=95&auto=format&dpr=2)

## Overview[⁠](https://linear.app/integrations/lineguard.html#overview)

LineGuard is a workflow rule engine for Linear. It enforces the process rules Linear has no way to enforce on its own — an estimate before an issue reaches Done, a priority before it leaves Triage, an assignee before work starts. When a rule is broken, LineGuard moves the issue back and comments explaining what is missing.

## How it works[⁠](https://linear.app/integrations/lineguard.html#how-it-works)

Every rule is three parts: a trigger, some conditions, and the actions that run when both match.

Triggers are the change that starts an evaluation — an issue entering a state, leaving a state, a field changing, an issue being created, or any update at all. Conditions then inspect that issue: state, priority, assignee, estimate, labels, or a Linear label group, combined with AND/OR groups that nest as deeply as the edge case needs. Actions move the issue back to a state you choose and post a comment naming the fields that are missing, mentioning whoever made the change.

The moment anyone updates an issue, Linear delivers the change to LineGuard, every webhook signature is verified, and each enabled rule for that issue’s team is evaluated in the order you set.

LineGuard corrects rather than prevents — it puts the issue back and explains why. In practice that is what makes it teachable: the person learns the rule on the issue, in the moment. Every evaluation is written to an audit log — which rule, which issue, whether the conditions matched, and what each action did, including the ones Linear rejects.

## Configure[⁠](https://linear.app/integrations/lineguard.html#configure)

A Linear workspace admin installs LineGuard through Linear’s OAuth flow, which registers a single webhook for the workspace. No API keys, and no per-user setup.

Rules are built visually in the dashboard: pick a team, choose a trigger, add conditions, and set the actions. Comment templates support tokens that render as real Linear mentions. Each rule can be scoped to one team or every team, ordered, enabled or disabled, and set to stop later rules once it matches.

Anyone in the workspace can sign in to read the dashboard and audit log. Only workspace admins can create, edit or disable rules, or manage billing.

Visit the [docs](https://lineguard.app/docs) to get started.

Website
[lineguard.app](https://lineguard.app)

Category
[Automations](https://linear.app/integrations/automations.html)

Contact

[Contact LineGuard](mailto:support@lineguard.app)

[Open website](https://lineguard.app/docs)

#### You might be interested in

[Browse all integrations](https://linear.app/integrations.html)

* [![Traqq icon](https://webassets.linear.app/images/ornj730p/production/05be168e3f263a9ec1e22f614fe551cd5a2f380f-640x640.png?w=256&q=95&auto=format&dpr=2)

  Traqq

  By Traqq

  Track time in Linear with Traqq](traqq.html)
* [![IFTTT icon](https://webassets.linear.app/images/ornj730p/production/9e414c42d5274c9eea49416f34075fcfeb6c14f5-640x640.png?w=256&q=95&auto=format&dpr=2)

  IFTTT

  By IFTTT

  Connect Linear to 1000+ apps and devices, no code required](ifttt.html)
* [![Shipam icon](https://webassets.linear.app/images/ornj730p/production/9c845e7d5066bf5f63ad92fae68e2a764294fdad-320x320.png?w=256&q=95&auto=format&dpr=2)

  Shipam

  By FroggyHubHQ

  Turn completed Linear projects and cycles into launch-page drafts](shipam.html)

## Build your own integration

Create your own integration with Linear’s API and submit it to the directory.

[Start building](https://linear.app/docs/integration-directory.html#build-your-own)

## Build your own integration

Create your own integration with Linear’s API and submit it to the directory.
