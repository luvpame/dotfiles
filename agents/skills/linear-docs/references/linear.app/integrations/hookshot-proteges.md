---
title: "Hookshot Proteges Integration – Linear"
source_url: "https://linear.app/integrations/hookshot-proteges"
fetched_at: "2026-10-27T08:17:41.028425+00:00"
---



1. [Integrations](https://linear.app/integrations.html)
2. Hookshot Proteges

# Deploy production agents your team can trust and audit

![events on Hookshot Protege running an action](https://webassets.linear.app/images/ornj730p/production/d22bc537dcd55d9cb50ec6b87c1c67d51dd45a9c-1500x960.png?q=95&auto=format&dpr=2)

Choose on which event Hookshot Protege runs an action

![events on Hookshot Protege running an action](https://webassets.linear.app/images/ornj730p/production/d22bc537dcd55d9cb50ec6b87c1c67d51dd45a9c-1500x960.png?q=95&auto=format&dpr=2)

Choose on which event Hookshot Protege runs an action

![selectig read write permissions for hookshot](https://webassets.linear.app/images/ornj730p/production/d4bc2b2c7dbfd466f349dcd40e08dd4009696d59-1500x960.png?q=95&auto=format&dpr=2)

Select from the list of available actions: reads and writes

![Linear issues visible in hookshot inbox](https://webassets.linear.app/images/ornj730p/production/8b05aa5b0466b8a10e7bb2e356b4758c846e1611-1500x960.png?q=95&auto=format&dpr=2)

Workhub plugs into SOR, both to read your issues and to update them

## Overview[⁠](https://linear.app/integrations/hookshot-proteges.html#overview)

Hookshot Proteges connects Linear to governed AI agents so issue work can start, be inspected, and be written back without a bot acting on sight. Teams use it when Linear should trigger an agent, when an agent should read issue state before deciding, and when writes should wait for an explicit rule.

## How it works[⁠](https://linear.app/integrations/hookshot-proteges.html#how-it-works)

Connect Linear over OAuth and treat it as a trigger, a tool, or both. Trigger access lets a Protege start when something happens in Linear: a new issue, an update, a status change, or a comment, scoped to the team or project you choose. Tool access lets the same Protege read issues, projects, and comments so it can decide whether to run, then create or update issues, add comments, or change status only when your rules allow writes.

Trigger access and tool access are separate. A workspace can receive Linear events without granting write tools, or grant read tools without turning on a live trigger. Each tool call is labeled read or write, and writes can be previewed against live issues before they change anything. When a Protege does write, it acts as the Hookshot app, not as the teammate who connected it.

Every inbound Linear event is recorded in an immutable Event Feed. Every decision is logged, including the cases where the Protege chose not to run. Operators can open the run, see the input, the tools used, and the outcome, and attach a Teaching Note so the next pass is tighter. Linear sits alongside Slack, GitHub, Jira, and Asana in the same workspace, so one Protege can watch Linear and report somewhere else, or the reverse.

## Configure[⁠](https://linear.app/integrations/hookshot-proteges.html#configure)

A Linear workspace admin needs to complete the first connection, since the OAuth consent is workspace-scoped. In Hookshot, open Integrations, select Linear, and finish the OAuth flow at <https://www.tryprotege.com/hookshot>. Choose a team connection for production Proteges that should keep running if someone leaves, or a personal connection only when the agent must act as a specific user.

After the connection shows as connected, review Trigger Access and Tool Access separately and keep both scoped to the teams or projects the workflow owner can actually review. Create or edit a Protege, attach Linear as the trigger, the tool, or both, and run a test issue through Event Feed and Audit before you enable it. To disconnect later, revoke the app in Linear under Settings → Applications, or remove the connection from Hookshot Integrations. Setup notes live with the rest of the integration docs at <https://docs.tryprotege.com/integrations>.

Website
[tryprotege.com](https://tryprotege.com)

Category
[AI clients](https://linear.app/integrations/ai-clients.html)

Contact

[Contact Protege AI](mailto:founders@tryprotege.com)

[Open website](https://www.tryprotege.com)

#### You might be interested in

[Browse all integrations](https://linear.app/integrations.html)

* [![Cyrus icon](https://webassets.linear.app/images/ornj730p/production/f1e78a990f524c181611f14eac60afb3f55cfa56-320x320.svg?w=256&q=95&auto=format&dpr=2)

  Cyrus

  By Ceedar

  Your Claude Code powered Linear agent that runs anywhere](cyrus.html)
* [![ChatPRD icon](https://webassets.linear.app/images/ornj730p/production/e2802c92deeba2cec1bfc48c94836e55118be18e-320x320.svg?w=256&q=95&auto=format&dpr=2)

  ChatPRD

  By ChatPRD

  Writes requirements, manages issues, and gives feedback on your product work](chatprd.html)
* [![Reflag icon](https://webassets.linear.app/images/ornj730p/production/0e2f9ebeb03d1c5459cdbe92d25641778b00164e-320x320.svg?w=256&q=95&auto=format&dpr=2)

  Reflag

  By Reflag

  Create and manage feature flags](reflag.html)

## Build your own integration

Create your own integration with Linear’s API and submit it to the directory.

[Start building](https://linear.app/docs/integration-directory.html#build-your-own)

## Build your own integration

Create your own integration with Linear’s API and submit it to the directory.
