---
title: "Simplifying support at scale: How Pleo uses Linear Asks - Linear"
source_url: "https://linear.app/blog/simplifying-support-at-scale-how-pleo-uses-linear-asks"
fetched_at: "2026-10-27T08:17:41.028425+00:00"
---



1. [Now](https://linear.app/now.html)
2. [From the community](https://linear.app/now/community.html)

# Simplifying support at scale: How Pleo uses Linear Asks

![Pleo logo next the the Linear Asks logo](https://webassets.linear.app/images/ornj730p/production/6cbb935afcd43d2b29cfb25f3338cb625d4c32ac-2056x944.png?q=95&auto=format&dpr=2)

![Pleo logo next the the Linear Asks logo](https://webassets.linear.app/images/ornj730p/production/ecaf19ad0ad1daa933d9e6653da1f1fd485daaee-2056x944.png?q=95&auto=format&dpr=2)

[Erin Frey](https://linear.app/now/author/erin-frey.html) and 2 others·November 11, 2024

*Pleo, founded in 2015 in Copenhagen, is a business spend solution that processes expenses, pays invoices and issues smart company cards, allowing employees and finance teams to focus on more strategic and meaningful work. Pleo has used Linear since 2021, when their engineering, product, and design teams adopted Linear to track issues and manage work across hundreds of projects.*

*Pleo now also uses Linear Asks, which turns workplace requests in Slack into actionable issues in Linear, to manage workplace requests across their 800 person company. Stefan Christensen, Head of Platform, and Zoárd Manó (Zeo) Csoltai, Senior TechOps Engineer, shared why they switched to Linear Asks, how they evaluated it, and what it takes to deliver high quality support to internal teams.*

## The switch to Linear Asks[⁠](https://linear.app/blog/simplifying-support-at-scale-how-pleo-uses-linear-asks.html#the-switch-to-linear-asks)

#### Why did you switch to Linear Asks from your previous internal request tool?[⁠](https://linear.app/blog/simplifying-support-at-scale-how-pleo-uses-linear-asks.html#why-did-you-switch-to-linear-asks-from-your-previous-internal-request-tool)

Zeo Csoltai, Senior TechOps Engineer, Pleo

Our existing tool HALP was shutting down and we were looking for another tool to manage internal requests. HALP had worked well for us when we started using it; we had around 300 employees at the time. Unfortunately, HALP was acquired by Atlassian. We could tell almost immediately that their product was slowing down–there were no new features coming and we heard silence from their team. Eventually, we got an email saying that HALP’s product would be sunset and our only option would be to move to Jira Service Management’s ITSM tool. We decided to explore other options.

Stefan Christensen, Head of Platform, Pleo

We were hoping to move to something similar and not have to use a bloated or more complicated tool. We started looking for another solution around the same time that Linear reached out to us about joining the beta for [Linear Asks](https://linear.app/features/asks.html), so it was a perfect match.
‎‎ ‎

#### What mattered to you in making this decision?[⁠](https://linear.app/blog/simplifying-support-at-scale-how-pleo-uses-linear-asks.html#what-mattered-to-you-in-making-this-decision)

Zeo Csoltai, Senior TechOps Engineer, Pleo

We wanted a tool that would be effortless for anyone at our company to use. If people dislike your internal support tool, they won’t use it. They’ll be slow to report issues and work around the tool, messaging their manager or pinging the internal support team individually. This adds more time to each request and more work for internal teams.

We definitely didn’t want a tool that required users to login separately. Everyone at the company has access to Slack and is comfortable using it, so it was crucial to have a tool that integrated seamlessly with it.

Stefan Christensen, Head of Platform, Pleo

We also needed a tool that was flexible enough to support different workflows. Our internal teams all work very differently from each other. Some teams get a few requests a day while others get hundreds per week. Teams vary in size and the requests can differ a lot, from getting someone at Pleo access to an internal system, to debugging a development platform error, to investigating a billing discrepancy. We wanted each internal team to choose how they worked: how they set up staffing rotations, how requests would be sent to them, and what information would be included in each request.

While it wasn’t a specific requirement, we also didn’t want to spend much more than we were paying for our existing tool. In the end, we’ve actually saved close to $30,000 a year since moving to Linear Asks, since Asks is part of our existing plan and not a paid add-on like Jira Service Management.

## A natural fit with Pleo’s workflow[⁠](https://linear.app/blog/simplifying-support-at-scale-how-pleo-uses-linear-asks.html#a-natural-fit-with-pleo's-workflow)

Zeo Csoltai, Senior TechOps Engineer, Pleo

Primarily, we liked Asks because it is so simple to use. My teammate can open Slack, post a question, and it instantly gets routed to the person and team who can help. They don’t have to think about filling out complicated forms, tagging specific people, or following a specific process. Getting help is as easy as posting a question in Slack.

It’s also a huge benefit that through Asks, these requests are linked bidirectionally with Linear. Requests are sent directly to a team’s Triage inbox, where they can be reviewed and processed just like any other Linear issue. Comments and status updates post across to the linked Slack message, too, so you are kept up to date no matter which tool you are in.

Many teams at Pleo were already using Linear for product and engineering work, and even creating issues from requests posted in Slack manually. Adding internal support requests to their Triage queue didn’t change the day-to-day workflow for most teams.

![Showing a Slack thread where dimitris posted a question and his coworker Max turned the request into an Ask. It shows the green checkbox on the original posted question, indicating that the request was completed, and back and forth between max and dimitris.](https://webassets.linear.app/images/ornj730p/production/6f2d77e7bc1268ad4e438c2dfd3ad16ed9c0fa5d-1176x1048.png?q=95&auto=format&dpr=2)

## Building a best-in-class Technical Operations team[⁠](https://linear.app/blog/simplifying-support-at-scale-how-pleo-uses-linear-asks.html#building-a-best-in-class-technical-operations-team)

#### You have a strong opinion on how you run your Tech Operations team. Can you share more?[⁠](https://linear.app/blog/simplifying-support-at-scale-how-pleo-uses-linear-asks.html#you-have-a-strong-opinion-on-how-you-run-your-tech-operations-team.-can-you-share-more)

Zeo Csoltai, Senior TechOps Engineer, Pleo

Our vision for Tech Operations (TechOps) is rooted in modern DevOps principles. We want to be proactive, to anticipate problems and prevent them before teams even realize that an issue is brewing. If we can resolve issues earlier when they are small, we can prevent large bottlenecks that affect delivery or have other serious ramifications.

We’ve tried to avoid running TechOps like a traditional IT operation, where work is primarily reactive, going ticket by ticket, and solving problems only as they are reported.

We also use a more casual style in our interactions, getting to know our teammates as people and building relationships with them beyond just fixing the issue at hand. Most of us have had dreadful experiences with IT, where you fill out a billion forms on a website and have no clue if you’ll hear back in five days or five years. That’s an experience we don’t want our teammates to have when they need our help.
‎

#### What does this vision look like in practice?[⁠](https://linear.app/blog/simplifying-support-at-scale-how-pleo-uses-linear-asks.html#what-does-this-vision-look-like-in-practice)

Zeo Csoltai, Senior TechOps Engineer, Pleo

A lot of my job involves discovery: talking to my stakeholders on a regular basis, checking in and figuring out where we can make small improvements to their existing workflows without breaking things in the process.

Using Slack as the interface for ticketing helps us reinforce this human-focused approach to internal support and helps us be more approachable, so that when a problem or question does come up, people feel comfortable reaching out to us. It’s so easy to send a Slack message, it doesn’t feel like a chore. And it doesn’t feel as onerous as a form.
‎

#### How do you know if you’re succeeding at building that vision?[⁠](https://linear.app/blog/simplifying-support-at-scale-how-pleo-uses-linear-asks.html#how-do-you-know-if-you're-succeeding-at-building-that-vision)

Zeo Csoltai, Senior TechOps Engineer, Pleo

There are a few things we look at. First, the whole company is my stakeholder and our ability to help them is directly tied to how comfortable they feel reaching out to us. We don’t track a metric for this, but we pay attention to how things feel and actively work to curate this sentiment in every interaction.

We also look at how many asks are coming into Triage. Are we seeing more or fewer requests than usual? The more issues we can discover proactively, the fewer asks we should see overtime. Honestly, I think if people don’t really know what I do or that I exist, that means they’re not having problems and I’m doing my job well.

![A view of a triage inbox for the tech operations team, showing various requests submitted through Linear Asks](https://webassets.linear.app/images/ornj730p/production/1992c37c2e53bc71c5d856e3876db770b2f37874-1176x936.png?q=95&auto=format&dpr=2)

#### How have you structured Asks in your TechOps team?[⁠](https://linear.app/blog/simplifying-support-at-scale-how-pleo-uses-linear-asks.html#how-have-you-structured-asks-in-your-techops-team)

Zeo Csoltai, Senior TechOps Engineer, Pleo

We run a weekly rotation, where someone from our team is in charge of fielding requests that come into Triage. We’re a team of four and everyone does frontline support, even our team lead. It’s really important to us that everyone is close to the problems our teammates are having. We don’t want anyone to forget what it’s like to field questions or get boxed into a specific niche, where they become known as the person that only fixes certain types of issues.

It is easy to support a regular rotation in Linear. We just created a schedule in incident.io and linked it to our Linear Triage inbox. From incident.io or Linear, you can see who is on frontline and who is scheduled next. We also always have a backup person on call in case we get an influx of requests and the main person on frontline needs help.

We also built our own helpbot using Linear’s GraphQL API, so that whenever someone sends us a request through Asks, the helpbot comments on the Linear issue with contextual information that helps us process the request, e.g. the user’s location, device, device state, etc. This helps us process requests much faster and with less back and forth.

![Issue activity showing an automated comment created by the TechOps Helper which has key details about the request submitted including the full name, email, and location of the employee making the request, the team and domain they are part of, their job title, and links to Intune and Kandji information including their last OS version and last checkin](https://webassets.linear.app/images/ornj730p/production/c44b1c34c75d994cf361ba7faca42d5c02c58ed7-1176x1052.png?q=95&auto=format&dpr=2)

## Scaling internal support workflows[⁠](https://linear.app/blog/simplifying-support-at-scale-how-pleo-uses-linear-asks.html#scaling-internal-support-workflows)

#### How did you manage the transition of moving 800 employees to send and manage requests with Linear Asks?[⁠](https://linear.app/blog/simplifying-support-at-scale-how-pleo-uses-linear-asks.html#how-did-you-manage-the-transition-of-moving-800-employees-to-send-and-manage-requests-with-linear-asks)

Stefan Christensen, Head of Platform, Pleo

For people already using Linear there was very little change to their daily workflow. We moved our team (TechOps) as well as Developer Experience and Site Reliability Engineering to Asks first. Quickly, other teams followed suit.

The magic of Asks for us is in how flexible it is in how teams can use it. Every single team that has requests coming into them internally uses it but can configure it slightly differently. Once we onboard a team to use Asks, they go ahead and set up the templates and automations that their team wants to use. The Asks configuration lives in a single settings page, so they can see how other teams use it and just copy the settings.

For example, some teams configure a #help-team channel in Slack with auto-creation, so that any message posted in the channel creates an Ask automatically. Other teams prefer to review questions in a Slack channel first and create asks manually, only when significant follow up is required. You can also enable it so that reacting with a ticket emoji (🎫) turns a Slack message into an ask.

Zeo Csoltai, Senior TechOps Engineer, Pleo

Across the company, we didn’t hear about many issues either, since everyone is familiar with Slack and people picked up on how to make requests without much hand-holding. When there were questions that I couldn’t answer, the Linear team would respond quickly, often within a few hours.

From a change management perspective, the transition was extremely smooth and dare I say enjoyable.The actual switch was simple: you just need to configure a few things in settings and then type */invite @asks* into a Slack channel.
‎

#### How do you see Asks helping you as you scale your teams?[⁠](https://linear.app/blog/simplifying-support-at-scale-how-pleo-uses-linear-asks.html#how-do-you-see-asks-helping-you-as-you-scale-your-teams)

Zeo Csoltai, Senior TechOps Engineer, Pleo

It’s so helpful that we can keep everything in Linear. Every ask is recorded in Linear with a backlink to the Slack conversation and synced comment threads. We can more easily keep track of our work in Linear than in Slack, set reminders, and snooze issues to follow up on them in the future.

We now also have a history of issues in Linear that we can look at and use to improve how we work. We can track how often requests are coming in and how long they take to resolve, so we have concrete data to justify investing in better solutions for these types of issues. We can easily link issues together and just get a better sense of trends in requests. This will be even more important as we continue to grow and support more people.

*Pleo’s experience centralizing internal requests transformed their organization’s workflows while keeping things human. Their TechOps team found that simple tools often work best: a single place to track work, seamless Slack integration, and the flexibility to let each team work their own way.*  [*Learn more*](https://linear.app/features/asks.html) *and sign up for a free trial on the Business plan to try Asks.*

[Erin Frey](https://linear.app/now/author/erin-frey.html) and 2 others·November 11, 2024

Copy link
