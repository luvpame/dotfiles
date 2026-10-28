---
title: "AI Credits"
source_url: "https://linear.app/docs/ai-credits"
fetched_at: "2026-10-27T08:17:41.028425+00:00"
---



* Getting started
* Intake
* Projects and initiatives
* Issues and cycles
* Coding and review
* Agents and automation
* Insights and outcomes
* Working in Linear
* Integrations
* Administration

  + [![Workspaces](https://webassets.linear.app/images/ornj730p/production/5fbe479163f634cafc305ef4b07cbb6eac5bfa08-16x16.svg?q=95&auto=format&dpr=2)Workspaces](workspaces.html)
  + [![Teams](https://webassets.linear.app/images/ornj730p/production/41309383510a94f0087966d54e90ebc64a177f39-16x16.svg?q=95&auto=format&dpr=2)Teams](teams.html)
  + [![Team pages](https://webassets.linear.app/images/ornj730p/production/2012b5ca81b9d3cde72bae4c743a14d57b500d68-16x16.svg?q=95&auto=format&dpr=2)Team pages](default-views.html)
  + [![Private teams](https://webassets.linear.app/images/ornj730p/production/f95a05604aad31f7e01466ae03897777d1d2a218-16x16.svg?q=95&auto=format&dpr=2)Private teams](private-teams.html)
  + [![Sub-teams](https://webassets.linear.app/images/ornj730p/production/b2e524167129b68e4be926d18dff3d57b050e25c-16x16.svg?q=95&auto=format&dpr=2)Sub-teams](sub-teams.html)
  + [![Login methods](https://webassets.linear.app/images/ornj730p/production/eb030e6addf44b757dcd01b7130fb3020c1e9074-16x16.svg?q=95&auto=format&dpr=2)Login methods](login-methods.html)
  + [![Invite members](https://webassets.linear.app/images/ornj730p/production/4a6d4dcd329012bcb08d42c0e6138e1192c5a4d8-16x16.svg?q=95&auto=format&dpr=2)Invite members](adding-and-managing-members.html)
  + [![Members and roles](https://webassets.linear.app/images/ornj730p/production/ace5af526ef589f638bb9ece43d455b97c2b9e62-16x16.svg?q=95&auto=format&dpr=2)Members and roles](members-roles.html)
  + [![SAML](https://webassets.linear.app/images/ornj730p/production/95a933639d33ab31c5ac1c56744755344279f769-16x16.svg?q=95&auto=format&dpr=2)SAML](saml-and-access-control.html)
  + [![SCIM](https://webassets.linear.app/images/ornj730p/production/d762acc0a6dbea9d803c9e5611c0dbfc86df6746-16x16.svg?q=95&auto=format&dpr=2)SCIM](scim.html)
  + [![API and Webhooks](https://webassets.linear.app/images/ornj730p/production/ea822173f6bf2d9383d19105d9ecaa6693492aca-16x16.svg?q=95&auto=format&dpr=2)API and Webhooks](api-and-webhooks.html)
  + [![Third-Party App Approvals](https://webassets.linear.app/images/ornj730p/production/b61fa1aff4d024cf6dcf0134c2c45b8d76cf0b27-16x16.svg?q=95&auto=format&dpr=2)Third-Party App Approvals](third-party-application-approvals.html)
  + [![Security](https://webassets.linear.app/images/ornj730p/production/95a933639d33ab31c5ac1c56744755344279f769-16x16.svg?q=95&auto=format&dpr=2)Security](security.html)
  + [![Audit log](https://webassets.linear.app/images/ornj730p/production/9eccb204815aeb102e7cd5fc3626a61c21f8b1b9-16x16.svg?q=95&auto=format&dpr=2)Audit log](audit-log.html)
  + [![Billing and plans](https://webassets.linear.app/images/ornj730p/production/33fa80412b10a65fd8e38cf5771b09a15670593f-16x16.svg?q=95&auto=format&dpr=2)Billing and plans](billing-and-plans.html)
  + [![AI Credits](https://webassets.linear.app/images/ornj730p/production/40f99550f03177fadfe53645dfad2e238091d67e-16x16.svg?q=95&auto=format&dpr=2)AI Credits](ai-credits.html)
  + [![Usage & limits](https://webassets.linear.app/images/ornj730p/production/c4d004a3952b8f8e45ede10f8756e0eeb5153d10-16x16.svg?q=95&auto=format&dpr=2)Usage & limits](usage-and-limits.html)
  + [![Exporting Data](https://webassets.linear.app/images/ornj730p/production/a62608da795d3e55a196c009713363ff08ef20e6-16x16.svg?q=95&auto=format&dpr=2)Exporting Data](exporting-data.html)
* Importers

# AI Credits

This page covers how AI credits work. For plan and seat-based billing, see [Billing and plans](https://linear.app/docs/billing-and-plans.html).

## How AI credits work[⁠](https://linear.app/docs/ai-credits.html#how-ai-credits-work)

Linear’s [coding sessions](https://linear.app/docs/coding-sessions.html) and [Loops](https://linear.app/docs/loops.html)features are billed based on actual usage, not a fixed per-seat fee. Charges are deducted from a prepaid, workspace-level balance.

* Your balance is shown in US dollars
* The balance is pooled across the workspace and shared across AI features that use it
* You add funds to your balance before they are spent by topping up your credit balance

Using AI credits is **opt-in**. If your workspace never adds funds, you will not have access to these additional features, and you will never be charged for them.

## How AI credits are used[⁠](https://linear.app/docs/ai-credits.html#how-ai-credits-are-used)

| Feature | Available on | How it's billed |
| --- | --- | --- |
| Coding sessions | Free, Basic, Business, and Enterprise (AI credits required; legacy plans excluded) | Per session. Cost includes model tokens at provider-published rates, with no markup, and sandbox runtime at $0.25 per 20-minute block. |
| Loops | Basic, Business and Enterprise | Per loop run. Typical runs without a coding session cost $0.07–$0.20. Costs vary based on the work the loop performs; runs that start a coding session also incur the applicable coding-session costs. |

AI credits are currently used by:

* **Coding sessions**, when Linear Agent writes code and creates pull requests
* **Agent loops**, when a loop runs agent work in the background

Other Linear AI features are included in your plan and do not draw from your AI credits balance.

You can review AI credit usage in [**Settings → Usage & limits**](https://linear.app/settings/usage.html). For coding sessions, hover over a session’s cost to see token cost by model, compute cost, and total cost.

## Choosing a coding session model[⁠](https://linear.app/docs/ai-credits.html#choosing-a-coding-session-model)

By default, coding sessions use the latest zero-data-retention models. You have the option to select from a number of available models here, which affects the quality and cost of code changes - more on this in our [coding sessions docs](https://linear.app/docs/coding-sessions.html).

## Adding credits to your balance[⁠](https://linear.app/docs/ai-credits.html#adding-credits-to-your-balance)

Adding credits is restricted to Workspace admins (Owners on Enterprise workspaces). You can add credits from [*Settings → Workspace → Billing → AI Usage and credits.*](https://linear.app/settings/billing/usage.html)

### Ad-hoc credits[⁠](https://linear.app/docs/ai-credits.html#ad-hoc-credits)

To add credits on an ad-hoc basis, click the *Add credits* button at the top of the page. Select the amount or select *Other* to input an amount of your choosing - minimum top up is $10 USD.

### Automatic Reload[⁠](https://linear.app/docs/ai-credits.html#automatic-reload)

To add credits on an automatic basis, you can set up *Automatic Reload*. You can choose a balance that you don’t want to go below, and then set the amount that you want automatically added when you reach the threshold - minimum auto top-up is $50 USD.

![Automatic reload](https://webassets.linear.app/images/ornj730p/production/f97dc8e9dfe7ac2943bd1853e1718cbda4d6517e-1534x274.png?w=1440&q=95&auto=format&dpr=2)

![Manage automatic top-ups](https://webassets.linear.app/images/ornj730p/production/68d3d8c3d68d465d83dd54f73c4d456aaf64a962-1118x980.png?w=1440&q=95&auto=format&dpr=2)

Top-ups are processed by Stripe and produce a separate invoice from your regular Linear subscription invoice.

### Payment methods[⁠](https://linear.app/docs/ai-credits.html#payment-methods)

* Credit cards are the only accepted payment method for buying credits in billing settings
* AI usage can use a different card than your core Linear subscription if desired

### Currency and tax[⁠](https://linear.app/docs/ai-credits.html#currency-and-tax)

Top-ups are processed in USD and sales tax is applied where applicable based on your billing address.

## Expiration[⁠](https://linear.app/docs/ai-credits.html#expiration)

* Funds you add **expire 12 months after the purchase date**
* Promotional balances will have their own expiration dates, visible in the Usage and credits dashboard
* Unused balance rolls over across subscription billing cycles. It is independent of your Linear subscription period
* Expired balances cannot be refunded, transferred between workspaces, or restored

## Order of use[⁠](https://linear.app/docs/ai-credits.html#order-of-use)

When your workspace has multiple types of credits at the same time (for example, promotional credits alongside a top-up you added), they are consumed in this order:

1. Promotional credits (one-time grants when turning on a feature)
2. Credits issued by Linear support
3. Credits you added yourself

Within each group, credits closest to expiry are consumed first. A single task may draw from more than one balance.

## Running out of credits[⁠](https://linear.app/docs/ai-credits.html#running-out-of-credits)

If your workspace runs out of credits, features that require a balance will not be able to begin new work. You’ll receive low-balance and expiration alerts in advance.

Balances are not updated in exact real time, so your workspace may briefly go slightly negative (e.g. multiple tasks running at the same time), typically by only a few dollars. Your next top-up will first cover any outstanding amount, then add the remaining funds to your balance. For example, if your workspace credit balance is -$1 and you add $50, your new balance will be $49.

## View and manage your usage[⁠](https://linear.app/docs/ai-credits.html#view-and-manage-your-usage)

Review AI credit usage and manage spend limits in **Settings → Usage & limits**. See [**Usage & limits**](https://linear.app/docs/usage-and-limits.html) for details on exploring usage, exporting reports, and configuring limits.

## Adjustments[⁠](https://linear.app/docs/ai-credits.html#adjustments)

* If a task fails because of a Linear platform issue, please [contact support](mailto:support@linear.app) so we can investigate and adjust where appropriate
* Failed runs, retries, or partial completions are billable for the resources used
* Funds you’ve added are non-refundable and non-transferable

## FAQ[⁠](https://linear.app/docs/ai-credits.html#faq)

Which workspaces get promotional launch credits?

All existing Business and Enterprise workspaces, and workspaces who upgraded to a Basic, Business or Enterprise plan within 30 days of this launch received launch credits.

Can an admin or owner control who in the workspace has access to use credits?

Not at this time. If AI credits are enabled for the workspace, anyone who has access to features that use AI credits can spend from the shared balance, including coding sessions and agent loops.

Can an owner or admin restrict guests from using AI credits and coding sessions?

If you go to *Security, Integrations & applications* there is a toggle to **Prevent guests from interacting with agents in the workspace.** That prevents guests from using coding sessions and other agent features that consume AI credits.

Who can create or manage agent loops?

Workspace admins can control who can create, update, and delete workspace loops from [Settings → Security → Workspace management → Manage loops](https://linear.app/settings/security.html#workspace-management). Team-level loop permissions may also depend on permissions for the team where the loop is created.

What happens my workspace AI credits if my workspace is deleted?

If a workspace is deleted, any remaining balance expires and cannot be recovered. Linear will warn you clearly before you confirm workspace deletion, and there is a 48 hour window to undo the request.

[Previous

Billing and plans](https://linear.app/docs/billing-and-plans.html)[Next

Usage & limits](https://linear.app/docs/usage-and-limits.html)

* [How AI credits work](https://linear.app/docs/ai-credits.html#how-ai-credits-work)
* [How AI credits are used](https://linear.app/docs/ai-credits.html#how-ai-credits-are-used)
* [Choosing a coding session model](https://linear.app/docs/ai-credits.html#choosing-a-coding-session-model)
* [Adding credits to your balance](https://linear.app/docs/ai-credits.html#adding-credits-to-your-balance)
* [Ad-hoc credits](https://linear.app/docs/ai-credits.html#ad-hoc-credits)
* [Automatic Reload](https://linear.app/docs/ai-credits.html#automatic-reload)
* [Payment methods](https://linear.app/docs/ai-credits.html#payment-methods)
* [Currency and tax](https://linear.app/docs/ai-credits.html#currency-and-tax)
* [Expiration](https://linear.app/docs/ai-credits.html#expiration)
* [Order of use](https://linear.app/docs/ai-credits.html#order-of-use)
* [Running out of credits](https://linear.app/docs/ai-credits.html#running-out-of-credits)
* [View and manage your usage](https://linear.app/docs/ai-credits.html#view-and-manage-your-usage)
* [Adjustments](https://linear.app/docs/ai-credits.html#adjustments)
* [FAQ](https://linear.app/docs/ai-credits.html#faq)
