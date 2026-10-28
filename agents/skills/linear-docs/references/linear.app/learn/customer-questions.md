---
title: "Customer questions  – Linear Learn"
source_url: "https://linear.app/learn/customer-questions"
fetched_at: "2026-10-27T08:17:41.028425+00:00"
---



* Getting Started

  + [![Intro to Linear](https://webassets.linear.app/images/ornj730p/production/f2c76a4fbbfacd7fa43151ffd6b0dd4004887778-16x16.svg?q=95&auto=format&dpr=2)Intro to Linear](intro-to-linear.html)
  + [![Daily workflows](https://webassets.linear.app/images/ornj730p/production/d4878dd72239e09ba60032fd9df7fc8f16592619-16x16.svg?q=95&auto=format&dpr=2)Daily workflows](daily-workflows.html)
  + [![Project planning](https://webassets.linear.app/images/ornj730p/production/949d63e2c807d558ddbcd0b0dd43304c0d711a44-16x16.svg?q=95&auto=format&dpr=2)Project planning](project-planning.html)
  + [![Managing unplanned work](https://webassets.linear.app/images/ornj730p/production/94d3042b1c7f10c2524e21fdb272622e31f854a4-16x16.svg?q=95&auto=format&dpr=2)Managing unplanned work](managing-unplanned-work.html)
  + [![Building with your users](https://webassets.linear.app/images/ornj730p/production/84c9746ab3b4c2967cdaa16c050ab9787f41844d-16x16.svg?q=95&auto=format&dpr=2)Building with your users](building-with-your-users.html)
  + [![Insights and analytics](https://webassets.linear.app/images/ornj730p/production/1e8ad14882bbd4f9c191935080647bb5e4280f7d-16x16.svg?q=95&auto=format&dpr=2)Insights and analytics](insights-and-analytics.html)
* Loops use cases

  + [![Database query](https://webassets.linear.app/images/ornj730p/production/a0257bf3fe03196cc9f9bd00d9f99fd4345f217d-16x16.svg?q=95&auto=format&dpr=2)Database query](database-query.html)
  + [![Docs maintenance](https://webassets.linear.app/images/ornj730p/production/a0257bf3fe03196cc9f9bd00d9f99fd4345f217d-16x16.svg?q=95&auto=format&dpr=2)Docs maintenance](docs-maintenance.html)
  + [![Customer questions ](https://webassets.linear.app/images/ornj730p/production/ac8134479271afe46a3f627291dcf78da8f45d07-16x16.svg?q=95&auto=format&dpr=2)Customer questions](customer-questions.html)
  + [![Customer feedback ](https://webassets.linear.app/images/ornj730p/production/ac8134479271afe46a3f627291dcf78da8f45d07-16x16.svg?q=95&auto=format&dpr=2)Customer feedback](customer-feedback-loop.html)

[![](https://webassets.linear.app/images/ornj730p/production/732184bbe9f609b554bca9a93c9c2ebe6f660bb4-3840x2160.png?q=95&auto=format&dpr=2)](https://webassets.linear.app/files/ornj730p/production/cf579ff83f4f7c8910916f862c57bcdd9debeae2.mp4)

Elapsed00:00Remaining time unknown−--:--

0.25×0.5×0.75×1×1.25×1.5×1.75×2×

A couple of years ago, Linear’s sales team created a Slack channel called #dumb-questions where sales reps could ask the type of question about the product that a teammate might answer quickly. Over time, though, the name of the channel became less and less accurate. As we began working with larger enterprises running sophisticated setups in Linear, the questions from the field often needed more than a quick reply.

Rather than send our small-but-mighty solutions engineering team off on a side quest every time a question came in, Eitan Meisels, who leads GTM enablement at Linear, wanted to find a way to scale their expertise.

**The loop**

Reps are now directed to a new Slack channel called #field-questions for anything that needs deeper technical input. When a question is posted there, a [Linear Ask](https://linear.app/features/asks.html) is automatically created, carrying the context from the Slack message into Linear.

That creates an issue in a dedicated Field Questions team and triggers the loop Eitan set up. The loop delegates the issue to [Linear Agent](https://linear.app/docs/linear-agent.html), which investigates the question using sources including our codebase via [Code Intelligence](https://linear.app/changelog/2026-05-14-code-intelligence.html), along with historical responses the solutions engineering team has provided in similar situations.

Linear Agent then drafts a response including its reasoning, any assumptions or caveats, a recommended next step, and an indication of how confident it is in its answer. The response is synced back to the original Slack thread, where a solutions engineer can review and sign off on it, with all the relevant context already assembled in one place.

**A seasoned workflow**

Eitan started with a short, one-paragraph prompt describing what he wanted the loop to do. He eventually rewrote the prompt in Markdown to make it more readable by the agent.

He also expanded what the agent could draw from. The first version relied primarily on Code Intelligence before posting an answer back to Slack; Eitan later connected GitHub and Notion, giving the agent access to technical solutions the solutions engineering team had built in the past.

**Build your own**

If a small group of experts repeatedly answers questions for a larger team, that’s a strong candidate for a loop. Start by mapping the sources they might rely on and give the loop access to the same inputs so it can research and draft responses for their review.

*Open [this prompt](https://linear.app/agent%3Fskill=loop-customer-questions.html) in Linear Agent to adapt it to your own team, tools, and signals.*

* 00:00Intro
* 00:21Problem statement
* 01:24Loop overview
* 01:57Loop workflow
