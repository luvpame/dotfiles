---
title: "Lane Integration – Linear"
source_url: "https://linear.app/integrations/lane"
fetched_at: "2026-10-27T08:17:41.028425+00:00"
---



1. [Integrations](https://linear.app/integrations.html)
2. Lane

# Create Linear issues from prioritized customer signals

![Every request ranked by demand and revenue, before it reaches Linear](https://webassets.linear.app/images/ornj730p/production/45496fcabdd06b3d5c067ceae215ada11f34fce4-1500x960.png?q=95&auto=format&dpr=2)

Every request ranked by demand and revenue, before it reaches Linear

![Every request ranked by demand and revenue, before it reaches Linear](https://webassets.linear.app/images/ornj730p/production/45496fcabdd06b3d5c067ceae215ada11f34fce4-1500x960.png?q=95&auto=format&dpr=2)

Every request ranked by demand and revenue, before it reaches Linear

![Send to Linear button visible in lane](https://webassets.linear.app/images/ornj730p/production/5ca2b2f15a461a8b4950e0c366215f301826d0c8-1500x960.png?q=95&auto=format&dpr=2)

Send prioritized customer signals straight to Linear

![Lane notifying customers when linear issue completes](https://webassets.linear.app/images/ornj730p/production/71c3dbc57478a4dc9effd9268f1b52135103dc25-1500x960.png?q=95&auto=format&dpr=2)

The loop closes itself when the work ships

## Overview[⁠](https://linear.app/integrations/lane.html#overview)

Lane turns scattered customer feedback into prioritized product plans backed by real revenue and real customer quotes. The Linear integration pushes those plans into Linear as issues with the underlying customer requests attached, and syncs issue status back to Lane so the customers who asked get told when the work ships.

## How it works[⁠](https://linear.app/integrations/lane.html#how-it-works)

Once your Linear workspace is connected, any plan in Lane can be sent to a Linear team as an issue. Lane creates the issue with the plan’s title and body, keeps a link between the two records, and shows the Linear issue and its live status on the plan in Lane. You can also browse an existing Linear team’s issues from Lane and import them, so work already tracked in Linear can be linked to the feedback arriving against it.

Every plan in Lane carries the customer feedback that motivated it, and that evidence travels with the push. Lane upserts each account as a Linear customer using its domain, name, ARR and size, then adds that customer’s feedback to the issue as a customer request, including the original Slack thread where the conversation happened. The result is that your team sees who asked, how much revenue sits behind it and what the customer actually said, inside Linear’s own customer request views rather than in a separate tool.

Status flows in the other direction over Linear webhooks. You map Linear workflow states to Lane statuses, and when someone moves an issue on the Linear board the linked plan in Lane updates to match. Because Lane still holds every conversation behind that plan, a status change can also trigger follow-up messages back into the original Slack, Intercom or Zendesk threads, closing the loop with the customers who requested it without anyone chasing the list by hand.

## Configure[⁠](https://linear.app/integrations/lane.html#configure)

Connecting requires a Lane workspace on the Pro or Business plan and a Linear account with permission to create issues in the teams you want to push to. In Lane, go to Settings → Integrations → Linear and select Connect. You will be redirected to Linear to authorize the app; Lane requests read, write, issue create and comment create access, and the connection is made on behalf of the authorizing user, so issues and comments appear under your Linear identity.

After connecting, two optional settings sit on the same page. Turn on “Include insights as customer requests” to attach linked customer feedback to every issue Lane pushes, which requires the Business plan. Turn on status sync and add one rule per Linear workflow state you care about, mapping it to the Lane plan status it should set, so Linear stays the source of truth for delivery status. From then on, push from the Linear section of any plan by choosing a team, and import existing Linear issues from the same integration settings page.

Website
[laneapp.co](https://laneapp.co)

Category
[Customer Experience](https://linear.app/integrations/customer-experience.html)

Contact

[Contact Lane](mailto:support@laneapp.co)

[Open website](https://docs.laneapp.co/linear)

#### You might be interested in

[Browse all integrations](https://linear.app/integrations.html)

* [![Cycle icon](https://webassets.linear.app/images/ornj730p/production/099525504609eedd6a440462561b1246198ec4b4-320x320.svg?w=256&q=95&auto=format&dpr=2)

  Cycle

  By Cycle

  Turns product feedback into customer engagement](cycle.html)
* [![Olvy icon](https://webassets.linear.app/images/ornj730p/production/59b270320ecf6fbf70bf5ccff9a1482b9a954317-320x320.png?w=256&q=95&auto=format&dpr=2)

  Olvy

  By Olvy, Inc.

  Convert user feedback into issues and collaborate with complete context](olvy.html)
* [![Intercom icon](https://webassets.linear.app/images/ornj730p/production/7296805f298e7093fa4856f7f9f81430fcd6e897-640x640.png?w=256&q=95&auto=format&dpr=2)

  Intercom

  By Linear

  Keep a tight feedback loop with customers and streamline bug reports](intercom.html)

## Build your own integration

Create your own integration with Linear’s API and submit it to the directory.

[Start building](https://linear.app/docs/integration-directory.html#build-your-own)

## Build your own integration

Create your own integration with Linear’s API and submit it to the directory.
