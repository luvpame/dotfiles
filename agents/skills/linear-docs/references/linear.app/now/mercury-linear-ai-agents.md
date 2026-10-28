---
title: "Inside Mercury’s six-month journey building with AI agents - Linear"
source_url: "https://linear.app/now/mercury-linear-ai-agents"
fetched_at: "2026-10-27T08:17:41.028425+00:00"
---



1. [Now](https://linear.app/now.html)
2. [From the community](https://linear.app/now/community.html)

# Inside Mercury’s six-month journey building with AI agents

![An illustration showing the Mercury logomark](https://webassets.linear.app/images/ornj730p/production/92dad6db2faaab52a4fba92865eda3b9bb810b06-1952x880.png?q=95&auto=format&dpr=2)

![An illustration showing the Mercury logomark](https://webassets.linear.app/images/ornj730p/production/a087b11051e9521c3dca581594aba61a7641d9db-1176x640.png?q=95&auto=format&dpr=2)

Kevin Hartnett

·July 16, 2025

This past March, [Mercury](https://mercury.com/) held an internal hackathon and Matt Russell knew exactly what he wanted to work on.

Russell, a staff engineer at the seven-year-old financial technology company, was aware that coding agents were advancing rapidly and he wanted to see what they could do for Mercury. He and his hackathon team created a tool that allowed them to assign issues in Linear to third-party agents, which would return a pull request for engineers to review like any other PR. Almost immediately they saw the potential. The project showed how agents could reliably tackle simple, well-scoped tasks—like straightforward refactors or UI changes—under close human guidance.

Around the same time as the hackathon, Mercury joined the beta of [Linear for Agents](https://linear.app/agents.html), which gave Matt and his team a foundation for building more complex agentic workflows. In the months since, they’ve refined their ability to have agents one-shot routine tasks while learning how to guide agents step-by-step to accomplish more sophisticated projects. While many engineers at Mercury today use AI for code suggestions and, recently, in-editor agentic chat, a smaller group has started experimenting with other agentic workflows.

In the following conversation with Kevin Hartnett on the Linear team, Matt shares how Mercury is using agents today to move faster, reduce tech debt, and give internal teams more autonomy. He also talks through the company’s approach to shipping high-quality AI features, his strategy for keeping current on AI developments, and how he thinks engineering roles will change over the next five years.

This interview has been edited for clarity.

#### What kinds of tasks have turned out to be a good fit for agents?[⁠](https://linear.app/now/mercury-linear-ai-agents.html#what-kinds-of-tasks-have-turned-out-to-be-a-good-fit-for-agents)

**Matt Russell:** It comes back to how much you’re in the loop—nudging the agent along—and how far you go. If you’re really trying to one-shot, it’s hard to add much complexity. The task needs to be repeatable or follow some common pattern. It’s just too easy for the agent to go the wrong way.

We’ve found that getting agents to create a plan, start with step one, and then move to step two works great, especially in-editor for larger tasks. Not trying to do too big of a project in one go is key. Otherwise, they lose context and go off the rails.

#### So you stay involved and review each step?[⁠](https://linear.app/now/mercury-linear-ai-agents.html#so-you-stay-involved-and-review-each-step)

**Matt:** Yeah, we’ve found a lot of success saying, “I’m trying to work on X feature, I’m gonna go back and forth with you for a while until we agree on the plan. Then, let’s execute step one,” which might be writing test cases first. That helps center the AI and keep it on track. That’s worked quite well.

#### Tell us about one of your early experiments around providing agentic support for your ops team.[⁠](https://linear.app/now/mercury-linear-ai-agents.html#tell-us-about-one-of-your-early-experiments-around-providing-agentic-support-for-your-ops-team.)

**Matt:** One of the best use cases we saw, and one we still use today, was with some configuration UIs that our operators use to review activities in Mercury.

#### Where does the workflow originate?[⁠](https://linear.app/now/mercury-linear-ai-agents.html#where-does-the-workflow-originate)

**Matt:** We created a Linear Asks template around it. It would start from Slack where someone fills out five required fields, and it generates a ticket. The top part describes the task, and then there’s a “notes for AI” section at the bottom, with stuff like “Copy this approach” or “Refer to this PR as an example.” It was super repeatable and worked with almost no errors.

![A flow chart outlining Mercury's workflow: From Slack to Linear Asks to Linear Ticket to AI agent assigned to PR up to AI review to Human review to Merged](https://webassets.linear.app/images/ornj730p/production/9145ccda3243375772e877962ec3fbdfc2240f17-3904x1760.png?q=95&auto=format&dpr=2)

![A flow chart outlining Mercury's workflow: From Slack to Linear Asks to Linear Ticket to AI agent assigned to PR up to AI review to Human review to Merged](https://webassets.linear.app/images/ornj730p/production/2f4cc3958f54ecdae7f8124eb472d707d2dc393f-1176x640.png?q=95&auto=format&dpr=2)

#### So you were able to empower your ops team to resolve technical issues almost completely on their own, without engineering support?[⁠](https://linear.app/now/mercury-linear-ai-agents.html#so-you-were-able-to-empower-your-ops-team-to-resolve-technical-issues-almost-completely-on-their-own-without-engineering-support)

**Matt:** Yeah, we were able to make it so that some of these UIs could be built in a more self-serve way. An ops person could submit a ticket, it would get automatically assigned to an agent using a Linear template, and the agent would just pick it up, start working, and put up a PR. Then an engineer could review it—same as any other PR.

#### Are these agent experiments usually initiated by individual engineers?[⁠](https://linear.app/now/mercury-linear-ai-agents.html#are-these-agent-experiments-usually-initiated-by-individual-engineers)

**Matt:** There’s broad support from the top for using AI, but a lot of the experimentation definitely comes from ICs. People will try something out, see that it works well for their use case, and then that bubbles up.

We also have a lot of venues for sharing—engineering all-hands, team showcase events—where people show off things that are working. So there’s been a steady stream of demos and examples lately. There are just so many interesting ways to weave these tools into workflows.

#### How do agent reviews coexist with human reviews? Where do you see that balance going?[⁠](https://linear.app/now/mercury-linear-ai-agents.html#how-do-agent-reviews-coexist-with-human-reviews-where-do-you-see-that-balance-going)

**Matt:** The way we work today is: engineers put up PRs, and you own whatever code you push. Yes, AI may be a part of the process, but it’s still your code. You’re expected to have understood it, and you do a self-review first.

We’re piloting CodeRabbit for AI-generated reviews. Those usually come faster than human ones, and I’ve seen some great feedback. It catches logic errors and other issues. But we still need human approval. I don’t think that’ll change soon. We’ll keep evaluating, but I expect a human-in-the-loop signoff for a long time.

#### We’ve talked about internal workflows so far. How are you thinking about incorporating AI into the user experience at Mercury?[⁠](https://linear.app/now/mercury-linear-ai-agents.html#we've-talked-about-internal-workflows-so-far.-how-are-you-thinking-about-incorporating-ai-into-the-user-experience-at-mercury)

**Matt**: We’re trying to use AI in ways that enable not just our operations team, but also make the experience smoother for users. We started beta testing new search capabilities—kind of like what Linear has—where you can go from natural language into actual filters. So instead of figuring out how to select the necessary filter combinations a user can just say, “Show me how much I spent at Chipotle in the last two years,” and it’ll generate the right filter.

#### When building AI features—where the underlying technology is so new—how do you make sure you’re hitting your quality bar?[⁠](https://linear.app/now/mercury-linear-ai-agents.html#when-building-ai-featureswhere-the-underlying-technology-is-so-newhow-do-you-make-sure-you're-hitting-your-quality-bar)

**Matt:** We hold ourselves to a very high bar in terms of quality. That’s one of our core principles, and something we think differentiates us from more traditional banking software.

So it is a challenge. We want to be really comfortable with anything we put out there—especially because of the non-deterministic nature of LLMs. Whether that means using a reinforcement system on the backend to make sure it’s doing the right thing, or falling back to an alternative if it doesn’t seem quite right.

Or it could just mean putting it through really good testing or doing a slower rollout. We’re still figuring out exactly how this changes our approach. But we’re definitely conscious that we don’t want to sacrifice quality just to ship an AI feature. We want to make sure it’s actually improving things for our customers.

#### You’ve mentioned agents helping you get to more of the backlog. How do you think that changes the product?[⁠](https://linear.app/now/mercury-linear-ai-agents.html#you've-mentioned-agents-helping-you-get-to-more-of-the-backlog.-how-do-you-think-that-changes-the-product)

**Matt:** I think it’s great. There are enablements all across teams. Things that didn’t meet the threshold before can now get done: file a ticket, assign it to an agent, review the PR, and move on.

That lets us polish the product more and meet our standards. It also helps with tech debt—things that affect performance or help prevent bugs. I think that’s been really nice. One other thing I find interesting is how good agents are at larger refactors.

#### How does that change the way your team works?[⁠](https://linear.app/now/mercury-linear-ai-agents.html#how-does-that-change-the-way-your-team-works)

**Matt:** Upgrading to a new platform version or switching testing frameworks used to take months. Now you can say, “Switch from this library to that one—here’s an example,” and it can churn through it. That’s really freeing and you get productivity wins just by being on better systems.

#### What do you think engineering work at Mercury will look like in the future?[⁠](https://linear.app/now/mercury-linear-ai-agents.html#what-do-you-think-engineering-work-at-mercury-will-look-like-in-the-future)

**Matt:** It’s still early and things are evolving quickly, but maybe there’s a world in a few years where senior engineers act more like project leads over a bunch of agents. You’d scope the project, align with product, and then delegate the plan. From there, you’d check in and give feedback. It starts to feel more like a lead engineer working with junior engineers.

Once we can trust agents to run overnight, the pace of building is going to skyrocket. You’ll wake up, check in, and most of the feature will be done. That’s really exciting.

#### If someone in a role like yours were just starting out with agents, say six months behind where you are now, what advice would you give them?[⁠](https://linear.app/now/mercury-linear-ai-agents.html#if-someone-in-a-role-like-yours-were-just-starting-out-with-agents-say-six-months-behind-where-you-are-now-what-advice-would-you-give-them)

**Matt:** I mean, it’s a little cliché, but I think it’s really: experiment, experiment, experiment. Take the time to try different things, try new techniques, see what’s going to work for you. I would also highly recommend looking at AI code review. One of my favorite features is being able to teach these systems about patterns or styles at Mercury and automatically get those learnings applied across all reviews at scale.

One of the hardest things I find is keeping up with it. If I stop experimenting with the newest thing for a week or two, suddenly I feel like I’ve fallen quite far behind. So setting some kind of time budget—like maybe an hour a week, maybe more—to play with some new tools you’ve seen come out in the last week or so, I think is really key.

Kevin Hartnett

·July 16, 2025

Copy link
