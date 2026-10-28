---
title: "Project graph – Linear Docs"
source_url: "https://linear.app/docs/project-graph"
fetched_at: "2026-10-27T08:17:41.028425+00:00"
---



* Getting started
* Intake
* Projects and initiatives
* Issues and cycles
* Coding and review
* Agents and automation
* Insights and outcomes

  + [![Dashboards](https://webassets.linear.app/images/ornj730p/production/327d644f5534eacc254da0d836cb694e19503028-16x16.svg?q=95&auto=format&dpr=2)Dashboards](dashboards.html)
  + [![Insights](https://webassets.linear.app/images/ornj730p/production/a6330865aa50d916f9dfdf9a057a8b012bb10b49-16x16.svg?q=95&auto=format&dpr=2)Insights](insights.html)
  + [![Project graph](https://webassets.linear.app/images/ornj730p/production/327d644f5534eacc254da0d836cb694e19503028-16x16.svg?q=95&auto=format&dpr=2)Project graph](project-graph.html)
  + [![Cycle graph](https://webassets.linear.app/images/ornj730p/production/2807ce6a3505890b0a0920dca6d3706d17807913-16x16.svg?q=95&auto=format&dpr=2)Cycle graph](cycle-graph.html)
* Working in Linear
* Integrations
* Administration
* Importers

# Project graph

The graph shows you the progress you’re making toward completing your project and estimates when you’ll complete it.

![Project Graph visual](https://webassets.linear.app/images/ornj730p/production/dec684e2f9d0666eac860146ac9c6e82d1e94c47-409x321.png?w=1440&q=95&auto=format&dpr=2)

## Overview[⁠](https://linear.app/docs/project-graph.html#overview)

Project graphs autogenerate once the status of a project has been moved to a Started status and we’ve collected enough project issue data for them to be created. Project graph statistics update hourly with the latest issue activity, and the time granularity of graph points is every 7 days. Predictions are calculated based on weekly velocity data.

## Where to find it[⁠](https://linear.app/docs/project-graph.html#where-to-find-it)

From the project view, open the project sidebar `Cmd/Ctrl` `I` to view the graph. If it’s not there, that means that we have not generated it yet.

![](https://webassets.linear.app/images/ornj730p/production/c377a88c314fd6d0ceacf255f927c3220f1d9a07-16x16.svg?q=95&auto=format&dpr=2)

**ProTip**: It can be helpful to set a target date to deter scope creep and create accountability for the project to ship in a reasonable amount of time.

## How to read it[⁠](https://linear.app/docs/project-graph.html#how-to-read-it)

A gray line shows you the project scope and how it has changed over time, giving you an easy way to see (and mitigate) scope creep.

We have separate lines for *Started* and *Completed* issues. This lets you see exactly what is being worked on and what is done. Blue bars also indicate completed issues over time for ease of interpretation when *Started* and *Completed* lines overlap.

You can see how a project’s issues break down by assignee and label, as well as what percentage of issues in those categories have been completed. You can hover over any assignee or label and click “filter” to show related issues.

You can also hover over the graph to see the exact values of scoped, completed and started issues over time.

If you have a target date set, it’ll show up as a red vertical line.

### Live predictions[⁠](https://linear.app/docs/project-graph.html#live-predictions)

We show an estimated completion date once the project has enough history to calculate a weekly velocity. Moving issues into a Started status contributes to that prediction. You’ll see the purple line for completed issues continues on with a dotted line to the predicted completion date. The graph will always start at 0.

The projected completion date(s) are calculated by how long it will take to complete the remaining issues based on the current weekly project velocity.

Project velocity is calculated based on weekly historical data: how many completed issue points per week. More recent weeks are weighted more heavily, as they indicate a more current rate of progress. We need at least one week of data to show prediction.

Remaining issue points are calculated by summing the points of incomplete issues with a 1/4 modifier for any in-progress issues. After calculating a predicted completion date, we offer an optimistic and pessimistic completion date that includes a buffer of about ±40%. When available, these predictions are displayed as dotted lines starting from the Completed line at the current date.

## FAQ[⁠](https://linear.app/docs/project-graph.html#faq)

Why did my progress go down?

This can happen when project scope is reduced, in order to maintain a representative relationship between the Scope and Progress lines. Examples include when someone deletes or removes issues from a project, cancels issues from a project, or reduces issue scope.

When a team doesn't use estimates, how is the project graph constructed?

If estimates are off in a team, all issues are treated as 1 estimate point for the purposes of building the project graph.

[Previous

Insights](https://linear.app/docs/insights.html)[Next

Cycle graph](https://linear.app/docs/cycle-graph.html)

* [Overview](https://linear.app/docs/project-graph.html#overview)
* [Where to find it](https://linear.app/docs/project-graph.html#where-to-find-it)
* [How to read it](https://linear.app/docs/project-graph.html#how-to-read-it)
* [Live predictions](https://linear.app/docs/project-graph.html#live-predictions)
* [FAQ](https://linear.app/docs/project-graph.html#faq)
