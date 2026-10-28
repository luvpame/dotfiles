---
title: "Audit log – Linear Docs"
source_url: "https://linear.app/docs/audit-log"
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

# Audit log

Audit logs show you a record of workspace events over the last 90 days.

Available to workspaces on our [Enterprise](https://linear.app/pricing.html) plan

![Audit log page in Linear](https://webassets.linear.app/images/ornj730p/production/9d0afc74a9a0ed53d8370f87cb109ea4eb297125-2160x1327.png?w=1440&q=95&auto=format&dpr=2)

## Overview[⁠](https://linear.app/docs/audit-log.html#overview)

Linear automatically tracks events related to account access, subscriptions, and settings changes including the IP and country of the actor. All audit logs are retained for 90 days. In the UI, you can browse recent events and filter by event type, and you can also filter out session-creation events from the recent events list. For more advanced queries, such as filtering by actor, email, IP address, or date range, we recommend accessing the audit log through the API.

## Configure[⁠](https://linear.app/docs/audit-log.html#configure)

Only [workspace owners](https://linear.app/docs/members-roles.html#workspace-owner) can access audit logs given the sensitive nature of the information. An owner can access the audit logs under [Workspace Settings > Administration > Audit Log](https://linear.app/settings/audit-log.html).

## Access via API[⁠](https://linear.app/docs/audit-log.html#access-via-api)

To perform complex queries based on type, actor, and other metadata, we recommend that you access the audit log through [Linear’s GraphQL API](https://developers.linear.app/docs/graphql/working-with-the-graphql-api). Visit our [API documentation](https://linear.app/docs/api-and-webhooks.html) to read more about making GraphQL API requests.

```
# Simple query to get last 250 events
query {
  auditEntries(first: 250) {
    nodes {
      id
      type
      createdAt
      actor {
        id
        name
      }
      metadata
    }
  }
}
```

You can utilize the advanced filtering capabilities of our API to narrow down your query.

```
# Get login events for a user
query {
	auditEntries(filter: {type: {eq: "login"}, actor: {email: {eq: "user@company.app"}}}) {
	  nodes {
	    id
	    type
	    createdAt
	    actor {
	      email
	    }
			ip
	    metadata
	  }
	  pageInfo {
	    endCursor
	    hasNextPage
	  }
	}
}
```

You can also get the list of all the available log entry types from our API.

```
query {
  auditEntryTypes {
    type
    description
  }
}
```

### Webhook and SIEM support[⁠](https://linear.app/docs/audit-log.html#webhook-and-siem-support)

Audit logs can be streamed to a webhook and configured for Security Information and Event Management data ingestion. To enable the audit log webhook, visit the [Audit Log](https://linear.app/settings/audit-log.html) under workspace settings and enable **Stream logs.** To learn more about securing your webhook using a signing secret, visit our [API documentation](https://developers.linear.app/docs/graphql/webhooks#securing-webhooks).

#### Sample responses[⁠](https://linear.app/docs/audit-log.html#sample-responses)

User joins a team:

```
{
  "action": "create",
  "actor":
    {
      "id": "8e03f2cf-e644-4d68-a7cc-f834ad2f43b4",
      "name": "Miha Rebernik",
      "email": "miha@linear.app",
      "avatarUrl": "https://public.linear.dev/8e03f2cf-e644-4d68-a7cc-f834ad2f43b4/d3c0a4bf-51a7-41cc-ade7-0f61f9d4f886",
      "type": "user",
    },
  "createdAt": "2025-03-28T19:46:01.382Z",
  "data":
    {
      "id": "4b0186dc-a464-4330-9d4b-f4fc8f01db5b",
      "createdAt": "2025-03-28T19:46:01.382Z",
      "type": "userJoinedTeam",
      "organizationId": "5a3b982d-8f04-4971-956c-fbcb2c68642a",
      "actorId": "8e03f2cf-e644-4d68-a7cc-f834ad2f43b4",
      "metadata":
        {
          "teamName": "New team",
          "teamKey": "NEW",
          "teamId": "7586c601-2c9f-4764-bbc5-6132791c68c9",
          "owner": false,
        },
      "requestInformation": {},
    },
  "type": "AuditEntry",
  "organizationId": "5a3b982d-8f04-4971-956c-fbcb2c68642a",
  "webhookTimestamp": 1743191166416,
  "webhookId": "f1d0caa0-a974-4604-a300-a4edbba66803",
}
```

A webhook is created:

```
{
  "action": "create",
  "actor": {
    "id": "8e03f2cf-e644-4d68-a7cc-f834ad2f43b4",
    "name": "Miha Rebernik",
    "email": "miha@linear.app",
    "avatarUrl": "https://public.linear.dev/8e03f2cf-e644-4d68-a7cc-f834ad2f43b4/d3c0a4bf-51a7-41cc-ade7-0f61f9d4f886",
    "type": "user"
  },
  "createdAt": "2025-03-28T19:46:18.441Z",
  "data": {
    "id": "e78bfecd-53a6-4197-8a71-f614b187553a",
    "createdAt": "2025-03-28T19:46:18.441Z",
    "type": "webhookCreated",
    "organizationId": "5a3b982d-8f04-4971-956c-fbcb2c68642a",
    "actorId": "8e03f2cf-e644-4d68-a7cc-f834ad2f43b4",
    "ip": "::ffff:127.0.0.1",
    "metadata": {
      "id": "53188995-5f3b-44a9-993b-9bb0d37136a5",
      "url": "https://webhook.site/399c1880-02e6-4a2b-8b62-6f2ea5c8cc7e/123",
      "label": "A new webhook",
      "enabled": true,
      "resourceTypes": ["Issue"],
      "allPublicTeams": true
    },
    "requestInformation": {
      "userAgent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/134.0.0.0 Safari/537.36",
      "authMethod": "jwt",
      "authService": "google"
    }
  },
  "type": "AuditEntry",
  "organizationId": "5a3b982d-8f04-4971-956c-fbcb2c68642a",
  "webhookTimestamp": 1743191178476,
  "webhookId": "f1d0caa0-a974-4604-a300-a4edbba66803"
}
```

[Previous

Security](https://linear.app/docs/security.html)[Next

Billing and plans](https://linear.app/docs/billing-and-plans.html)

* [Overview](https://linear.app/docs/audit-log.html#overview)
* [Configure](https://linear.app/docs/audit-log.html#configure)
* [Access via API](https://linear.app/docs/audit-log.html#access-via-api)
* [Webhook and SIEM support](https://linear.app/docs/audit-log.html#webhook-and-siem-support)
* [Sample responses](https://linear.app/docs/audit-log.html#sample-responses)
