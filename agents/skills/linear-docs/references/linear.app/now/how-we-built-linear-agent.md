---
title: "How we built Linear Agent"
source_url: "https://linear.app/now/how-we-built-linear-agent"
fetched_at: "2026-10-27T08:17:41.028425+00:00"
---



1. [Now](https://linear.app/now.html)
2. [From the team](https://linear.app/now/team.html)

# How we built Linear Agent

![Abstract line illustration of overlapping solid and dashed ellipses within a rectangular grid, suggesting multiple possible paths constrained within a defined structure.](https://webassets.linear.app/images/ornj730p/production/ab66b30304843056d72e9af1af83f4afd1d0dfcd-3904x1920.jpg?q=95&auto=format&dpr=2)

![Abstract line illustration of overlapping solid and dashed ellipses within a rectangular grid, suggesting multiple possible paths constrained within a defined structure.](https://webassets.linear.app/images/ornj730p/production/1e8d0b4b8f7bcb6b3e755c2dca8569d8f8bfdb0b-2352x1280.jpg?q=95&auto=format&dpr=2)

[Matthijs Wolting](https://linear.app/now/author/matthijs-wolting.html)·August 10, 2026

Most software is designed to behave consistently. Good engineering has typically meant shrinking the space of possible outcomes until the same action reliably produces the same result.

AI inverts that logic, at least somewhat. Much of [Linear Agent’s](https://linear.app/docs/linear-agent.html) value lies in doing work we didn’t anticipate in ways we never explicitly defined; script its behavior too tightly, and we’d dilute the flexibility that makes it useful. So rather than engineering a fixed path for Linear Agent, we defined the boundaries within which it could find its own.

We drew those boundaries in the agent’s system prompt, the design of its tools, the agent’s model of Linear, the scope of each of its runs, and a custom harness underneath.

### The system prompt[⁠](https://linear.app/now/how-we-built-linear-agent.html#the-system-prompt)

We focused Linear Agent’s prompt on a small set of fundamentals.

**Communication style**

The agent should communicate clearly and naturally, without sounding overly corporate or too casual. It should also adapt its tone to the surface it’s operating in; for example, it might be more conversational in Slack than in a [Loop](https://linear.app/now/introducing-loops.html).

**Hard boundaries**

The agent shouldn’t offer opinions on sensitive topics like politics, religion, personal relationships, and the like. It also shouldn’t take actions that substantially expand the scope of a user’s request without requesting confirmation.

**Explanations of concepts unique to Linear**

The agent should understand the taxonomy of the product in order to interpret user requests and take the right actions on their behalf.

**Default opinions on how to use certain features**

User prompts are often very short, so the agent should have a strong sense for when to infer intent vis-à-vis ask a clarifying question.

A high-level system prompt like this gives the agent direction, while also leaving room for behavior that feels spontaneous and context-aware. In [Slack](https://linear.app/integrations/slack.html), for example, Linear Agent might pick up on the vibe of a conversation and chip in with a well-timed joke. At the same time, the boundaries in the prompt ensure it won’t engage if the joke was about a sensitive topic.

### The design of the agent’s tools[⁠](https://linear.app/now/how-we-built-linear-agent.html#the-design-of-the-agent's-tools)

We found it more effective to encode constraints into the design of Linear Agent’s tools than to spell them out in a prompt. We shape each tool so its parameters are easy to understand, and make invalid actions impractical to take. The principle is akin to building good code abstractions or user interfaces where intuitive behavior doesn’t need to be explained.

This also leaves room for the agent to become more capable as models improve. Since its action space isn’t over-scripted, and its tools can be combined flexibly, a more intelligent model can coordinate them to tackle increasingly complex tasks.

### The agent’s model of Linear[⁠](https://linear.app/now/how-we-built-linear-agent.html#the-agent's-model-of-linear)

Giving the agent room to improvise only works if it understands the environment it’s acting in. For Linear Agent, that meant teaching it the structure and semantics of the product, a challenge with a very different shape from building a coding agent.

Coding agents have a small set of deep tools, like `read_file`, `write_file`, and `run_command`, and nearly everything they do is a consequence of how they combine these primitives. Code and shell commands are also strongly represented in the model’s training, so these agents tend to have good instincts for using those tools even in unfamiliar situations.

Linear Agent has the opposite shape. It has a large number of comparatively shallow tools, each tied to a specific product operation like creating an issue or modifying a document. Using them well also requires an understanding of product concepts that aren’t represented well in the model’s existing knowledge (Linear may appear in the training data, but only to a negligible degree compared with code and shell).

As a result, enabling Linear Agent to work with any part of the product requires three things:

* Tools for reading and changing the relevant data
* An explanation of what that data represents and how it relates to the rest of the product
* A basic set of principles for using the feature well

Take [Customer Requests](https://linear.app/customer-requests.html) as an example. The corresponding skill gives the agent tools to create, update, and list requests across issues, projects, and customers. It explains that each request captures feedback from a specific customer, is typically linked to an issue or project, and summarizes what was requested. It also encodes best practices for using the feature; for instance, it’ll guide the agent to aggregate patterns across customer requests when drafting a project spec.

### The scope of each run[⁠](https://linear.app/now/how-we-built-linear-agent.html#the-scope-of-each-run)

The next challenge was exposing all this context and tooling to the agent without overwhelming it. As most user requests require only a small slice of Linear’s product surface, we introduced system skills as a unit of composition for the agent.

Each system skill bundles together some basic metadata, a fragment of the system prompt, and a set of tools. Together, they represent an independent set of capabilities that can be progressively disclosed to the agent when needed. (This is separate from user-created [skills](https://linear.app/docs/linear-agent.html#skills), which users can author for their own workflows. Those are reusable instructions created on top of the agent, not part of the built-in system skills described here.)

System skills are loaded behind the scenes, either before the agent begins working on a task or on-demand as the task unfolds. Before each run, Linear Agent infers which skills are likely to be relevant from the user’s prompt and the context in which it was invoked. An agent called from the Slack channel or Linear page for a project, for example, will likely have the ‘projects’ skill preloaded.

More indirect tasks may reveal additional requirements along the way. If a user asks the agent to draft an update for a project, we might initially load only the ‘projects’ and ‘project updates’ skills. As it begins the work, the agent may realize that it needs to review recent issues and PRs, and then load the corresponding skills itself.

This keeps each thread’s context focused while allowing Linear Agent as a whole to support a broad range of capabilities. It also lets us expand the agent’s capabilities over time without burdening every interaction with an ever-growing prompt and toolset.

In the build process, we considered giving the agent direct access to the Linear SDK and a coding environment, a CLI, or the GraphQL API. Exposing these low-level primitives would arguably enable more sophisticated behavior, but it would also increase the surface area for mistakes.

The underlying data model supports a wide range of actions, and some UI concepts require interpretation before they can be mapped to that model. A potential failure mode would be long-tail requests where, left without an obvious path to completion, the agent may attempt to solve the task through increasingly speculative actions.

In making this decision, we trade some breadth for predictability. The agent may occasionally refuse tasks it cannot safely complete, but its ability to make mistakes is much more limited.

### The custom harness underneath[⁠](https://linear.app/now/how-we-built-linear-agent.html#the-custom-harness-underneath)

Under the hood, Linear Agent runs on a custom stack that we own from the model-provider APIs upward. It includes:

* A provider-agnostic AI client that gives us a consistent wire and storage representation for LLM threads
* An agent loop built on a durable workflow engine
* A high-level streaming and storage layer that parses rich elements such as mentions and widgets before they reach the product

We chose a custom stack because harness libraries tend to have strong opinions about the agent’s execution flow built-in. At its core, this involves providing a prompt and a set of tools upfront, calling ‘run’, then waiting while the agent makes tool calls and produces a final response. While that works well for straightforward interactions, we wanted finer control over Linear Agent’s execution to support certain orchestration behaviors that occur while a run is still in progress.

**Dynamic tool injection via skills**

When the agent loads a skill, it needs to have access to its tools immediately after the tool call resolves so it can call new ones before responding to the user. We also wanted to do this in a way that preserves the provider’s prefix cache, which isn’t the case if implemented naively, because reprocessing existing context can drive up costs.

**Conditional tool call approval**

When an action is risky or difficult to undo, the agent should pause mid-run and ask the user for confirmation before proceeding. Most harness libraries support this through coarse rules that decide whether approval is required only from the tool name and its parameters, while we wanted this approval logic to be more contextual. For example, the agent can delete something it created during the current conversation without asking, while still requiring confirmation before deleting an existing issue. Similarly, it can post to most comment threads without approval, but should pause before posting to one synced with a public repository.

**Asynchronous sub-agent execution**

When a sub-agent is being executed, the parent agent will often be idle for many seconds on end. That should look like a synchronous tool call to the parent, but underneath it needs to be suspended so it doesn’t consume server-side resources while waiting for the sub-agent. That means being able to suspend an agent’s turn mid-tool call, do the work asynchronously, then resume the thread when ready.

These orchestration patterns are possible to implement without a custom harness, but they’d require awkward workarounds because the off-the-shelf ones are designed to support many different kinds of agents. By designing the harness to match Linear Agent’s orchestration needs, we can build toward the product experience without compromising on elegance or efficiency.

Owning the harness also lets us respond quickly to the long tail of errors and edge cases that emerge at scale, particularly when using model-provider features that are not yet widely adopted or thoroughly battle-tested by existing libraries.

### A moving target[⁠](https://linear.app/now/how-we-built-linear-agent.html#a-moving-target)

Building Linear Agent meant replacing software’s traditional goal of predictability with a more deliberate form of control. Each of these decisions is a bet on where the line between possibility and predictability sits, one that we believe will keep shifting over time.

[Matthijs Wolting](https://linear.app/now/author/matthijs-wolting.html)·August 10, 2026

Copy link
