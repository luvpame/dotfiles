---
title: "Database query – Linear Learn"
source_url: "https://linear.app/learn/database-query"
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

[![](https://webassets.linear.app/images/ornj730p/production/0494d6f86a7ae44439d8516dcc495cc45b5fd73b-1920x1080.png?q=95&auto=format&dpr=2)](https://webassets.linear.app/files/ornj730p/production/5cee6ba671c0520bb1a56202897c35e6cccd4662.mp4)

Elapsed00:00Remaining time unknown−--:--

0.25×0.5×0.75×1×1.25×1.5×1.75×2×

Linear runs millions of PostgreSQL queries every day, and even a single inefficient one can degrade performance, or worse, cause an outage. Until recently, this meant that infrastructure engineer Sean Callahan began each day combing through hundreds of healthy queries in Datadog to find the two or three that weren’t.

**The loop**

Sean has since reclaimed his mornings by setting up a loop. Every weekday, it reviews the last 24 hours of query performance through the [Datadog MCP](https://linear.app/docs/connect-mcp-servers-to-linear-agent.html) and chooses the three highest-impact candidates for investigation.

The loop first checks for known issues and tests potential changes through an internal database MCP to confirm whether a practical fix exists. When it finds something actionable, it creates an issue, and from there, the infrastructure team can decide what happens next. Sean or another engineer can pick it up, or, with [code intelligence](https://linear.app/now/code-intelligence-for-linear-agent.html) and [coding sessions](https://linear.app/now/coding-sessions-for-linear-agent.html) enabled, the loop can open a PR for review. If there are no new offending queries, the loop notifies him of the fact.

**A seasoned workflow**

Sean wrote the first version of the prompt himself, subsequently revising it with [Linear agent](https://linear.app/docs/linear-agent.html) to focus each run on the most relevant queries. He taught the loop to ignore ones that were unlikely to have an actionable solution, as well as queries that were slow but already as optimized as possible. It now saves him 30 to 45 minutes of reviewing a sea of data each morning, helping keep Linear performant (and [lightning-fast](https://linear.app/blog/scaling-the-linear-sync-engine.html)).

**Build your own**

If you want to build something similar, start with the part of your workflow where dense data makes your eyes glaze over, connect the loop to the tools it needs to access the data and investigate what it finds, and refine the instructions after a few real runs.

#### Build a Loop to investigate performance issues[⁠](https://linear.app/learn/database-query.html#build-a-loop-to-investigate-performance-issues)

*Want to apply this workflow to your own telemetry? Open [this prompt](https://linear.app/agent%3Fskill=loop-telemetry-performance.html) in Linear Agent to adapt it to your team, tools, and performance signals.*

* 00:00Intro
* 00:13Problem statement
* 00:56Loop overview
* 01:13Creating the loop
* 02:23Loop output
