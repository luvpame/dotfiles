---
title: "How Clay manages bugs using Linear"
source_url: "https://linear.app/customers/clay"
fetched_at: "2026-10-27T08:17:41.028425+00:00"
---



1. [Customers](https://linear.app/customers.html)
2. Clay

# How Clay manages bugs using Linear

![](https://webassets.linear.app/images/ornj730p/production/1eed795c6219c57de2ac73e4287221d91eb740e0-1952x960.png?w=1024&q=95&auto=format&dpr=2)

Clay is a go-to-market platform that helps teams enrich leads, identify intent signals, and automate outbound workflows. As they scaled from 50 to 200 employees, they built a bug management system using Linear that dramatically reduced triage time.

Clay[clay.com ↗](https://www.clay.com)

FoundedNew York, 2017

SwitchedNovember 2019

Every bug report looks different, but they all ask the same question, who can fix this? At a lot of companies, the answer lives in people’s heads. Sarah knows the payment system, Marcus understands the API, and when weird edge cases happen, you just…ask around.

This is bug triage via tacit knowledge. It’s both a superpower and a liability. It works beautifully when your entire team fits in one room. But as companies scale, shared context shrinks. You can spend as long figuring out who to assign a bug to as the bug takes to fix.

Clay hit this wall hard. As they scaled from 50 to 200 employees their bug management process, which relied on people *just knowing* where to send things, began to crack. Today, Clay has built a bug management system that really scales. Here’s how they do it.

### Centralize intake[⁠](https://linear.app/customers/clay.html#centralize-intake)

Clay funnels every bug report, regardless of where it originates, through a Slack channel called #all-bugs.

Clay employees can submit bugs directly to the channel using a standardized form. This is the default action in the channel and the form ensures that people submit structured reports instead of vague messages.

![Bug intake forms across Slack, Clay and Intercom](https://webassets.linear.app/images/ornj730p/production/f6429ac0d3e3948df8f88aefeb98a05321cf90f4-1952x1216.png?q=95&auto=format&dpr=2)

![Bug intake forms across Slack, Clay and Intercom](https://webassets.linear.app/images/ornj730p/production/68483e3f39d1ac7d9d303beb8ffbbc52c3770597-1176x720.png?q=95&auto=format&dpr=2)

Bug intake forms across Slack, Clay and Intercom

Clay embeds the same form in its app, hidden behind a set of keyboard shortcuts, so that team members can report bugs without leaving the product. This is particularly useful for customer-facing teams giving live demos.

Through Linear’s [Intercom integration](https://linear.app/integrations/intercom.html), the same workflow lives in their support tool, giving the Clay CX team a straightforward way to report customer-flagged bugs.

No matter where a bug originates, it ends up as a message in #all-bugs.

### Create a single triage queue in Linear[⁠](https://linear.app/customers/clay.html#create-a-single-triage-queue-in-linear)

After collecting bugs in Slack, Clay routes them into Linear via [Linear Asks](https://linear.app/features/asks.html). This enables anyone at Clay to create an issue in Linear, even if they don’t have a seat.

![Linear Asks being used to create a bug in Linear](https://webassets.linear.app/images/ornj730p/production/f30fa017b37001613cc4098b75c0d863a8429d15-1952x1216.png?q=95&auto=format&dpr=2)

![Linear Asks being used to create a bug in Linear](https://webassets.linear.app/images/ornj730p/production/4a8c7be7436c926d91eb4def13e9e5a9aa5b65a6-1176x720.png?q=95&auto=format&dpr=2)

Asks turns requests like bug reports into actionable issues in Linear

With a few clicks, that bug report goes from Slack to Linear, and lands in a single team called “Bugs Team.”

![Kanban board in Linear showing bugs](https://webassets.linear.app/images/ornj730p/production/163c4dfff23b867c53b7e4674ab1f6ecb7c43404-1952x720.png?q=95&auto=format&dpr=2)

![Kanban board in Linear showing bugs](https://webassets.linear.app/images/ornj730p/production/07cce29c51df8c71ff69f6e48ddace3b74bf5b52-1176x560.png?q=95&auto=format&dpr=2)

A kanban board in Linear of all bugs

Tomas Fiure, a support engineer at Clay, manages this team in Linear. He catches duplicates, assigns priorities, adds labels, and routes bugs to the right engineering teams. This ensures that each bug report is sized accordingly and assigned to the team best positioned to fix it.

### Route bugs systematically[⁠](https://linear.app/customers/clay.html#route-bugs-systematically)

Tomas has owned this process for a while, which allows him to quickly sort bugs to the right teams. He’s developed the context and pattern recognition to know webhook errors go to the API team, UI issues go to frontend, and so on.

But Clay wanted a bug process that didn’t depend on any one person’s institutional knowledge. To make their process more robust to staffing changes, they increasingly rely on Linear’s [Triage Intelligence](https://linear.app/docs/product-intelligence.html). This feature learns from triage patterns and starts to suggest teams, priorities, and duplicates automatically.

![Linear's Triage Intelligence showing suggested labels](https://webassets.linear.app/images/ornj730p/production/17eba6d6a710bbae3535d2590c1cb4b2285563cb-1952x800.png?q=95&auto=format&dpr=2)

![Linear's Triage Intelligence showing suggested labels](https://webassets.linear.app/images/ornj730p/production/45fb33c5321855f2a96cc3d005747c6db8023d96-1176x504.png?q=95&auto=format&dpr=2)

Triage Intelligence catches duplicates and suggests labels and assignees for bugs in triage

Clay has already accepted nearly 300 suggestions from Triage Intelligence, dramatically reducing triage time. Tomas has also set up [auto-triage](https://linear.app/changelog/2025-09-19-auto-apply-triage-suggestions.html) rules for SLA automation based on priority. This gives the team confidence that urgent bugs with SLA requirements will be addressed promptly, because the system will auto-assign them to the right team.

> Linear’s AI suggestions make the triage process smoother while allowing the flexibility and feedback to customize the ramp up. It truly gets much better as it gets more use and is invaluable for scaling the bug triage system.

Tomas Fiure — Support Engineer

### Establish ownership[⁠](https://linear.app/customers/clay.html#establish-ownership)

Once Clay had a process in place for collecting and routing bugs, they needed a way to ensure the bugs actually got addressed.

To do that, each engineering team uses a weekly “goalie” system borrowed from [Linear’s own approach](https://linear.app/blog/how-we-think-about-customer-experience-at-linear.html). One person per team rotates into the role and is responsible for all bugs triaged their way during the week.

![UI of Triage Responsibility in Linear](https://webassets.linear.app/images/ornj730p/production/1c3e45f2e4352cd382d93c5097be9a0e5b89627e-1952x880.png?q=95&auto=format&dpr=2)

![UI of Triage Responsibility in Linear](https://webassets.linear.app/images/ornj730p/production/7f5abc4bb66ed2407702a06c76e37e743e091ebf-1176x720.png?q=95&auto=format&dpr=2)

Triage Responsibility notifies team members when a bug lands in triage

When Tomas routes a webhook issue to the API team, the goalie for that week owns it, rather than just “the API team.” The goalie receives an automatic notification that they’ve been assigned a bug and becomes accountable for either fixing it directly or reassigning it to someone better placed on the team.

### Close the loop with customers[⁠](https://linear.app/customers/clay.html#close-the-loop-with-customers)

Clay’s old bug management process didn’t link bug reports with customers. This meant customers never really knew if the bugs they’d reported had been fixed.

Now, enabled by Linear’s integrations, any comment or update made on a bug, whether on Slack, the Intercom thread, or in Linear, automatically syncs across all platforms. When a fix is merged, an alert appears in the original Intercom thread where the customer reported it. Support can see exactly what happened and how it was fixed, making it easy to draft a detailed update for the customer.

> Linear democratized all the context that used to live in people’s heads. Everyone stays informed regardless of which tool they're using. No more duplicate bug reports, no more wondering if someone else flagged an issue. We move faster, and customers get a better experience.

George Dilthey — Head of Support

### [⁠](https://linear.app/customers/clay.html#)

[![Sierra logo](https://webassets.linear.app/images/ornj730p/production/805551cdc94ee1d8627cb5e00fd73baec0904ce2-56x56.svg?q=95&auto=format&dpr=2)

Previous

Sierra](sierra.html)[![Watershed logo](https://webassets.linear.app/images/ornj730p/production/66314c542672167823e48ab60156459e5f1ca252-56x56.svg?q=95&auto=format&dpr=2)

Next

Watershed](watershed.html)
