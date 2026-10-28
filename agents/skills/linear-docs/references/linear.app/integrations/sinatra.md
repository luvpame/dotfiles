---
title: "Sinatra Integration – Linear"
source_url: "https://linear.app/integrations/sinatra"
fetched_at: "2026-10-27T08:17:41.028425+00:00"
---



1. [Integrations](https://linear.app/integrations.html)
2. Sinatra

# Assign issues to Sinatra and draft pull requests

![Sinatra being assigned](https://webassets.linear.app/images/ornj730p/production/f880d557a92b0d0777852d5e5d1573d2534f9ef7-1600x1000.png?q=95&auto=format&dpr=2)

![Sinatra being assigned](https://webassets.linear.app/images/ornj730p/production/f880d557a92b0d0777852d5e5d1573d2534f9ef7-1600x1000.png?q=95&auto=format&dpr=2)

![sinatra opening pull request](https://webassets.linear.app/images/ornj730p/production/70bd27811cbce9e9420617f0d4c0c0520f3cf68b-1600x1000.png?q=95&auto=format&dpr=2)

![sinatra showing commits ready for review](https://webassets.linear.app/images/ornj730p/production/3fbe16f79c449239c0beca96dd819c5f07769bd7-1600x1000.png?q=95&auto=format&dpr=2)

## Overview[⁠](https://linear.app/integrations/sinatra.html#overview)

Sinatra is a background coding agent you assign Linear issues to. It clones the repository into its own sandbox, writes the code, runs your tests, opens a pull request on GitHub, and reports progress back on the issue. It runs on the Claude or ChatGPT subscription or API key your team already has. Sinatra never bills for model usage.

## How it works[⁠](https://linear.app/integrations/sinatra.html#how-it-works)

Assign an issue to Sinatra, or @mention it in a comment, and it picks the work up in a fresh, isolated cloud sandbox with the repository cloned in. If an issue is vague, it asks questions or proposes a plan on the issue, and carries on when you reply. Clear issues go straight to code.

While it works it posts progress on the issue as a single updating comment, so the thread stays readable. It writes the change, runs your project’s test command inside the sandbox, and opens a pull request on GitHub, linked back on the Linear issue. Before anyone reviews it, the agent reviews its own diff and posts what it found on the pull request, so reviewers start from a findings list instead of from zero.

Review comments on the pull request go back to the agent, which pushes fixes to the same branch. Sinatra never merges its own work; a human reviews and merges every pull request. It supports Claude and ChatGPT subscriptions as well as Anthropic and OpenRouter API keys. Per-repository behavior (model, test command, sandbox image) is configured in a .sinatrarc file.

## Configure[⁠](https://linear.app/integrations/sinatra.html#configure)

1. Create a workspace at [app.sinatra.dev](https://app.sinatra.dev) and install the Sinatra GitHub App on the repositories the agent may work in.
2. In workspace settings, click Connect Linear and authorize Sinatra in your Linear workspace. You need to be an owner or admin of the Sinatra workspace, and a Linear admin to approve the app install.
3. Connect a model: a Claude or ChatGPT subscription, or an Anthropic or OpenRouter API key. Free runs 1 task at a time, plus 1 queued, with no daily limit and no card.
4. Assign an issue to Sinatra (or @mention it) and it starts. Optional per-repo settings live in [.sinatrarc](https://docs.sinatra.dev/docs/configuration/sinatrarc).

Website
[sinatra.dev](https://sinatra.dev/?ref=linear)

Category
[Agents](https://linear.app/integrations/agents.html)

Contact

[Sinatra](mailto:contact@sinatra.dev)

[Open website](https://docs.sinatra.dev/docs/configuration/linear-app)

#### You might be interested in

[Browse all integrations](https://linear.app/integrations.html)

* [![Cyrus icon](https://webassets.linear.app/images/ornj730p/production/f1e78a990f524c181611f14eac60afb3f55cfa56-320x320.svg?w=256&q=95&auto=format&dpr=2)

  Cyrus

  By Ceedar

  Your Claude Code powered Linear agent that runs anywhere](cyrus.html)
* [![Devin icon](https://webassets.linear.app/images/ornj730p/production/30ce4517f876ac3e290a80f4cfb0b7b3b8c998b7-320x320.svg?w=256&q=95&auto=format&dpr=2)

  Devin

  By Cognition

  Automate work from issue to tested PR with Devin](devin.html)
* [![Codex icon](https://webassets.linear.app/images/ornj730p/production/a7789d9c4baa178dc6043070519e7e32b238bffa-980x980.jpg?w=256&q=95&auto=format&dpr=2)

  Codex

  By OpenAI

  Delegate issues to Codex directly from Linear](codex.html)

## Build your own agents

Create your own integration with Linear’s API and submit it to the directory.

[Start building](https://linear.app/developers/agents.html)

## Build your own agents

Create your own integration with Linear’s API and submit it to the directory.
