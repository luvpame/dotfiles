---
title: "Code Intelligence – Linear Docs"
source_url: "https://linear.app/docs/code-intelligence"
fetched_at: "2026-10-27T08:17:41.028425+00:00"
---



* Getting started
* Intake
* Projects and initiatives
* Issues and cycles
* Coding and review
* Agents and automation

  + [![Linear Agent](https://webassets.linear.app/images/ornj730p/production/1da47a1cbf8563070d25e5794910b622f03a428d-16x16.svg?q=95&auto=format&dpr=2)Linear Agent](linear-agent.html)
  + [![Loops](https://webassets.linear.app/images/ornj730p/production/0ba9c78fdd4e19b308e1b9bdb530743e3090e397-16x16.svg?q=95&auto=format&dpr=2)Loops](loops.html)
  + [![AI Agents](https://webassets.linear.app/images/ornj730p/production/5914e5199f95b48d50cdd2eb6cb02e0a8d6e7a24-16x16.svg?q=95&auto=format&dpr=2)AI Agents](agents-in-linear.html)
  + [![Triage Intelligence](https://webassets.linear.app/images/ornj730p/production/2308492a72303e9c95f13dad1591c985c13c0c0a-16x16.svg?q=95&auto=format&dpr=2)Triage Intelligence](product-intelligence.html)
  + [![Code Intelligence](https://webassets.linear.app/images/ornj730p/production/6c9a57ffb812e20c93862d04b62ae5ee5893358e-16x16.svg?q=95&auto=format&dpr=2)Code Intelligence](code-intelligence.html)
  + [![MCP server](https://webassets.linear.app/images/ornj730p/production/6b6af6cd841b626b6949c15c3393d726b85d51db-16x16.svg?q=95&auto=format&dpr=2)MCP server](mcp.html)
* Insights and outcomes
* Working in Linear
* Integrations
* Administration
* Importers

# Code Intelligence

Available to workspaces on the [Business](https://linear.app/pricing.html) and [Enterprise](https://linear.app/pricing.html) plans.

![Codebase analysis through Code Intelligence](https://webassets.linear.app/images/ornj730p/production/a39eab368c6ab67c6b90eab4419d2741c1712d00-2150x1826.png?w=1440&q=95&auto=format&dpr=2)

Code Intelligence lets Linear Agent answer questions about your codebase. PMs can use ask questions about current implementations to inform specs, Support and Sales can answer more technical customer questions, and engineers can more easily investigate bugs in unfamiliar product areas. Workspace admins can extend availability of this feature to all workspace users, or restrict it to users with GitHub access.

Once you’ve completed setup, try pressing `⌘`/`Ctrl` + `J` to ask Linear questions like:

> How does the authentication system work?

> Who wrote the payment processing logic?

> What PR last touched search indexing last touched?

### Setup[⁠](https://linear.app/docs/code-intelligence.html#setup)

To set up Code Intelligence, a Linear workspace owner or admin should:

1. **Connect the GitHub integration**: If not already enabled, install the [GitHub integration](https://linear.app/docs/github.html#enable-the-github-integration) for your workspace, with code access enabled to allow Linear to read your repositories.
2. **Enable Code Intelligence**: To configure Code Intelligence, go to [*Settings* > *AI & Agents* > *Code Intelligence*](https://linear.app/settings/ai/code-intelligence.html).

![Enable Code Intelligence](https://webassets.linear.app/images/ornj730p/production/0046d64cedff691ac551c19cbdddc5e4a5eeb4ff-1386x540.png?w=1440&q=95&auto=format&dpr=2)

Once enabled, teams can use Code Intelligence to understand implementation details, find where functionality lives, identify architectural patterns, trace when something was added, see who contributed to specific parts of the codebase, and assess what constraints or dependencies might affect a plan or customer request.

Code Intelligence is not available to guest users. Only members, admins, and workspace owners can use Code Intelligence.

### Repository access[⁠](https://linear.app/docs/code-intelligence.html#repository-access)

By default, Code Intelligence only searches repositories that are:

* connected through your GitHub integration, and
* accessible to the member

Workspace admins or owners can also choose which repositories are available for Code Intelligence. This lets you expose only the repositories you want Linear Agent to analyze, rather than making all connected repositories available.

Repository access is permission-aware by default. If someone can’t access a repository in GitHub, Code Intelligence won’t use it for them.

### Extending access to all members[⁠](https://linear.app/docs/code-intelligence.html#extending-access-to-all-members)

Admins can enable *Extend access to all members* to let anyone in the workspace use Code Intelligence, even if they don’t have direct GitHub access. Once enabled, admins can scope that access to all repositories or only selected repositories.

This makes technical product context available to teams like Support, Sales, and Product without requiring direct repository access or pulling an engineer in for every question.

![Extend Code Intelligence access to all members](https://webassets.linear.app/images/ornj730p/production/d17061cfdb86cf8b4b16ce1d1635cee6b7a6a53d-1194x454.png?w=1440&q=95&auto=format&dpr=2)

### Agent guidance[⁠](https://linear.app/docs/code-intelligence.html#agent-guidance)

You can provide [Linear Agent guidance](https://linear.app/docs/linear-agent.html#guidance) to shape how this analysis works in your workspace.

This is useful for specifying repository conventions, architectural context, or preferences for how Linear should interpret and explain your codebase when answering code-related questions.

[Previous

Triage Intelligence](https://linear.app/docs/product-intelligence.html)[Next

MCP server](https://linear.app/docs/mcp.html)

* [Setup](https://linear.app/docs/code-intelligence.html#setup)
* [Repository access](https://linear.app/docs/code-intelligence.html#repository-access)
* [Extending access to all members](https://linear.app/docs/code-intelligence.html#extending-access-to-all-members)
* [Agent guidance](https://linear.app/docs/code-intelligence.html#agent-guidance)
