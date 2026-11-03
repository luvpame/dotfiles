---
title: "Larridin Integration – Linear"
source_url: "https://linear.app/integrations/larridin"
fetched_at: "2026-10-27T08:17:41.028425+00:00"
---



1. [Integrations](https://linear.app/integrations.html)
2. Larridin

# Developer productivity intelligence — from what shipped, to code quality and AI costs

![Larridin agent providing report data within Linear](https://webassets.linear.app/images/ornj730p/production/5655f55da0a8c1d640d7f1090f8ac2bd5af669cb-1244x704.png?q=95&auto=format&dpr=2)

![Larridin agent providing report data within Linear](https://webassets.linear.app/images/ornj730p/production/5655f55da0a8c1d640d7f1090f8ac2bd5af669cb-1244x704.png?q=95&auto=format&dpr=2)

## Overview[⁠](https://linear.app/integrations/larridin.html#overview)

Larridin brings developer productivity intelligence into Linear. Mention the agent in a cycle, project, or issue and it pulls data from across your engineering stack (Linear, GitHub, GitLab, Codex, Claude Code, Cursor, Datadog, Sentry, PagerDuty) and posts back what shipped, how fast, at what quality, and what it cost.

## How it works[⁠](https://linear.app/integrations/larridin.html#how-it-works)

The agent joins data from your ticketing, source control, and coding agents to answer questions where you work.

**Issue lifecycle tracking**: Mention `@larridin` on any issue and ask whether it shipped. The agent traces the full path from issue creation through coding agent activity, PR, code review, merge, deployment, and production health. It also checks whether the deploy went clean and if Sentry or PagerDuty flagged anything after.

**Sprint and cycle scorecards**: Mention `@larridin` in a cycle or project and ask how the team performed. It computes throughput, median cycle time, scope changes, and the split between human-authored and AI-generated code across Codex, Claude Code, and Cursor. Ask why velocity changed and it looks at scope creep, review bottlenecks, blocked work, or shifts in agent delivery.

**Code quality**: Ask `@larridin` about quality for what shipped this cycle. Rework rates, code turnover, and rollback frequency per team or developer.

**Agent effectiveness and AI costs**: Ask `@larridin` how your coding agents are performing across tools. Completion rates, autonomous run time, cost-per-issue, and quality comparison between agent-generated and human-authored work. Which tools your team is actually using, how much AI-generated code is landing in production, and whether it’s holding up or creating downstream rework.

**Team and developer patterns**: Ask `@larridin` about review turnaround, delegation rates, or where work is getting stuck. The agent surfaces per-team and per-developer signals so managers spot adoption gaps and coaching opportunities without pulling reports manually.

Reply to `@larridin` in any thread to drill deeper. Mention `@larridin help` to see available queries.

## Configure[⁠](https://linear.app/integrations/larridin.html#configure)

Linear admin or owner access is required to configure Larridin.

Connecting additional data sources may also require admin permissions in those systems.

1. **Connect your Larridin workspace**
   Go to *Settings* > *AI Coder* Integrations in Larridin and click Connect Linear. You need to be a workspace admin in both Larridin and Linear.
2. **Authorize and select teams**
   Approve the OAuth consent screen. Pick which Linear teams get access to `@larridin`. It shows up as a workspace member in those teams.
3. **Connect your stack**
   During setup, connect the systems Larridin draws from:

   Source control: GitHub, GitLab
   Coding tools: Codex, Claude Code, Cursor
   Monitoring & incidents: Datadog, Sentry, PagerDuty

   Each connection uses OAuth or API key authentication scoped to read-only access. Larridin computes metrics from your data - it never modifies issues, code, or configurations.
4. **Start using @larridin**
   Mention `@larridin` in any issue, cycle, or project comment. Reply in the thread to drill deeper.

Website
[larridin.com](https://larridin.com/developer-productivity)

Category
[Agents](https://linear.app/integrations/agents.html)

[Open website](https://app.larridin.com/scout/settings?tab=ai-coder-integrations)

#### You might be interested in

[Browse all integrations](https://linear.app/integrations.html)

* [![Tembo  icon](https://webassets.linear.app/images/ornj730p/production/e8e3506bb1ec38692ae8b42a4b717c6aa5d17577-400x400.jpg?w=256&q=95&auto=format&dpr=2)

  Tembo

  By Tembo

  Delegate work to any coding agent with Tembo](tembo.html)
* [![GitHub Copilot icon](https://webassets.linear.app/images/ornj730p/production/c275964a06f4f86e5d5333a7cd0755746f8601d7-320x320.svg?w=256&q=95&auto=format&dpr=2)

  GitHub Copilot

  By GitHub

  Turn Linear issues into code with GitHub Copilot coding agent](github-copilot.html)
* [![Capture.dev icon](https://webassets.linear.app/images/ornj730p/production/9f0e64eb19b49f4cfbe7bbd3187cc63786457276-640x640.png?w=256&q=95&auto=format&dpr=2)

  Capture.dev

  By Capture.dev

  Capture feedback and bugs from your website and send them to Linear](capture-dev.html)

## Build your own agents

Create your own integration with Linear’s API and submit it to the directory.

[Start building](https://linear.app/developers/agents.html)

## Build your own agents

Create your own integration with Linear’s API and submit it to the directory.
