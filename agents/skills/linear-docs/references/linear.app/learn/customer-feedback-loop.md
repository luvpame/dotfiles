---
title: "Customer feedback  – Linear Learn"
source_url: "https://linear.app/learn/customer-feedback-loop"
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

[![](https://webassets.linear.app/images/ornj730p/production/5e0ad5a814c8fc11959d1d88817a010e058a1d25-3840x2160.png?q=95&auto=format&dpr=2)](https://webassets.linear.app/files/ornj730p/production/9d318cac4e136a37c3d861ab2246d61340c99ba9.mp4)

Elapsed00:00Remaining time unknown−--:--

0.25×0.5×0.75×1×1.25×1.5×1.75×2×

Every product team wants a steady read on what customers are saying. In practice, much of the most important feedback comes out of sales calls, and those are hard to sit in on at scale.

At Linear, [Gong](https://linear.app/docs/gong.html) recordings are brought into our workspace, where [Linear Agent](https://linear.app/docs/linear-agent.html) reads them and pulls out the requests and problems raised on each call. Those become issues in a dedicated team, giving Product one place to review the signal without mixing it into day-to-day product work.

That’s still more feedback than our product team can reasonably review, so they use two loops to help them prioritize their time and resources.

**The loops**

The first loop looks for repetition. It scans the team where Gong-generated issues are collected and checks how many customers have raised each request. Once the same request has come up across five or more customers, the loop moves it into the product team’s triage.

Linear Agent merges duplicate requests into a single issue, so the count is a fair proxy for how often something comes up. (Five is the threshold we use, another company might set it elsewhere.)

The second loop works from a shortlist of topics Product already cares about. These might be features the team recently launched, areas still in development, or ideas they’re looking to explore with customers. Each day, the loop reviews Gong conversations and sends the team a summary of any relevant discussions, including who represented both Linear and the customer.

Before Loops, getting the same information would have involved someone periodically searching call transcripts for relevant keywords, or Sales remembering which topics Product wanted to hear about and flagging them after a call. The loops remove that lossy layer of coordination.

**A seasoned workflow**

The second loop was finding the right information, but its initial reports were difficult to parse. Nan Yu, from our product team, asked Linear Agent to add headings, shorten the summaries, and separate input from the Linear team and customer participants into distinct bullet points. The agent showed him a preview of the revised output, and he approved the change. Since Linear Agent already has the loop in context, making adjustments can be as simple as describing what you want to change.

**Build your own**

Start with a flood of information your team already produces but doesn’t have time to read in full. Give the loop a way to filter it, either by a volume threshold or a list of topics you care about, and have it escalate only what clears the bar.

*Open [this prompt](https://linear.app/agent%3Fskill=loop-customer-feedback.html) in Linear Agent to adapt it to your own team, tools, and signals.*

* 00:00Intro
* 00:26Problem statement
* 01:27Loop overview
* 02:40Impact
