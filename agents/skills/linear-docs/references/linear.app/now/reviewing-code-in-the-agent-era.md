---
title: "Reviewing code in the agent era - Linear"
source_url: "https://linear.app/now/reviewing-code-in-the-agent-era"
fetched_at: "2026-10-27T08:17:41.028425+00:00"
---



1. [Now](https://linear.app/now.html)
2. [From the team](https://linear.app/now/team.html)

# Reviewing code in the agent era

![Abstract image showing connected nodes.](https://webassets.linear.app/images/ornj730p/production/33a00d1c8cadb31b27323d89daed1ac97160483b-3904x1760.png?q=95&auto=format&dpr=2)

![Abstract image showing connected nodes.](https://webassets.linear.app/images/ornj730p/production/6e7f1c488e4034fedd87334f696b42d410946140-2352x1280.png?q=95&auto=format&dpr=2)

[Maciek Pekala](https://linear.app/now/author/maciek-pekala.html)·June 10, 2026

Last week we launched Diffs, a new way to review PRs directly inside Linear. Since then we’ve had a lot of questions about it, so we wanted to share more about why we built the feature and how we use it ourselves today.

Like a lot of people who build software, I felt the ground shift at the start of 2026. The models got better, the agents got better with them, and almost overnight the amount of code moving through my team went up. Between January and March our total issues created and PRs merged both climbed by 50%.

That was exciting, and it was also a problem. With that much code moving, I felt the pull to “looks good!” my way through reviews just to keep the queue down, and that sat badly with me, because quality is something we genuinely obsess over at Linear. I kept landing on the same question, which was how I could stay on top of this much review without lowering my bar.

That question is really why we leaned so hard into building Linear Diffs this year. After several months of living in it, I can say it has helped me tame the deluge of agentic code, and here is how I use it day to day.

Reviews now have a prominent space in Linear, so I can easily stay on top of what I need to review for others and my own work that’s getting reviewed.

I rely on Linear’s notifications system, both via the inbox in the app and through the Slack integration, so I don’t miss when new requests come in or when I get new feedback.

![Linear UI showing Slack and native Linear notifications.](https://webassets.linear.app/images/ornj730p/production/caa1862ce16e07803f9c6912ad19e9e72af2040a-3904x2560.png?q=95&auto=format&dpr=2)

![Linear UI showing Slack and native Linear notifications.](https://webassets.linear.app/images/ornj730p/production/cd1c3b9952b630b1fa14e9bbf7190b6b0773c32c-2352x1544.png?q=95&auto=format&dpr=2)

When I pick up a review request, the first thing I do is get my bearings. I want to understand why we’re making a change in the first place. With Reviews in Linear, I’m only one click away from seeing what inspired the code, like a piece of customer feedback, a bug report, or an idea someone shared on a Slack thread.

![Linear UI showing issue context.](https://webassets.linear.app/images/ornj730p/production/e078cae6cfe1ee729014da20da8e83c3c7dbeb5c-3904x2100.png?q=95&auto=format&dpr=2)

![Linear UI showing issue context.](https://webassets.linear.app/images/ornj730p/production/a54a286619699a9b882c43d98e46807a636eab62-2352x1446.png?q=95&auto=format&dpr=2)

If the change is something you can see, like a UI tweak or a new flow, I’ll open the preview build first to feel how it behaves. I take screenshots and screen recordings to flag anything that looks or feels off, so the author sees exactly what I’m reacting to.

![Linear UI showing Preview feature.](https://webassets.linear.app/images/ornj730p/production/7825d563d94422cbfacbbeccb85035672d02f101-3904x1560.png?q=95&auto=format&dpr=2)

![Linear UI showing Preview feature.](https://webassets.linear.app/images/ornj730p/production/c664386b77b101ffcf034551e1e48835c6122d1c-2352x1446.png?q=95&auto=format&dpr=2)

Then I move to the diff itself. I scroll through once to get a sense of the size, patterns, scope. If the change is sizable, I then switch into a guided review. Linear groups the change into chunks that read like a story, so I can follow the logic instead of skimming a wall of red and green.

![Linear UI showing Guided Reviews.](https://webassets.linear.app/images/ornj730p/production/5f64a360cfebfde6499327e1921359601f6bf032-3904x2400.png?q=95&auto=format&dpr=2)

![Linear UI showing Guided Reviews.](https://webassets.linear.app/images/ornj730p/production/5dfb0c1e8d1b95d72ef2ead08a95dc3bc0994d07-2352x1444.png?q=95&auto=format&dpr=2)

I don’t read line by line, because finding bugs and checking for logic correctness is now mostly covered by agents. I’ve got that time back, so I spend it thinking about whether the change fits the system and actually solves the problem. I can think about edge cases, user experience, or alternative solutions. I’ll admit, with a bit of guilt, that this is the part I sometimes glossed over when all my energy was previously going into parsing the code itself.

Of all the ways people talk about the role of an engineer changing, this shift toward judgment is the one I actually see in my own work. To be a valuable reviewer you have to develop more of the product sensibilities, and know customer pain and real-world impact more deeply. I think it’s a good thing, because it elevates the role of an engineer further.

Every so often I’ll notice the change is solving the wrong problem. Someone (or an agent) took the brief too literally and we have to take a step back and approach it from a different angle. When that happens, I’ll start a discussion with the team. It’s easier to bring more people into the loop when all the relevant context is so readily available next to the code change.

More often, the change is broadly on track and the work stays inside the diff. I’ll leave a comment when I want the author to think something through or tweak. They can use an agent directly in Linear to address those comments, and I can also contribute to those same sessions to clarify my feedback.

![Linear UI showing a code change being made with Linear Agent.](https://webassets.linear.app/images/ornj730p/production/65780d00337cfffd62ecaf0cf7e6121a31f8b467-3904x2100.png?q=95&auto=format&dpr=2)

![Linear UI showing a code change being made with Linear Agent.](https://webassets.linear.app/images/ornj730p/production/cf48fecc63b337551dce00b7190a1375a5230342-2352x1446.png?q=95&auto=format&dpr=2)

I find these opportunities to collaborate directly with my team incredibly useful now that we’re spending more of our day alone with agents. Review is one of few moments when we look at each other’s work directly. I get to see what someone else is thinking, disagree with them about something, or notice that they’re doing something smarter than I would have. It’s also where your engineering culture shows up. Do people ask the hard questions and keep each other accountable to a high bar?

Collectively this means that even with a higher volume of PRs, I’m confident our quality is holding up. For us, quality code review has come to mean that the code is useful, not just correct. I’m enjoying spending more of my time in review deciding whether what we’re shipping earns its place in the product at all, not just whether it works.

[Maciek Pekala](https://linear.app/now/author/maciek-pekala.html)·June 10, 2026

Copy link
