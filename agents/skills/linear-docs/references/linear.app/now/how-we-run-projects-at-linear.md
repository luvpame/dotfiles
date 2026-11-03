---
title: "How we run projects at Linear - Linear"
source_url: "https://linear.app/now/how-we-run-projects-at-linear"
fetched_at: "2026-10-27T08:17:41.028425+00:00"
---



1. [Now](https://linear.app/now.html)
2. [From the team](https://linear.app/now/team.html)

# How we run projects at Linear

![Illustration of notifications, project updates, and project milestones icons.](https://webassets.linear.app/images/ornj730p/production/84bbef39807defe3fa83d35ce0d904177997207f-1028x472.svg?q=95&auto=format&dpr=2)

![Illustration of notifications, project updates, and project milestones icons.](https://webassets.linear.app/images/ornj730p/production/b42a578e4eafffa662c44f1cdd380c179800a96c-1028x472.svg?q=95&auto=format&dpr=2)

[Nan Yu](https://linear.app/now/author/nan-yu.html) and 2 others·October 05, 2023

In this interview our product and engineering teams explain how we plan and manage projects in Linear and keep the rest of the company up-to-date on their progress.

## Let’s start with the basics: What even is a project?[⁠](https://linear.app/now/how-we-run-projects-at-linear.html#let's-start-with-the-basics:-what-even-is-a-project)

[Nan Yu, Product](https://linear.app/now/author/nan-yu.html)

If I had to name a heuristic for what we would consider a project, it would be multiple people working on it. If multiple people work on it, and it takes over two weeks, that’s a project. If a single person works on something for two weeks, that’s probably not quite a project yet. We try to make it very obvious what the definition of being done with a project means because we believe that projects need to be completed at some point. There are exceptions, but the majority of projects should have end dates.

[Sabin Roman, Engineering](https://linear.app/now/author/sabin.html)

It’s difficult to give a single definition of a project — it really depends on context. During the planning phase, we define a high-level roadmap with themes that we want to address in the next six months or so. And we break those themes further into concrete features that we can build. Those features often become the projects themselves. The project descriptions are quite open-ended to start with. For example, about a year ago, we knew we wanted to build an analytics feature for Linear. But then it was up to the project team to define what that actually meant. Which metrics do we want to surface? What’s the user experience? And so on. What might have looked like a single project at the beginning turned into four or five different projects in the end.

[@portabletext/react] Unknown block type "inlineImage", specify a component for it in the `components.types` prop [Linear Insights](https://linear.app/features/insights.html)

## How do you go from the exploratory phase to writing project specs?[⁠](https://linear.app/now/how-we-run-projects-at-linear.html#how-do-you-go-from-the-exploratory-phase-to-writing-project-specs)

[Nan Yu, Product](https://linear.app/now/author/nan-yu.html)

In the beginning, we’ll collect everything we have heard about whatever we are about to work on in a doc or a tracking issue. That includes feedback, backlogs, user interviews, and random tickets. We synthesize the common themes and open questions. We involve everyone across engineering, design, and support.

With specs, we write about in what context this was a good idea. We help everyone understand the intent of why we’re undertaking a project, what are the problems we’re trying to solve, and what are the related problems or downstream issues. Giving people situational awareness is the main goal of project specs.

[Sabin Roman, Engineering](https://linear.app/now/author/sabin.html)

Most of our discussions and debates are around product decisions rather than technical implementation. Engineering discussions are very efficient as the team has a lot of trust, and folks are quite senior and have a good sense of the technical direction.

As we decide on the product and technical direction, we run multiple customer interviews, summarize the findings, and discuss them as a team. Once we have a rough direction, we document it, ask for a review, and iterate. We aim to write concise specs (1-2 pages) outlining our key product and technical decisions. Having crisp and focused specs makes for an easier read and better quality feedback.

## Who leads projects at Linear?[⁠](https://linear.app/now/how-we-run-projects-at-linear.html#who-leads-projects-at-linear)

[Raissa Largman, Engineering](https://linear.app/now/author/raissa-largman.html)

We’re still fairly small and only have one PM (Nan, our Head of Product), so we have always had engineers leading projects. Compared to my experiences in the past at bigger companies, where it was always the PMs leading everything, I really like it. There’s a lot of independence and autonomy; we get to influence the product roadmap quite a bit and run projects the way we want, which is more efficient than someone with less knowledge coming in micromanaging. Fewer dedicated PMs are required when you are still small, structure your teams properly, and have a fairly senior team.

## How do people get assigned as project leads, and what do the leads do?[⁠](https://linear.app/now/how-we-run-projects-at-linear.html#how-do-people-get-assigned-as-project-leads-and-what-do-the-leads-do)

[Sabin Roman, Engineering](https://linear.app/now/author/sabin.html)

The project leads are rotational. Nobody is the de facto project lead. We make sure that everybody on the team will be a project lead at some point. The project lead drives the communication around the project, shares updates, and ensures things are running on time. This allows the other engineers to focus on coding. It also helps every engineer to understand what it takes to be a project lead, especially when the projects are more complicated. It allows every person to learn that skill set and build empathy within the team for others.

[Raissa Largman, Engineering](https://linear.app/now/author/raissa-largman.html)

While project leads are rotational, we do consider relevant expertise from the past that would make an engineer more qualified to take on a particular project. It also depends on how much bandwidth people have. If you want to work on something, you can say I really want to work on that, and you probably will be able to work on that. There are things people don’t want to work on, and everybody has to take a turn and do what nobody wants.

## How do you keep others updated on the progress of your projects?[⁠](https://linear.app/now/how-we-run-projects-at-linear.html#how-do-you-keep-others-updated-on-the-progress-of-your-projects)

[Nan Yu, Product](https://linear.app/now/author/nan-yu.html)

We use project updates extensively. Each project lead writes a weekly update with a summary of the current state of the project and what’s top of mind.

[@portabletext/react] Unknown block type "inlineImage", specify a component for it in the `components.types` prop [Project Updates Docs](https://linear.app/docs/project-updates.html)

The format of these updates varies from project to project: Some are short and more high-level, others are longer and more technical. We often write updates right after project meetings and include the most important take-aways.

Here’s an example of a typical project update (from the project that led to our recently released project templates):

[@portabletext/react] Unknown block type "inlineImage", specify a component for it in the `components.types` prop [Changelog: Project templates](https://linear.app/changelog/2023-09-21-project-templates.html)

![A screenshot of a project update](https://webassets.linear.app/images/ornj730p/production/25052939bc6c43743ac82195962621d62e76a5ec-1176x1052.png?q=95&auto=format&dpr=2)

![A screenshot of a project update](https://webassets.linear.app/images/ornj730p/production/171d01c815e529da613ef51f979b51b1e719556c-1176x1052.png?q=95&auto=format&dpr=2)

To ensure that projects get updated on a regular basis, we have reminders set up that notify the project lead to post an update⁠.

[Raissa Largman, Engineering](https://linear.app/now/author/raissa-largman.html)

Everybody in our Linear workspace can read these updates and see where each project stands. To increase the visibility of project updates, we also have them sent automatically to Slack.

[@portabletext/react] Unknown block type "inlineImage", specify a component for it in the `components.types` prop [Slack Notifications Docs](https://linear.app/docs/project-updates.html#send-project-updates-to-slack)

We have a **#product-updates** channel which receives *all* Linear project updates, and individual channels for each Linear project (**#p-[projectname]**) where project-specific discussions happen.

## How do you use milestones?[⁠](https://linear.app/now/how-we-run-projects-at-linear.html#how-do-you-use-milestones)

[Nan Yu, Product](https://linear.app/now/author/nan-yu.html)

Let’s take a step back and return to the idea of being done with something. Issues want to be done. Projects want to be done. But projects have a lot of issues. We designed milestones to be able to let people define the concept of being done.

[@portabletext/react] Unknown block type "inlineImage", specify a component for it in the `components.types` prop [Milestones Docs](https://linear.app/docs/project-milestones.html)

If any open issues remain in a milestone bucket, it still needs to be done. On a project level, it’s a little more difficult because you have everything from issues we are working on to ideas we might want to explore.

Milestones let people decide different definitions of being done for different stages of the project. For example, a project might be done for a closed beta release — but there is still a lot of work that has to be completed for it to be done for a public release.

[Raissa Largman, Engineering](https://linear.app/now/author/raissa-largman.html)

We don’t have a set structure for how we use milestones in our projects, but it’s usually tied to different release stages of the project. This is a typical example:

![A screenshot of the milestones we used for a recent project: Internal, Beta, GA, Post-launch, Nice to haves](https://webassets.linear.app/images/ornj730p/production/2956499cab1f8161bfa8066d537afa477f149b42-1176x712.png?q=95&auto=format&dpr=2)

![A screenshot of the milestones we used for a recent project: Internal, Beta, GA, Post-launch, Nice to haves](https://webassets.linear.app/images/ornj730p/production/733c461e5bc6cb82fda1811c87e06dae7d980ce0-1176x712.png?q=95&auto=format&dpr=2)

## How do you know when something is good enough to ship?[⁠](https://linear.app/now/how-we-run-projects-at-linear.html#how-do-you-know-when-something-is-good-enough-to-ship)

[Sabin Roman, Engineering](https://linear.app/now/author/sabin.html)

There’s no strict process or a document with checkmarks to tell you when the project is ready for release. It comes down to the engineers working on the project feeling that the project is ready. And once they do, they share it with the team. Our weekly product meeting is focused on demos. We recently started experimenting with what we call “feature roasts”. If you are working on a feature and think it’s ready to be shipped, you can ask the team to try it out during the weekly meeting and provide instant feedback. So far, this has proved to be a productive and fun exercise. That’s how quality corrections happen at the team level. Once the team is ready, we submit it as a release candidate for company-wide feedback. For some projects, we release them to our private beta program (Origins) for feedback before we do the public release.

[Raissa Largman, Engineering](https://linear.app/now/author/raissa-largman.html)

You have to be on the same page about what level of polish you are trying to achieve to put something in front of a customer. There’s some risk management work — some users are okay with trying out half-baked stuff, some are not. We have escalating release channels and segmented users to balance this out.

When we release features to our beta customers, it’s still not at the polish level we aim for. If you release something and iterate too much, it can be difficult for your customers because they might have to relearn what they just figured out. The judgment around when to release boils down to the level of polish we look for and the size of the changes we expect to happen for that feature in the future.

## What’s next?[⁠](https://linear.app/now/how-we-run-projects-at-linear.html#what's-next)

[Nan Yu, Product](https://linear.app/now/author/nan-yu.html)

We are actively working on a variety of projects to improve Linear’s planning and roadmapping functionalities. An upcoming change we think folks will get excited about is the ability to comment on project updates. We have more coming and would love your feedback: [Join our Slack community](https://linear.app/join-slack.html) and tell us what we can do better for you when running your own projects on Linear.

[Nan Yu](https://linear.app/now/author/nan-yu.html) and 2 others·October 05, 2023

Copy link
