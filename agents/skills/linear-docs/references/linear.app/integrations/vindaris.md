---
title: "Vindaris Integration – Linear"
source_url: "https://linear.app/integrations/vindaris"
fetched_at: "2026-10-27T08:17:41.028425+00:00"
---



1. [Integrations](https://linear.app/integrations.html)
2. Vindaris

# Link projects and issues directly to and from Vindaris

![vindaris integration text selection mapped to goals](https://webassets.linear.app/images/ornj730p/production/cf0cca38c7dd3fa7efa5ce2ff6fab03283f1866a-3200x2000.png?q=95&auto=format&dpr=2)

![vindaris integration text selection mapped to goals](https://webassets.linear.app/images/ornj730p/production/cf0cca38c7dd3fa7efa5ce2ff6fab03283f1866a-3200x2000.png?q=95&auto=format&dpr=2)

![synced issues and goals in vindaris and linear](https://webassets.linear.app/images/ornj730p/production/f41d44c449ab7519e436a4197b53f3a5e008e8c3-3200x2000.png?q=95&auto=format&dpr=2)

![stalled issues showing as execution risk in vindaris](https://webassets.linear.app/images/ornj730p/production/9d870b6c343180fae2e540ee46d96ae4b4fd8aa8-3200x2000.png?q=95&auto=format&dpr=2)

## Overview[⁠](https://linear.app/integrations/vindaris.html#overview)

Vindaris connects your Linear issues to the company goals and KPIs they are meant to move, then derives each goal’s progress from how those issues actually transition. When the work behind an objective goes quiet, Vindaris raises the execution risk early, so a goal that is quietly falling behind shows up weeks before a quarterly review would catch it.

## How it works[⁠](https://linear.app/integrations/vindaris.html#how-it-works)

Vindaris reads your Linear issues over the GraphQL API at the scope you choose, whether that is your own assigned issues, a selected set of teams, or the whole workspace. Status, due date, title, and description stay in step in both directions, and Linear’s workflow states are mapped to Vindaris statuses by their underlying type, so a team running Triage, In Progress, or any custom state is handled without renaming anything in Linear. Each issue keeps its comment thread as context, up to two hundred comments per issue, and a note written in Vindaris posts back onto the issue as a comment.

Above the issues sits the strategy. Each Linear issue is linked to the goal or KPI it serves, and Vindaris keeps the issue as an object in its Work Graph with its history and discussion attached. Goal progress is derived from the issues that actually transitioned, so the number on a goal reflects real movement in Linear. When the issues behind an objective stop transitioning relative to what the target needs, Vindaris raises execution risk on that goal while there is still a quarter left to act on it.

Your team gets this without changing how they work. Engineers keep moving issues in Linear, and leadership sees which objectives those issues are feeding and which are being starved. Because the comment thread travels with each issue, a flagged goal arrives with the reason attached, such as a blocked dependency or a spec still being argued, which is the context that makes an early warning worth acting on.

## Configure[⁠](https://linear.app/integrations/vindaris.html#configure)

No Linear workspace admin is required. Any member of your Vindaris organization can set up the connection, and it reads only the issues the authorizing Linear user can already see.

1. In Vindaris, open Settings and then Integrations, and start the Linear connection at <https://app.vindaris.com/connect/linear>.
2. Authorize through Linear OAuth. Vindaris stores the token encrypted, scoped to the organization that authorized it.
3. Choose the sync scope: your own assigned issues, one or more teams, or the whole workspace.
4. Approve the suggested links between issues and goals. From there, progress and execution risk on each goal are read from issue movement.

Vindaris holds one Linear connection per organization. Any member can connect or take it over, and reconnecting keeps the existing configuration.

Website
[vindaris.com](https://vindaris.com)

Category
[Automations](https://linear.app/integrations/automations.html)

Contact

[Contact Vindaris](mailto:support@vindaris.com)

[Open website](https://vindaris.com/integrations/linear)

#### You might be interested in

[Browse all integrations](https://linear.app/integrations.html)

* [![Zapier icon](https://webassets.linear.app/images/ornj730p/production/94bd5466ea791027d70d782aaff47ef4d3c18799-640x640.png?w=256&q=95&auto=format&dpr=2)

  Zapier

  By Linear

  Build custom automations to create or update Linear issues](zapier.html)
* [![n8n icon](https://webassets.linear.app/images/ornj730p/production/d612fc98d729740693714c2b71b92451a471cc7d-640x640.png?w=256&q=95&auto=format&dpr=2)

  n8n

  By n8n

  Build workflows that automatically manage your issues](n8n.html)
* [![Make icon](https://webassets.linear.app/images/ornj730p/production/8578d743bc0e40009e125d16ebeea9649cb99911-320x320.svg?w=256&q=95&auto=format&dpr=2)

  Make

  By Make

  Connect Linear with over 1,900 SaaS tools to automate business workflows](make.html)

## Build your own integration

Create your own integration with Linear’s API and submit it to the directory.

[Start building](https://linear.app/docs/integration-directory.html#build-your-own)

## Build your own integration

Create your own integration with Linear’s API and submit it to the directory.
