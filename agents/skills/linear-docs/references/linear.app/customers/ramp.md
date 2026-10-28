---
title: "The coding agent behind 75% of Ramp’s merged PRs"
source_url: "https://linear.app/customers/ramp"
fetched_at: "2026-10-27T08:17:41.028425+00:00"
---



1. [Customers](https://linear.app/customers.html)
2. Ramp

# The coding agent behind 75% of Ramp’s merged PRs

[](https://webassets.linear.app/files/ornj730p/production/6ac324027800a6898809b08ae7742ececc4cc737.mp4#t=0.001)

Elapsed00:00Remaining time unknown−--:--

0.25×0.5×0.75×1×1.25×1.5×1.75×2×

Businesses shuttle many billions of dollars along the lines of code in Ramp’s codebase each year. Despite the stakes, in November 2025 Ramp made the call to hand most of its code to an agent it built in-house. That agent, called Inspect, now writes three of every four PRs Ramp merges. Its context includes six years of specs, customer requests, and roadmaps kept in Linear.

Ramp[ramp.com ↗](https://ramp.com)

FoundedNew York, 2019

SwitchedOctober 2019

Company size1,600

### What Inspect is[⁠](https://linear.app/customers/ramp.html#what-inspect-is)

Inspect is a background coding agent that writes code and verifies its own output using the tools a Ramp engineer would reach for. Each session runs in a sandbox configured with Ramp’s own infrastructure, and anyone can start one from the web interface, a Chrome extension, or Slack, where a reply of “@Inspect, fix this” is often all it takes to open a PR.

Sessions are also shareable. A designer can take a dashboard rework most of the way there from a Figma file, then hand the session to an engineer to bring it live. Engineers end up reviewing work that is already close to done.

### Why Ramp built its own coding agent[⁠](https://linear.app/customers/ramp.html#why-ramp-built-its-own-coding-agent)

Inspect began as a casual idea between Zach Bruggeman and two colleagues, Jason Quense and Rahul Sengottuvelu, who built the first version in two weeks. Rather than adopt one of the many agents on the market, they wanted one shaped around Ramp’s internal workflows. “It’s a really tight integration with our development lifecycle and our tooling,” Zach says.

Building internally let them be exact about how the agent connects to everything else. They know the one API key it needs and precisely what the schema of their logs looks like, which made the agent faster to build and better at its job. A central team defines what agents can access and do, so functional teams can build their own automations safely on the same rails.

### How it works with Linear[⁠](https://linear.app/customers/ramp.html#how-it-works-with-linear)

Ramp has run its entire product development process through Linear since 2019, which means Linear holds a structured record of everything behind the product. The specs teams write, the feedback customers send, the roadmaps they plan against, and how it all connects.

By integrating through Linear’s API for agents, the team gave Inspect native access to that whole layer. Combined with its reach into Ramp’s codebase and internal docs, the agent operates with something close to the full picture a well-informed engineer would have. Asked to fix a bug, it can trace the thread from a customer request through a product spec to the relevant code, rather than working from a narrow prompt.

Zach calls the connection a natural fit, and says building it was quick. He prompted a coding agent with [Linear’s docs](https://linear.app/developers/agent-interaction.html), added a couple of rough pointers, and it got the integration “90 percent of the way there in about 30 minutes.”

The speed has moved Ramp’s bottleneck from writing code to reviewing it, a constraint any company running agents at this scale will meet. Zach says he’s paying close attention to how companies like Linear are shaping what code review becomes next.

*Since our interview with the Ramp team, we launched [Diffs](https://linear.app/docs/pull-request-reviews.html), which lets you review code changes directly in Linear.*

[![Commure logo](https://webassets.linear.app/images/ornj730p/production/82cefa82802a8608210897a66c0fe09b70382dc5-56x56.svg?q=95&auto=format&dpr=2)

Previous

Commure](commure.html)[![OpenAI logo](https://webassets.linear.app/images/ornj730p/production/ae73f1a60bba9e74933fe43829bc084f4dddcacf-56x56.svg?q=95&auto=format&dpr=2)

Next

OpenAI](openai.html)
