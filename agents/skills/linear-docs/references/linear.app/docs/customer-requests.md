---
title: "Customer Requests – Linear Docs"
source_url: "https://linear.app/docs/customer-requests"
fetched_at: "2026-10-27T08:17:41.028425+00:00"
---



* Getting started
* Intake

  + [![Triage](https://webassets.linear.app/images/ornj730p/production/712fe7305132a7021337266b62cd829a642d87f0-16x16.svg?q=95&auto=format&dpr=2)Triage](triage.html)
  + [![Linear Asks](https://webassets.linear.app/images/ornj730p/production/f804eb9398d8f30985150f15604b8c225e477217-16x16.svg?q=95&auto=format&dpr=2)Linear Asks](linear-asks.html)
  + [![Asks with Slack](https://webassets.linear.app/images/ornj730p/production/3b3e7392cce7262c88707235ad4d3d868411d05b-16x16.svg?q=95&auto=format&dpr=2)Asks with Slack](linear-asks-slack.html)
  + [![Asks with Email](https://webassets.linear.app/images/ornj730p/production/c1b6cdc0449d107875a65baa2db023c8fcee7ae2-16x16.svg?q=95&auto=format&dpr=2)Asks with Email](linear-asks-email.html)
  + [![Asks Web Forms](https://webassets.linear.app/images/ornj730p/production/1f86e4f40e7338953c7f22fc78385aa48cd2fbfa-16x16.svg?q=95&auto=format&dpr=2)Asks Web Forms](linear-asks-web-forms.html)
  + [![Customer Requests](https://webassets.linear.app/images/ornj730p/production/daf62f3b5f67e7fd71f9ca25ee45dc565d4232cb-17x16.svg?q=95&auto=format&dpr=2)Customer Requests](customer-requests.html)
* Projects and initiatives
* Issues and cycles
* Coding and review
* Agents and automation
* Insights and outcomes
* Working in Linear
* Integrations
* Administration
* Importers

# Customer Requests

#

Bring the voice of the customer into product development.

![Hero graphic showing customer requests](https://webassets.linear.app/images/ornj730p/production/28c07cd4f7ea256eb31c294a1f11d736f73ccb7b-1280x627.png?w=1440&q=95&auto=format&dpr=2)

## Overview[⁠](https://linear.app/docs/customer-requests.html#overview)

Customer Requests bring your customer feedback into to Linear so you can align product work with your user’s needs:

* Understand customer use-cases directly on the issues and projects they’ve asked for, or analyze feedback in bulk with Linear Agent
* Customer facing teams can see all requests made by a customer, so it’s easy to see what a specific account has asked for
* View and filter issues or projects by customer name, count, status, tier revenue, and size to identify high impact customer work

Watch this video to learn more:

[![](https://webassets.linear.app/images/ornj730p/production/0b81a87f480e3c711e14699c1e101709f345ad59-2560x1440.png?q=95&auto=format&dpr=2)](https://webassets.linear.app/files/ornj730p/production/bd248c600c2eac6439c4c49aa3483626f3fedac0.mp4)

Elapsed00:00Remaining time unknown−--:--

0.25×0.5×0.75×1×1.25×1.5×1.75×2×

## Configure[⁠](https://linear.app/docs/customer-requests.html#configure)

Admins can enable Customer Requests in [Workspace Settings > Customer requests](https://linear.app/settings/customers.html). Once enabled, anyone in your workspace can view customer pages, create and update customers, and add customer requests to issues and projects in Linear or from a supported integration.

When an issue is created from integrations with [Intercom](https://linear.app/docs/intercom.html), [Zendesk](https://linear.app/docs/zendesk.html), [Front](https://linear.app/docs/front.html), or [Asks](https://linear.app/docs/linear-asks.html), it will automatically add a request pointing back to the source. Requests can also be added manually and are viewable in their associated issue and the customer’s page.

From settings, add further customizations. Choose a team to receive new issues created from a request by default (we recommend selecting a team [exclusively used to track feedback](https://linear.app/now/cx-in-linear.html)). You can also customize revenue units and tiers for different plans or products you offer. Revenue, Tier and Size fields will be automatically populated if you use the Intercom integration, or can be filled when creating customers manually.

## Customers[⁠](https://linear.app/docs/customer-requests.html#customers)

A Customer in Linear represents an organization using your product. Customers have a unique domain, name, logo, and attributes which can be viewed on their page.

### Customer pages[⁠](https://linear.app/docs/customer-requests.html#customer-pages)

![Example of a customer "Acme" with some customer requests](https://webassets.linear.app/images/ornj730p/production/9c886d7fc719521e16f5a1594ee024212ec743d9-2041x844.png?w=1440&q=95&auto=format&dpr=2)

![Example of a customer "Acme" with some customer requests](https://webassets.linear.app/images/ornj730p/production/3e55c899b5f0a9c6698126e2c2bccbb529c8cdf1-1998x910.png?w=1440&q=95&auto=format&dpr=2)

Customer pages show all issues and projects with a request associated with that customer. You can group and order this list of issues to see what issues have been marked as important or what issues are in progress. Click on individual issues to open and view their request on that issue in full detail.

For customers created through Intercom or manually, you’ll also see attributes like the customer’s revenue, status, tier, and size on the customer page. Individual customer pages can be favorited so that they’re easy to access from the sidebar.

### Open Customer pages[⁠](https://linear.app/docs/customer-requests.html#open-customer-pages)

* Use `O` then `Q`, then search for the customer’s name
* Open the full customer list with `G` then `Q`, then search to narrow down results
* Search for the customer in the `Cmd`/`Ctrl` + `K` menu

### Create Customers[⁠](https://linear.app/docs/customer-requests.html#create-customers)

From integrationsManually

In most cases, customers will be created automatically through an integration at the same time their first request is created. Linear will use the customer’s email domain to correctly map the request.

If your organization does not use these integrations, you can create Customers manually instead. To do so, open the command menu with `CMD + K`, then type `Create new customer`, then `Return`

## Customer requests[⁠](https://linear.app/docs/customer-requests.html#customer-requests)

![customer request being displayed under an issue in Linear](https://webassets.linear.app/images/ornj730p/production/c87284260cefeb20464003e9db77e9772d8ab29f-1305x370.png?w=1440&q=95&auto=format&dpr=2)

![customer request being displayed under an issue in Linear](https://webassets.linear.app/images/ornj730p/production/759674d3d27419889bbbfc34a9b27496c3054101-1316x371.png?w=1440&q=95&auto=format&dpr=2)

Customer requests link user feedback to specific issues in Linear.

### Add requests to issues or projects[⁠](https://linear.app/docs/customer-requests.html#add-requests-to-issues-or-projects)

A customer request is created automatically whenever you create or link to an issue or project from a supported integration. The request will appear both on the issue/project itself as well as on the associated customer’s page.

From integrationsManually

When made from an integration, the customer request will quote the original message from the user. This request can be edited in Linear to add images, videos, or extra context. Requests also include a link to the source (e.g. Intercom conversation), name of the user associated with the request, and timestamp.

Requests can be created manually in Linear from the Customers section on an issue, from the button on a customer page, or by using the keyboard shortcut `Ctrl` `R` (macOS)/ `Ctrl` `Alt` `R` (Windows). This is useful when a request comes in through a channel not necessarily associated with an integration, like if you have Linear open during an in-person meeting.

From the project page, you can add customer requests using CTRL+R, or the + Customer Request button. Once your first Customer Request is added to a project, a dedicated tab for Customer requests will appear next to the Overview tab.

Remember to configure a default team in [settings](https://linear.app/settings/customers.html) for customer requests, so that issues are created in that team when requests are created from individual customer pages.

### Integrations[⁠](https://linear.app/docs/customer-requests.html#integrations)

#### Built-in integrations[⁠](https://linear.app/docs/customer-requests.html#built-in-integrations)

The following integrations can create issues with customer requests:

IntercomZendesk & FrontSalesforceAsksSlackAPI

Requests are created when you create new issues or link to an existing issue or project from the Intercom integration. Customer attributes such as size and revenue can be synced with and managed from Intercom.

Requests are created when you create issues or link to an existing issue or project from Zendesk or Front conversations.

Requests are created when creating an issue from a case, or linking a case to an existing issue.

Whenever an Ask is created, a customer request will be associated with the issue and link the specific feedback and customer to the Ask. The customer association for Asks follows the email of the person who sent the first message in the thread, not the person who created the Ask.

If you have a Linear account and are creating an Ask in Slack, you can also select a customer manually. We do not expose your customer list to other users in your Slack workspace without Linear accounts, but if they create an Ask from the overflow menu on an existing message the customer association will be automatic.

To ensure proper customer attribution despite varying Slack privacy settings in shared channels, we recommend directly linking any shared Slack channels to the customer page (select the three-dot menu, then *link to Slack channel.)* This way, all Asks created in that channel will automatically be associated with the customer.

When creating an issue from the Slack integration, optionally select “Customer” to associate a customer request with the issue you are creating. This value will prefill if Linear is able to determine the domain of the user who sent the message.

To default a customer being selected in a Slack channel, open the customer page in Linear (`O then Q`) and from the … menu choose the “Link to Slack channel” option.

![Customer field highlighted when creating an issue from the Slack integration](https://webassets.linear.app/images/ornj730p/production/3ae6cb7e67184343ca3cb4fd11b73d949cd7e824-918x1133.png?w=1440&q=95&auto=format&dpr=2)

Requests and Customers can be created with [customerNeedCreate](https://studio.apollographql.com/public/Linear-API/variant/current/schema/reference/objects/Mutation?query=customer#customerNeedCreate) and [customerCreate](https://studio.apollographql.com/public/Linear-API/variant/current/schema/reference/objects/Mutation?query=customer#customerCreate) respectively in our GraphQL API.

However, using our API to import customer data from a warehouse—commonly done through an rETL pipeline—can be challenging, as GraphQL is not optimized for bulk data transfers, and Linear does not currently offer a REST API. We plan to offer better support for importing customers to Linear in the future.

#### Third-party integrations[⁠](https://linear.app/docs/customer-requests.html#third-party-integrations)

Third-party integrations such as [Plain](https://linear.app/integrations/plain.html) and [Pylon](https://linear.app/integrations/pylon.html) also support creating customer requests.

Developers can add customer request support to their own integrations using our [API](https://linear.app/developers/managing-customers.html).

### Mark as important[⁠](https://linear.app/docs/customer-requests.html#mark-as-important)

Requests can be flagged as important to specific customers. For instance, an issue or project may have requests from five different customers but be marked as important by only one of those customers. This binary indicator, shown as a triangle, lets customer-facing teams separate requests that represent a critical need from those expressing a nice-to-have feature.

### Synced Attributes[⁠](https://linear.app/docs/customer-requests.html#synced-attributes)

From *Settings > Customer Requests > Customer attributes data source,* you can choose a data source for Linear customer attributes such as Intercom, Zendesk or Front and create mappings between source tool attributes and attributes on Linear Customers. You can also choose *None* as a data source to allow more control via the API or directly in the interface. Once an external source is configured the company name and domain are automatically synced.

*Owner, Revenue, Size, Status* & *Tier* can be remapped to pull from data in your source tool. These values are regularly kept up to date as they will be [synced with your source](https://linear.app/docs/customer-requests.html#collapsible-7589124828b2).

You can also choose to enable manual edits for any attributes that are unmapped. Attributes will always be editable via the Linear API regardless of this UI-specific setting.

![attribute mapping for Intercom example](https://webassets.linear.app/images/ornj730p/production/b0a320e654622fc204fdb55d9f5f74a939287da4-1012x1208.png?w=1440&q=95&auto=format&dpr=2)

## Build customer views[⁠](https://linear.app/docs/customer-requests.html#build-customer-views)

All customer data brought into Linear can be used to create [custom views](https://linear.app/docs/custom-views.html) for both issues and projects to surface the impact of your work on your customers. For example, create a view of issues with requests from Enterprise customers (“Tier” property from Intercom), where each issue has at least 20 requests. Ordering this view by customer count surfaces the most highly requested issues to the top. Triangle icons indicating requests marked important surface urgent needs. Consider consulting this view when planning upcoming cycles to ensure what you ship aligns with the needs of the users.

![Filtering for Enterprise tier](https://webassets.linear.app/images/ornj730p/production/739bc7fc567fbc4d19f52777768ec792f0df8fac-922x336.png?w=1440&q=95&auto=format&dpr=2)

![Filtering for Enterprise tier](https://webassets.linear.app/images/ornj730p/production/ef27b0868982ed5d230e89228b6890eacc39ecdf-793x322.png?w=1440&q=95&auto=format&dpr=2)

![shows enterprise tier customer count on issues](https://webassets.linear.app/images/ornj730p/production/dd374bc785006a4b1296bf2c8b1f73ac606e6636-1576x990.png?w=1440&q=95&auto=format&dpr=2)

![shows enterprise tier customer count on issues](https://webassets.linear.app/images/ornj730p/production/1e98d83c4b3552773c5193f3cd12fdf1485efec7-1460x983.png?w=1440&q=95&auto=format&dpr=2)

### Notifications [⁠](https://linear.app/docs/customer-requests.html#notifications)

You’ll receive Inbox notifications automatically when new requests are added to issues you subscribe to so you’re always in the loop. Optionally, configure additional notification styles for new requests [here](https://linear.app/settings/account/notifications.html).

[Subscribing to custom views](https://linear.app/docs/custom-views.html#view-subscriptions) is the best option for more targeted alerts. For example, you might wish to stay aware of issues commonly raised by customers who churn. To track that, create a custom view defined by Customer status includes *Churned*, and ordering the issues by customer revenue. Click the bell icon to be alerted when a new issue is added to the view, or configure notifications to a Slack channel for greater visibility.
You can also open a specific customer page (`O` `then` `Q`) and under the bell icon subscribe to get notified when a request is added, marked important, completed or cancelled.

### Export Customer Requests[⁠](https://linear.app/docs/customer-requests.html#export-customer-requests)

Should you need to export your customer requests from a particular customer, issue, or project, an option exists in the `Cmd`/`Ctrl` + `K` menu. Search the command menu and select *Export customer requests as CSV* to take that action.

## FAQ[⁠](https://linear.app/docs/customer-requests.html#faq)

Which plans support Customer Requests?

Customer Requests is available on all currently offered plans: (Free, Basic, Business, and Enterprise.) You’ll only be able to create requests from integrations available on your plan.

| Create requests | Free | Business | Enterprise |
| --- | --- | --- | --- |
| Manually | ✔ | ✔ | ✔ |
| From Slack | ✔ | ✔ | ✔ |
| From Asks |  | ✔ | ✔ |
| From Intercom, Zendesk, and Front |  | ✔ | ✔ |
| From Salesforce Service Cloud |  |  | ✔ |

Can I manage customer requests through the API?

The following actions are available through our GraphQL [API](https://studio.apollographql.com/public/Linear-API/variant/current/schema/reference?query=customers):

* Create/Edit/Delete customers
* Create/Edit/Delete customer request
* Create/Edit/Delete customer tiers
* Create/Edit/Delete customer statuses
* Query and filter customers
* Query and filter requests by issue/projects/priority/customer

Can I merge duplicate customers?

Linear will prevent duplicate customers from being created in most cases. If you notice a duplicate instance, go to the customer page that you want to merge and select the *Merge with* option from the dropdown menu.

How do I block domains from creating customers?

In [Settings > Customer requests](https://linear.app/settings/customers.html), exclude specific email addresses or domains to prevent them from creating a customer.

For example, add a domain to *Excluded domains and emails* to prevent your own company from creating a customer. Internally, we’ve excluded `linear.app` here to prevent `Linear` from displaying as a customer when we create issues via integrations.

How do I avoid domains being associated with a customer?

You can prevent specific domains from ever being associated with a customer from [Settings > Customer requests](https://linear.app/settings/customers.html) and adding a domain or email under Excluded domains and emails.

Common providers like Gmail, Outlook etc. are automatically excluded. The full list of generic domains from common providers can be viewed here:

List of domains

• [10mail.org](http://10mail.org/)
• [10mail.xyz](http://10mail.xyz/)
• [163.com](http://163.com/)
• [alice.it](http://alice.it/)
• [aol.com](http://aol.com/)
• [appleid.com](http://appleid.com/)
• [att.net](http://att.net/)
• [bigpond.com](http://bigpond.com/)
• [comcast.net](http://comcast.net/)
• [cox.net](http://cox.net/)
• [dropmail.me](http://dropmail.me/)
• [duck.com](http://duck.com/)
• [emlhub.com](http://emlhub.com/)
• [emlpro.com](http://emlpro.com/)
• [emltmp.com](http://emltmp.com/)
• [facebook.com](https://facebook.com/)
• [fastmail.com](https://fastmail.com/)
• [flymail.tk](http://flymail.tk/)
• [free.fr](http://free.fr/)
• [freeml.net](http://freeml.net/)
• [gmail.com](https://gmail.com/)
• [gmx.de](https://gmx.de/)
• [googlemail.com](https://googlemail.com/)
• [hey.com](https://hey.com/)
• [hotmail.co.uk](http://hotmail.co.uk/)
• [hotmail.com](http://hotmail.com/)
• [hotmail.fr](http://hotmail.fr/)
• [hotmail.it](http://hotmail.it/)
• [icloud.com](https://icloud.com/)
• [ig.com.br](http://ig.com.br/)
• [laposte.net](http://laposte.net/)
• laste.ml
• [libero.it](http://libero.it/)
• [live.co.uk](http://live.co.uk/)
• [live.com](http://live.com/)
• [live.fr](http://live.fr/)
• [live.nl](http://live.nl/)
• [mac.com](http://mac.com/)
• [mail.ru](http://mail.ru/)
• [me.com](http://me.com/)
• [minimail.gq](http://minimail.gq/)
• [msn.com](https://msn.com/)
• [neut.fr](http://neut.fr/)
• [outlook.com](https://outlook.com/)
• [outlook.de](http://outlook.de/)
• [pm.me](https://pm.me/)
• [privaterelay.appleid.com](http://privaterelay.appleid.com/)
• [proton.me](http://proton.me/)
• [protonmail.com](https://protonmail.com/)
• [qq.com](http://qq.com/)
• [rocketmail.com](http://rocketmail.com/)
• [sbcglobal.net](http://sbcglobal.net/)
• [sfr.fr](http://sfr.fr/)
• [simplelogin.com](http://simplelogin.com/)
• spymail.one
• [terra.com.br](http://terra.com.br/)
• [verizon.net](http://verizon.net/)
• [web.de](https://web.de/)
• [yahoo.com](http://yahoo.com/)
• [yahoo.de](http://yahoo.de/)
• [yahoo.es](http://yahoo.es/)
• [yahoo.it](http://yahoo.it/)
• [yandex.ru](http://yandex.ru/)
• [ymail.com](http://ymail.com/)
• [yomail.info](http://yomail.info/)
• [yopmail.com](http://yopmail.com/)

How does visibility of Customer Requests work across roles?

Admins and Members will be able to see Customers Requests in Linear and in Slack in the dropdown menus on Asks and our Slack integration.

Guests see nothing relating to Customer Requests, including views that use Customer-related filters.

Users in your Slack workspace without Linear accounts will not see your customer list when using Asks, though we’ll still match the Ask to a customer where appropriate based on the user domain of the original message’s sender.

Can I stop Intercom, Zendesk, Front from creating new customers or customer requests?

In the integration settings for your support tool, you can toggle the setting off.

![Setting toggle to auto-create customers or requests](https://webassets.linear.app/images/ornj730p/production/6a25ef0886b83c279e351ae1332547d9a7fe9d95-1356x228.png?w=1440&q=95&auto=format&dpr=2)

How often is data synced from an external source?

Intercom is synced in real time and all other integration sources are synced every 12 hours.

[Previous

Asks Web Forms](https://linear.app/docs/linear-asks-web-forms.html)[Next

Projects](https://linear.app/docs/projects.html)

* [Overview](https://linear.app/docs/customer-requests.html#overview)
* [Configure](https://linear.app/docs/customer-requests.html#configure)
* [Customers](https://linear.app/docs/customer-requests.html#customers)
* [Customer pages](https://linear.app/docs/customer-requests.html#customer-pages)
* [Open Customer pages](https://linear.app/docs/customer-requests.html#open-customer-pages)
* [Create Customers](https://linear.app/docs/customer-requests.html#create-customers)
* [Customer requests](https://linear.app/docs/customer-requests.html#customer-requests)
* [Add requests to issues or projects](https://linear.app/docs/customer-requests.html#add-requests-to-issues-or-projects)
* [Integrations](https://linear.app/docs/customer-requests.html#integrations)
* [Built-in integrations](https://linear.app/docs/customer-requests.html#built-in-integrations)
* [Third-party integrations](https://linear.app/docs/customer-requests.html#third-party-integrations)
* [Mark as important](https://linear.app/docs/customer-requests.html#mark-as-important)
* [Synced Attributes](https://linear.app/docs/customer-requests.html#synced-attributes)
* [Build customer views](https://linear.app/docs/customer-requests.html#build-customer-views)
* [Notifications](https://linear.app/docs/customer-requests.html#notifications)
* [Export Customer Requests](https://linear.app/docs/customer-requests.html#export-customer-requests)
* [FAQ](https://linear.app/docs/customer-requests.html#faq)
