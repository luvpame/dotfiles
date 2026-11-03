---
title: "API and Webhooks – Linear Docs"
source_url: "https://linear.app/docs/api-and-webhooks"
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

# API and Webhooks

Linear’s GraphQL API and webhooks lets you extend Linear’s functionality beyond what we provide out of the box.

![Linear logo and a logo representing the API](https://webassets.linear.app/images/ornj730p/production/c944abb65e6b46b14d2666d88f8d390699ffd265-2880x1620.png?w=1440&q=95&auto=format&dpr=2)

## Overview[⁠](https://linear.app/docs/api-and-webhooks.html#overview)

Linear’s public API is built using GraphQL. It’s the same API we use internally for developing our applications.

Linear’s webhooks allow you to receive HTTP(S) push notifications whenever data is created or updated. This allows you to build integrations on top of Linear.

## Basics[⁠](https://linear.app/docs/api-and-webhooks.html#basics)

### API[⁠](https://linear.app/docs/api-and-webhooks.html#api)

You own your data in Linear and our GraphQL API lets you query that data. In addition to querying, Linear has full support for mutating all entities. Any mutations you make via the API are observed in real-time by all clients.

Go to the API section under Account > Security & Access [settings](https://linear.app/settings/account/security.html) and read the linked [API documentation](https://developers.linear.app/docs/graphql/working-with-the-graphql-api) for more information. Our GraphQL schema is available [here](https://studio.apollographql.com/public/Linear-API/variant/current/schema/reference).

![](https://webassets.linear.app/images/ornj730p/production/ea822173f6bf2d9383d19105d9ecaa6693492aca-16x16.svg?q=95&auto=format&dpr=2)

For more in depth documentation visit [developers.linear.app](https://developers.linear.app/docs/). If you have a question the docs don’t answer, post it in the #api channel in our [Slack community](https://linear.app/join-slack.html).

### API Keys[⁠](https://linear.app/docs/api-and-webhooks.html#api-keys)

Admins can choose whether or not Members can create their own API keys from *Settings > Administration > API > Member API keys.* This setting will not apply to Admins who can always create API keys.

![Member API Key permission toggle](https://webassets.linear.app/images/ornj730p/production/91976e7722c04bf16f048765228587c090b0bd96-974x303.png?w=1440&q=95&auto=format&dpr=2)

Existing API keys for your workspace can be viewed from the same menu and revoked if needed.

Admins and permitted Members can create personal API keys from *Settings > Account > Security & Access.* For each key you create, you can choose to give it full access to the data your user can access, or restrict it to certain permissions (*Read, Write, Admin, Create issues, Create comments).* You can also limit an API key’s access to specific teams in your workspace.

### Webhooks[⁠](https://linear.app/docs/api-and-webhooks.html#webhooks)

Our webhooks support data change events for Issues, Comments, Issue attachments, Documents, Emoji reactions, Projects, Project updates, Cycles, Labels, Users and Issue SLAs.

Consider using webhooks to trigger CI builds, perform calculations on issue data or send messages on specific conditions. Creating and managing webhooks requires admin permissions. Read more in our [webhook documentation](https://linear.app/developers/webhooks.html).

The configured URL will be called whenever any issue or comment in that team is created or updated. You’ll receive the entire data object as the payload. We’ll also let you know what the previous values for all changed properties were.

### Create a webhook[⁠](https://linear.app/docs/api-and-webhooks.html#create-a-webhook)

Create and manage webhooks and OAuth applications in *Settings > Administration > API.* Admin permissions in your workspace are necessary to view this page.

### Third-party apps[⁠](https://linear.app/docs/api-and-webhooks.html#third-party-apps)

Third-party integrations created for Linear can be found on our [integrations directory.](https://linear.app/integrations.html)

[Previous

SCIM](https://linear.app/docs/scim.html)[Next

Third-Party App Approvals](https://linear.app/docs/third-party-application-approvals.html)

* [Overview](https://linear.app/docs/api-and-webhooks.html#overview)
* [Basics](https://linear.app/docs/api-and-webhooks.html#basics)
* [API](https://linear.app/docs/api-and-webhooks.html#api)
* [API Keys](https://linear.app/docs/api-and-webhooks.html#api-keys)
* [Webhooks](https://linear.app/docs/api-and-webhooks.html#webhooks)
* [Create a webhook](https://linear.app/docs/api-and-webhooks.html#create-a-webhook)
* [Third-party apps](https://linear.app/docs/api-and-webhooks.html#third-party-apps)
