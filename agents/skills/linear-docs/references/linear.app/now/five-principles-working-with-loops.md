---
title: "Five principles for working with Loops"
source_url: "https://linear.app/now/five-principles-working-with-loops"
fetched_at: "2026-10-27T08:17:41.028425+00:00"
---



1. [Now](https://linear.app/now.html)
2. [From the team](https://linear.app/now/team.html)

# Five principles for working with Loops

![A series of five interconnected, looping arrows arranged horizontally along a line pointing to the right, illustrating a continuous, iterative process. Solid and dashed gray lines distinguish the visible and hidden portions of each loop against a black background.](https://webassets.linear.app/images/ornj730p/production/c5d2a52096218c48b3eed1867b111c7eef56f294-3904x1760.png?q=95&auto=format&dpr=2)

![A series of five interconnected, looping arrows arranged horizontally along a line pointing to the right, illustrating a continuous, iterative process. Solid and dashed gray lines distinguish the visible and hidden portions of each loop against a black background.](https://webassets.linear.app/images/ornj730p/production/22b743f2239c5967c6b393c1d76078b37a051cdb-2352x1280.png?q=95&auto=format&dpr=2)

[Andrew Moedinger](https://linear.app/now/author/andrew-moedinger.html)·October 13, 2026

I’m one of the engineers building [Loops](https://linear.app/changelog/2026-07-20-introducing-loops.html), and I’ve been using it extensively to automate different parts of my own work, from triaging bug reports in our Slack channels to cleaning up obsolete code.

[Loops](https://linear.app/changelog/2026-07-20-introducing-loops.html) gives you a way to automate recurring work with the Linear Agent by describing a job in plain language. You can choose whether a loop should run on a schedule or in response to an event.

Working effectively with agents is increasingly a matter of learning how to delegate well, so I wrote down a few lessons I’ve picked up along the way.

### Hunt for tasks you can delegate[⁠](https://linear.app/now/five-principles-working-with-loops.html#hunt-for-tasks-you-can-delegate)

Loops are extremely versatile, so you probably won’t think of all the ways they can help you on day one. A useful place to start is with recurring tasks, whether it’s something you do a few times a day, month, or quarter. It’s also helpful to notice things you want to get done but sometimes let slip through the cracks.

I try to think about automation the way you might think about delegation, and ask what I’d hand off to an extra pair of hands on the team, or a personal executive assistant. Look beyond your own work, too. Listen for what frustrates your teammates, especially recurring tasks that drain their time or energy.

#### In practice[⁠](https://linear.app/now/five-principles-working-with-loops.html#in-practice)

Reported vulnerabilities have risen sharply this year, and they range from urgent to irrelevant. Rather than triage all of that by hand, our security team runs a few loops. One pulls scan results from a separate tool over MCP and creates issues for the higher-priority findings, which agents then help fix. Another reviews inbound bug bounty reports, flags duplicates and anything out of scope, and does a first round of code analysis before a person looks at it.

### Be incremental in your approach[⁠](https://linear.app/now/five-principles-working-with-loops.html#be-incremental-in-your-approach)

You probably won’t get everything you want from a loop with a one-shot prompt. But even a narrowly scoped loop can save meaningful time, so start small, both in the scope of the task and in the consequences of getting it wrong. Then iterate, expanding the loop’s responsibilities as you see the results you want and building your confidence in its ability to perform.

#### In practice[⁠](https://linear.app/now/five-principles-working-with-loops.html#in-practice-2)

I built a loop to clean up a particular type of deprecated code. At first, I wasn’t sure how many results it would produce or how reliable they would be, and since I didn’t want to spam teammates with test runs, I built it iteratively.

I started by having the loop identify candidate issues, then used the results to refine the criteria for determining which code should be deleted. I grew more confident in the results and had it send issues to our [triage inbox](https://linear.app/docs/triage.html), including a description of why it would pick a specific assignee (without actually assigning them). I also limited it to creating five issues at a time rather than tackling the 80-odd cases in the codebase at once.

Finally, with enough trust in its choice of work and owner, I let it assign issues directly and delegate them to an agent, leaving the assigned engineer to review and submit the resulting PR.

### Lean into the available context[⁠](https://linear.app/now/five-principles-working-with-loops.html#lean-into-the-available-context)

Loops pull context from across a Linear workspace and any connected tools. They also run on the [Linear Agent’s harness](https://linear.app/now/how-we-built-linear-agent.html), which gives them the tools and execution environment they need to use all of that context well. So you don’t need to overspecify details when describing a task, and each run can work with the current state of your projects, issues, code, documents, and conversations.

#### In practice[⁠](https://linear.app/now/five-principles-working-with-loops.html#in-practice-3)

Our own loops lean on this heavily. One of our bug autofixing loops references a team skill for investigating bugs, checks for related or duplicate issues, and reads the documents that define product ownership areas. Our triage loops search for similar issues and check who recently touched the relevant parts of the codebase, which tells them who knows a particular feature best, and a meeting prep loop reads our team’s Slack channel for unresolved questions.

### Use the agent to help you iterate[⁠](https://linear.app/now/five-principles-working-with-loops.html#use-the-agent-to-help-you-iterate)

Ask the Linear Agent to figure out why a loop isn’t delivering the results you want and update it for you, or to rework the instructions of one that’s too verbose until you’re happy with the output. The agent can also estimate what a run will produce before you commit to it, and start a run when you’re ready to test.

#### In practice[⁠](https://linear.app/now/five-principles-working-with-loops.html#in-practice-4)

I recently set up a loop to help prepare for a weekly team meeting. It reviews relevant Slack channels and the open issues in our project, and drafts a meeting agenda from that context. As expected, it wasn’t exactly what I wanted the first time I ran it. It was too verbose, it didn’t find the right Slack channel, and it included some extra description about the process it used to evaluate meeting topics. So instead of trying to fine-tune the loop’s instructions manually, I asked the Linear Agent to update the loop and run it again. After a couple minutes of back-and-forth, the result was much closer to what I wanted.

### Keep your team in the loop[⁠](https://linear.app/now/five-principles-working-with-loops.html#keep-your-team-in-the-loop)

A loop sits inside a team, where any member can open it, see what it’s done on each run and change it if needed, or at the workspace level, where everyone can see it and admins manage it. A loop can also be set up to inform people more actively, whether that’s posting to a Slack channel or working out who the right person to involve is from a schedule or on-call rotation.

#### In practice[⁠](https://linear.app/now/five-principles-working-with-loops.html#in-practice-5)

Our customer success team shares a loop that runs when a new issue comment tags one of them. It checks whether the tagged person is working, and outside their hours it notifies whoever is on call instead, so important customer requests get a quick response even when the person asked is offline.

### A practice in delegation[⁠](https://linear.app/now/five-principles-working-with-loops.html#a-practice-in-delegation)

I thought of Loops as an automation feature when I started working on it. Using it every day, I’ve come to think of it more as practice in delegation, and each of the principles above is really about learning how to hand work off well. More of the recurring work in engineering can be delegated to agents now, and the work that stays with us is deciding what to delegate and giving the agent the context and constraints it needs to run reliably.

*Give [Loops](https://linear.app/docs/loops.html) a try, and we’d love to hear how you’re using it.*

[Andrew Moedinger](https://linear.app/now/author/andrew-moedinger.html)·October 13, 2026

Copy link
