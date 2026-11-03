---
title: "How we use Linear Agent at Linear"
source_url: "https://linear.app/now/how-we-use-linear-agent-at-linear"
fetched_at: "2026-10-27T08:17:41.028425+00:00"
---



1. [Now](https://linear.app/now.html)
2. [From the team](https://linear.app/now/team.html)

# How we use Linear Agent at Linear

![Symmetrical white lines and dots radiating from a bright central point on a black background.](https://webassets.linear.app/images/ornj730p/production/86977630b775fb1df2f512797b56df9bf2671612-3904x1440.png?q=95&auto=format&dpr=2)

![Symmetrical white lines and dots radiating from a bright central point on a black background.](https://webassets.linear.app/images/ornj730p/production/51312b4fb5e11ff2f055a072614a3c623eb5e53a-2352x1280.png?q=95&auto=format&dpr=2)

[Rhea Purohit](https://linear.app/now/author/rhea-purohit.html)·April 10, 2026

Before we launched Linear agent, our teams were already using it across Slack, Linear, and our codebase. It’s become a core part of how we build. Here are three workflows that have proven most effective:

* A customer email turns into a shipped feature
* A Slack thread becomes a pull request
* A PM files an issue, and ships the fix

*As you’d expect, some of what we use internally has not been released yet, and we’ve called that out where relevant.*

### From customer email to shipped feature[⁠](https://linear.app/now/how-we-use-linear-agent-at-linear.html#from-customer-email-to-shipped-feature)

![Dark workflow diagram showing a support process from Intercom to Triage Intelligence, then to Product and Engineering, with Product linked to a Linear Agent and Engineering linked to a Coding Agent.](https://webassets.linear.app/images/ornj730p/production/be61e760ff9913e8be4ac3b07cfb153dc2e64569-3904x2158.png?q=95&auto=format&dpr=2)

![Dark workflow diagram showing a support process from Intercom to Triage Intelligence, then to Product and Engineering, with Product linked to a Linear Agent and Engineering linked to a Coding Agent.](https://webassets.linear.app/images/ornj730p/production/9ab45c0f49b0fda5d95d17e862c8b2d5dad1a3bc-2352x1346.png?q=95&auto=format&dpr=2)

#### Stage 1: Pull the context into Linear[⁠](https://linear.app/now/how-we-use-linear-agent-at-linear.html#stage-1:-pull-the-context-into-linear)

Customer feedback submitted by email, or in-app within Linear, accrues to an Intercom inbox managed by [Customer Experience](https://linear.app/now/cx-in-linear.html). That creates a large volume of high-signal feedback which needs to find its way through the org to the right team. Through [Linear agent](https://linear.app/integrations.html#customer-experience), CX turns emails into scoped issues directly from Intercom, without ever needing to leave the inbox.

![Dark interface mockup of an Intercom ticket sidebar with a Linear integration, showing a prompt field and a “Create with Linear Agent” button.](https://webassets.linear.app/images/ornj730p/production/591b2f6f77d262c9b6d914dede361554b3e3a38c-3904x2220.png?q=95&auto=format&dpr=2)

![Dark interface mockup of an Intercom ticket sidebar with a Linear integration, showing a prompt field and a “Create with Linear Agent” button.](https://webassets.linear.app/images/ornj730p/production/2d9ee3fb1c3681342ad55e4b44d88d3387600d87-2352x1336.png?q=95&auto=format&dpr=2)

The agent picks up the full context, including any back-and-forth with the customer, metadata, and attachments. While you can add extra details in Intercom to help define the issue, Alexandra Lapinsky Wilson, who leads Product Operations and CX, says she rarely finds it necessary. The agent typically gets it right.

### Stage 2: Route it to the right team automatically[⁠](https://linear.app/now/how-we-use-linear-agent-at-linear.html#stage-2:-route-it-to-the-right-team-automatically)

Once the agent has scoped the context into an actionable issue in Linear, the CX team doesn’t have to hesitate over who to assign it to because [Triage Intelligence](https://linear.app/docs/product-intelligence.html) handles that step. It sends feature requests to the product management team’s triage queue, and in doing so, flags duplicates, suggests the right labels, and links relevant customer context, including their [Datadog](https://linear.app/integrations/datadog.html) and [Sentry](https://linear.app/integrations/sentry.html).

![Dark UI card labeled “Triage Intelligence” showing suggested issue tags, a possible duplicate, and a related engineering issue](https://webassets.linear.app/images/ornj730p/production/9734ec1828019647b0dc1bee094f7cb07abbfa7b-3904x1178.png?q=95&auto=format&dpr=2)

![Dark UI card labeled “Triage Intelligence” showing suggested issue tags, a possible duplicate, and a related engineering issue](https://webassets.linear.app/images/ornj730p/production/c8f18c67d793f8283a8e922a744b42456dc62ab7-2352x1178.png?q=95&auto=format&dpr=2)

#### Stage 3: Make sense of overlapping feature requests[⁠](https://linear.app/now/how-we-use-linear-agent-at-linear.html#stage-3:-make-sense-of-overlapping-feature-requests)

Often projects can fill up with feature requests related to the same part of the product without *quite* asking for the same thing. Untangling this is time consuming and easy to put off, which can turn it into a bottleneck.

When Sid Bhargava, a PM, runs into a catch-all project like this, he opens a chat with Linear agent and asks it to identify the main themes across the requests; an example of a repeatable workflow that Sid could save as a [Skill](https://linear.app/changelog/2026-03-24-introducing-linear-agent.html#skills-and-automations).

![Dark UI mockup of an AI chat panel summarizing discussion themes inside Linear.](https://webassets.linear.app/images/ornj730p/production/ff720aa27f11fb7b8253ec8be6aa2eb9279319ab-3904x2220.png?q=95&auto=format&dpr=2)

![Dark UI mockup of an AI chat panel summarizing discussion themes inside Linear.](https://webassets.linear.app/images/ornj730p/production/cf1449a8787b7d2f63e2ae28eb06391381751b43-2352x1338.png?q=95&auto=format&dpr=2)

After reviewing the output, he instructs the agent to reorganize the issues around the themes, shaping the work into a clearer starting point for Engineering. Sid also might use the agent to add usage scenario context to an existing PRD, draft implementation issues based on a spec, or write a PRD from scratch for a new project.

#### Stage 4: Code alongside the agents[⁠](https://linear.app/now/how-we-use-linear-agent-at-linear.html#stage-4:-code-alongside-the-agents)

Once an engineer picks up the issue, how they work with the agent depends on the nature of the task at hand. For more complex requests, Mingjie Jiang, one of our product engineers, starts by chatting with Linear agent about the history of decisions around that part of the product: Why did we build the feature *this* way? When was it most recently touched? Which engineers should I talk to if I have further questions? The agent uses Code Intelligence to provide answers grounded in its knowledge of our codebase. *(We’re currently testing Code Intelligence and custom MCP servers internally, with plans to launch soon.)*

Mingjie then usually delegates the issue to a coding agent directly within Linear. While the issue reflects the delegation, it [remains assigned to him](https://linear.app/developers/aig.html#an-agent-cannot-be-held-accountable). The agent takes a first pass to save Mingjie the friction of starting from scratch, then, if necessary, he continues the work locally. He sees even AI’s mistakes as useful because it shows him potential failure modes as he works through the problem.

![Dark UI panel showing issue properties: status “In Progress,” assigned to “yann,” with a linked Coding Agent beneath](https://webassets.linear.app/images/ornj730p/production/6690d4e42578f85593a5cb705a5dc03042fe32c0-3904x1516.png?q=95&auto=format&dpr=2)

![Dark UI panel showing issue properties: status “In Progress,” assigned to “yann,” with a linked Coding Agent beneath](https://webassets.linear.app/images/ornj730p/production/05ddd50765d937a2299478d68b88bef289d519b3-2352x1100.png?q=95&auto=format&dpr=2)

At Linear, a coding agent takes a crack at reviewing every PR (for the past couple of months, we’ve been leaning on Codex for this), and then a human engineer makes the final approval. When the pull request is merged, our [Github integration](https://linear.app/integrations/github.html) marks the related issue in Linear as ‘Done’.

#### Stage 5: Close the loop with a happy customer[⁠](https://linear.app/now/how-we-use-linear-agent-at-linear.html#stage-5:-close-the-loop-with-a-happy-customer)

When an issue is marked ‘Done,’ every related feature request reopens in Intercom with a note for the CX team to know that the customer’s request is fulfilled. The team then follows up with each one, which Alexandra calls a joy because customers are delighted that their request made it into the product *and* that Linear took the time to tell them about it.

### How a complaint in Slack ends up as a pull request[⁠](https://linear.app/now/how-we-use-linear-agent-at-linear.html#how-a-complaint-in-slack-ends-up-as-a-pull-request)

![Dark workflow diagram showing Slack team discussion feeding into a Linear Agent and Triage system, with Code Intelligence connected below and arrows indicating a feedback loop between Slack and Linear.](https://webassets.linear.app/images/ornj730p/production/e71ccb4d99c30ddbf387d5ad17cedea87a9989fd-3904x2248.png?q=95&auto=format&dpr=2)

![Dark workflow diagram showing Slack team discussion feeding into a Linear Agent and Triage system, with Code Intelligence connected below and arrows indicating a feedback loop between Slack and Linear.](https://webassets.linear.app/images/ornj730p/production/d5579408aa607f7fdf157f90be930e47f45b391b-2352x1402.png?q=95&auto=format&dpr=2)

#### Stage 1: Turn a Slack thread into a scoped issue[⁠](https://linear.app/now/how-we-use-linear-agent-at-linear.html#stage-1:-turn-a-slack-thread-into-a-scoped-issue)

In shared Slack channels with our high-priority customers, ambiguous user feedback used to mean a scramble for context. Now, Simone Jacobs, who works in Customer Support, starts with [Linear’s Slack agent](https://linear.app/changelog/2025-10-23-linear-agent-for-slack.html).

Simone questions the agent in an internal product channel, with the intention of drawing Engineering and Product into a discussion about its response. She sees the agent’s role as providing context about the current state of the product, allowing the team to focus on the roadmap ahead.

![Dark Slack thread screenshot showing a teammate asking about private sub-team issues in a parent team’s cycle, followed by a Linear agent reply explaining they are not included. ](https://webassets.linear.app/images/ornj730p/production/d6e0a8745158615a1ae1b9db1b27e2a71bbadfba-3904x1782.png?q=95&auto=format&dpr=2)

![Dark Slack thread screenshot showing a teammate asking about private sub-team issues in a parent team’s cycle, followed by a Linear agent reply explaining they are not included. ](https://webassets.linear.app/images/ornj730p/production/06a793f876c27f6dc93a9852ca4bc2b817bbf250-2352x1200.png?q=95&auto=format&dpr=2)

Product engineers like Mingjie keep an eye on these discussions, often using the agent to create an issue routed to the engineering triage queue directly from Slack. And if the discussion continues, he tags Linear again to update the issue instead of reading through dozens of new messages.

![Dark Slack thread showing a user asking Linear to create triage issues from messages, followed by the app confirming that two issues were created.](https://webassets.linear.app/images/ornj730p/production/741848cfb4ad3a691ba6e893da449a5aa2a00f00-3904x1784.png?q=95&auto=format&dpr=2)

![Dark Slack thread showing a user asking Linear to create triage issues from messages, followed by the app confirming that two issues were created.](https://webassets.linear.app/images/ornj730p/production/75622f725db9eae1f1fadada97168ba78e40eedd-2352x1200.png?q=95&auto=format&dpr=2)

#### Stage 2: Code alongside the agents[⁠](https://linear.app/now/how-we-use-linear-agent-at-linear.html#stage-2:-code-alongside-the-agents)

When engineer Matthijs Wolting is assigned a customer-specific issue like this, he uses Linear agent, along with Code Intelligence and custom MCP servers, to investigate. This saves him from the tedium of looking up the right customer ID, logs, and metadata, and correlating information fragmented across various tools.

Matthijs gets the best results from coding agents by breaking the work into small, targeted steps, which keeps the agent on track and creates a much narrower path to success.

#### Stage 3: Close the loop with a happy customer[⁠](https://linear.app/now/how-we-use-linear-agent-at-linear.html#stage-3:-close-the-loop-with-a-happy-customer)

Once Matthijs has resolved the bug, he marks the issue as ‘Done’ in Linear. This automatically sends a notification to the Slack thread where the issue originated, which is Simone’s signal to follow up with the customer.

### When the person who noticed it can also ship it[⁠](https://linear.app/now/how-we-use-linear-agent-at-linear.html#when-the-person-who-noticed-it-can-also-ship-it)

![Dark workflow diagram showing Product creating a new issue that passes to a Linear Agent, then to a pull request routed to Engineering.](https://webassets.linear.app/images/ornj730p/production/615574c3f5efbf1fbdd23a53d23eba578950060a-3904x2032.png?q=95&auto=format&dpr=2)

![Dark workflow diagram showing Product creating a new issue that passes to a Linear Agent, then to a pull request routed to Engineering.](https://webassets.linear.app/images/ornj730p/production/38ebd6d50bcf4fee38687c0edfa2ebd6d3ee924a-2352x1269.png?q=95&auto=format&dpr=2)

#### Stage 1: Find a problem (and fix it)[⁠](https://linear.app/now/how-we-use-linear-agent-at-linear.html#stage-1:-find-a-problem-(and-fix-it))

Product managers like Sid are restless beings. He sometimes fiddles with features in Linear without a precise objective, just to re-experience them the way a new user would. Recently, he noticed there was no way to filter for issues that had been created from a specific external source, a gap that made it harder to track and triage that work

He used Linear agent to create an issue to add that filter *and* take a first pass at actually adding it. The agent opened a pull request, which was reviewed by a human engineer within the hour (thanks, Paco Coursey), and the change was live.

![Dark activity feed showing Linear posting a summary of code changes and a draft pull request on an issue timeline.](https://webassets.linear.app/images/ornj730p/production/ee171c7bfd359419392dd10f9e1a41970e65b4ea-3904x1824.png?q=95&auto=format&dpr=2)

![Dark activity feed showing Linear posting a summary of code changes and a draft pull request on an issue timeline.](https://webassets.linear.app/images/ornj730p/production/5af2f2479ced37c3f23bdf27114cd87e3c966e3d-2352x1100.png?q=95&auto=format&dpr=2)

#### …and there’s no Stage 2[⁠](https://linear.app/now/how-we-use-linear-agent-at-linear.html#...and-there's-no-stage-2)

The same prompt that Sid would’ve once used to report an issue can now be used to solve it. Deciding when to work this way, he says, is still a judgment call. UI polish like copy edits is an obvious candidate, but what made this especially interesting was that it was a functional, albeit small, change in the product.

### How you can get the most out of Linear[⁠](https://linear.app/now/how-we-use-linear-agent-at-linear.html#how-you-can-get-the-most-out-of-linear)

We’ve noticed a few recurring patterns in the way teams at Linear use the agent. The most effective workflows seem to share the same principles, and we’re keeping a running list of them, with an eye to consolidate in the near future.

#### The best workflows keep the agent close to the source[⁠](https://linear.app/now/how-we-use-linear-agent-at-linear.html#the-best-workflows-keep-the-agent-close-to-the-source)

Teams get the most value when they use it inside the systems where work is already happening, like Intercom, Slack, and Linear.

#### Autonomy works best when it is introduced gradually[⁠](https://linear.app/now/how-we-use-linear-agent-at-linear.html#autonomy-works-best-when-it-is-introduced-gradually)

Teams start by asking the agent for suggestions, observe its performance, and add guidance, only putting it on autopilot once it’s proven reliable. Engineers too, get better results by breaking work into small, focused steps instead of delegating a broad task.

#### The agent is most useful at points of friction[⁠](https://linear.app/now/how-we-use-linear-agent-at-linear.html#the-agent-is-most-useful-at-points-of-friction)

People use it where work would otherwise stall, whether that means making sense of overlapping requests, debugging a gnarly customer-specific issue, or clarifying ambiguous feedback.

[Rhea Purohit](https://linear.app/now/author/rhea-purohit.html)·April 10, 2026

Copy link
