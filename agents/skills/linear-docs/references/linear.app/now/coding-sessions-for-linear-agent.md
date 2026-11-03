---
title: "Now Linear writes the code, too - Linear"
source_url: "https://linear.app/now/coding-sessions-for-linear-agent"
fetched_at: "2026-10-27T08:17:41.028425+00:00"
---



1. [Now](https://linear.app/now.html)
2. [Product launches](https://linear.app/now/product-launches.html)

# Now Linear writes the code, too

![Abstract image of circles forming a loop.](https://webassets.linear.app/images/ornj730p/production/46a4f840d2d33475f208f1660d5470840ff1dd38-3904x1920.png?q=95&auto=format&dpr=2)

![Abstract image of circles forming a loop.](https://webassets.linear.app/images/ornj730p/production/396db4762dd40882ee06b7a7ebb0908afc6525e1-2352x1280.png?q=95&auto=format&dpr=2)

[Karri Saarinen](https://linear.app/now/author/karri-saarinen.html)·June 11, 2026

Agents are becoming capable of doing more of the work involved in building software, but they’re still mostly individual productivity tools, useful to one person at a time.

Building a product is something a team does together, and the work that goes into it, like the decisions and the reasoning behind them, forms the context the whole product is built on.

That context rarely lives in one place. It accumulates across Linear issues, documents, Slack threads, and code, which is why we’ve worked to bring more of product development into Linear and pull it all together.

Linear Agent can draw on all of it. We’ve given it skills and automations so it follows how your team works, and MCP to reach the rest of your stack. It can read your codebase with Code Intelligence and help you review code changes with Diffs.

But the loop wasn’t complete. The coding work itself still happened somewhere else, so an engineer had to take the context from Linear, restate it inside another tool, monitor the work, and bring the result back for review.

Today, we’re launching **coding sessions, automated triage, and Diffs** to bring execution into the same shared system.

### Coding sessions[⁠](https://linear.app/now/coding-sessions-for-linear-agent.html#coding-sessions)

Coding sessions let Linear Agent natively move directly from an issue to implementation.

You can delegate an issue to the agent, ask it to fix something, or @mention it from Slack or Teams.

The agent reads the issue and its surrounding discussion, investigates the codebase, proposes an approach, writes the code, and opens a pull request. This all happens in the cloud, using frontier models and harnesses like Claude Code or Codex.

The coding session starts with the context already connected to the issue: the original request, customer signal, product decisions, related work, and discussion. Nobody needs to gather this information and reconstruct it inside a new prompt.

The session is also shared with the team. Anyone can follow the work, contribute context, redirect the approach, request changes, or take over. The session belongs to the organisation rather than to the person who started it.

### **Automated triage**[⁠](https://linear.app/now/coding-sessions-for-linear-agent.html#automated-triage)

Linear is already the place where a lot of problems and ideas arrive. A customer reports a bug by email, or the team raises one in Slack. Linear turns it into an issue in triage. For a lot of work, this is how the loop begins.

Most agents would wait for someone to take a look, add context, and hand it over. Instead, you can set up a [triage automation](https://linear.app/docs/triage.html#automation) that tags Linear Agent straight in, so it picks up the issue the moment it’s triaged rather than waiting to be told what to do.

You can set up the agent to first investigate the issue. It reads the codebase with [Code Intelligence](https://linear.app/changelog/2026-05-14-code-intelligence.html) and draws on the context around the issue, like the discussions and affected customers. The agent can also connect to your team’s other tools like Sentry or Datadog to triangulate the problem.

With a grasp of what to do, and the confidence there is a fix, the agent can open a coding session in the cloud, write a fix, open a pull request, and tag an engineer to review it.

More of your team’s work can be started the moment the problem arrives, around the clock.

### **Code review**[⁠](https://linear.app/now/coding-sessions-for-linear-agent.html#code-review)

Review is where the agent’s work returns to the team.

[Diffs](https://linear.app/changelog/2026-05-27-linear-diffs.html) provides a native way to understand code changes and review pull requests in Linear. Structural diffing and AI-guided reviews help explain what changed and where attention is needed.

The review sits right beside the issue and the discussion that caused the change, the same context the agent worked from, so you can move from the original report to the finished implementation without losing the thread between them.

Linear Agent stays with you the whole way, ready to answer questions, make changes, and keep iterating from the same place. Once approved, you can merge it from Linear.

### A new way of building[⁠](https://linear.app/now/coding-sessions-for-linear-agent.html#a-new-way-of-building)

This is a loop we run ourselves. In the last month, almost 700 PRs were merged by the agent. Not all of these were bugs, of course. The same workflow can be applied to a feature idea or a design change.

Workflows like this bring us closer to the vision we described in [*Self-driving SaaS*](https://linear.app/now/self-driving-saas.html), software that moves work forward on your behalf. How much of this runs on its own is your call. You can let the loop start from triage and run all the way to a draft PR, or kick it off yourself, handing the agent a single issue or a dozen at once. Either way, you decide where it starts and how far it goes before it’s back in your hands.

This is the shift from a tool for one person to a capability the whole organization shares. The loop happens on the context everyone can see and add to, so it belongs to the team rather than to whoever started the task. Models will keep changing, and the agents built on them, but the understanding they work from stays with the team and deepens with every loop.

The most advanced engineering teams have already started building this way. [Ramp built Inspect on our API](https://linear.app/customers/ramp.html), connecting its specs, customer feedback, and code. It now writes more than 60% of the pull requests they merge.

[Coinbase built Forge on our Agent SDK](https://linear.app/customers/coinbase.html), operating across Slack, GitHub, and Linear using the context already present in each system. They described Linear as the place where agents go to get their bearings before starting a task.

Linear Agent gives every team that capability, without the harness they had to build and maintain. It’s how Linear becomes the context layer that product development runs on.

To see the loop in action, watch our video in the [changelog](https://linear.app/changelog/2026-06-11-coding-sessions.html).

[Karri Saarinen](https://linear.app/now/author/karri-saarinen.html)·June 11, 2026

Copy link
