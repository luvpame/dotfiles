---
title: "Loops use case: Docs maintenance"
source_url: "https://linear.app/learn/docs-maintenance"
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

[![](https://webassets.linear.app/images/ornj730p/production/a39a39d7ddaf6bf4acb290cb30aab2f29e91ad9a-1920x1080.png?q=95&auto=format&dpr=2)](https://webassets.linear.app/files/ornj730p/production/253e97a1ee71c50977199c3612e3e541c2a468cc.mp4)

Elapsed00:00Remaining time unknown−--:--

0.25×0.5×0.75×1×1.25×1.5×1.75×2×

Many of the changes we ship to Linear don’t come with the fanfare of a full-blown launch. A [bug fix](https://linear.app/now/zero-bugs-policy.html) here, a [quality-of-life update](https://x.com/linear/status/2067320525412589677?s=20) there, our engineers are predisposed to making small tweaks that might affect how the product works.

Those changes make Linear better, but as an unintended side effect, our [docs](https://linear.app/docs.html) can drift out of sync with the product. Alan Doyle, a member of our Customer Experience team, wanted to close the gap without anyone having to manually reconcile the docs.

**The loop**

Alan built a loop that runs everyday, looking for product changes since its last run. It checks the codebase using [Code Intelligence](https://linear.app/docs/code-intelligence.html), launch-related initiatives in Linear, issues the CX team is working on, and relevant Slack channels; and then compares what it finds against our docs.

Throughout the week, the loop collects its findings in a running document. It includes the strongest candidates for a docs update, explains the context behind each suggestion, and also records changes it investigated but ruled out.

At the end of the week, the loop creates an issue for Alan to review. He works through the document with [Linear Agent](https://linear.app/docs/linear-agent.html), deciding whether the docs need to change and, when they do, refining the proposed wording with the agent before making the update.

**A seasoned workflow**

Alan wrote the initial prompt with Linear Agent, put the loop to the test, and iterated over time. For example, the first version relied heavily on updates posted to Slack and Linear, which often excluded smaller changes such as adjustments to the UI or URLs; so he expanded scope to include the codebase which would capture those changes implicitly.

Alan also adjusted the cadence. Initially, the loop created a new issue for him every day, but when that became too noisy, he moved to a weekly review.

Finally, he refined the instructions to discourage change for change’s sake. The loop is now instructed to first understand the level of detail already present in a doc, and only suggest an update when it would improve accuracy. In practice, that means docs which give our users a better experience, catching gaps that would’ve lingered unnoticed otherwise.

**Build your own**

If you want to build something similar, start with an area where you notice content going stale because the thing it describes keeps moving. Give the loop access to both, the places where those changes appear and the material that needs to be updated, then have it periodically compare the two.

*Open [this prompt](https://linear.app/agent%3Fskill=loop-documentation-gaps.html) in Linear Agent to adapt it to your own team, tools, and signals.*

* 00:00Intro
* 00:15Problem statement
* 00:45Loop overview
* 01:02Loop tour
* 01:53Loop output
