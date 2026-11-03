---
title: "Approveit Integration – Linear"
source_url: "https://linear.app/integrations/approveit"
fetched_at: "2026-10-27T08:17:41.028425+00:00"
---



1. [Integrations](https://linear.app/integrations.html)
2. Approveit

# Turn approved requests into Linear issues, and send Linear issues out for approval

![approveit showing approval workflow into Linear](https://webassets.linear.app/images/ornj730p/production/9594b8f722d6168cb58d55c730004228d7983ad0-1600x1000.png?q=95&auto=format&dpr=2)

![approveit showing approval workflow into Linear](https://webassets.linear.app/images/ornj730p/production/9594b8f722d6168cb58d55c730004228d7983ad0-1600x1000.png?q=95&auto=format&dpr=2)

## Overview[⁠](https://linear.app/integrations/approveit.html#overview)

Approveit routes approval requests through Slack, Microsoft Teams, email, or the web, then turns the decision into work in Linear. Approved access requests, release sign-offs, and purchase decisions arrive as Linear issues already authorized, with a record of who approved what and when.

## How it works[⁠](https://linear.app/integrations/approveit.html#how-it-works)

Approveit is an approval workflow platform. An admin builds a workflow that defines what a request contains and who signs off on it, with multi-step routing and conditional logic so that a small purchase follows a different path than a large one. Requestors submit from Slack, Microsoft Teams, email, a public form, or the web app, and approvers act wherever they already work rather than signing into another tool.

When a request is approved, Approveit creates or updates an issue in Linear. Values from the request are mapped into the issue title, description, team, and labels, so an access request arrives as a provisioning issue with the requestor, the system, and the approved scope already filled in. Actions can run automatically on approval or pause for an admin to confirm the resolved arguments first, and each one is recorded against the originating request, so it is always clear which decision produced which issue.

Approveit can also read from Linear on a schedule. You point it at a Linear query and matching issues become approval requests with their fields mapped across, deduplicated so the same issue is never imported twice. This takes work that is sitting in a backlog waiting on a decision and turns it into a tracked approval with named approvers and a timestamped history. The connection is authorized over OAuth through Linear’s hosted MCP server, so there are no API keys for customers to create or rotate.

## Configure[⁠](https://linear.app/integrations/approveit.html#configure)

Connecting Linear requires an Approveit admin with the Integrations permission, and a Linear user who can authorize OAuth access for the workspace.

In Approveit, open Settings → Integrations at <https://app.approveit.today/settings?integration=mcp>, add a new MCP server, and select Linear from the preset list. Authorizing redirects you to Linear to grant access and returns you to the settings page, where you then choose which Linear tools Approveit is allowed to call. We recommend creating a dedicated Approveit workspace in Linear so that all of your admins have access to the connection.

To send approvals into Linear, open a workflow in the builder, add an action to the approval stage, select the Linear tool, and map request fields into the issue using field references. To bring Linear issues into Approveit for approval, use Add external data source on the stage, choose the Linear query, and set a polling schedule.

Website
[approveit.today](https://approveit.today)

Category
[Collaboration](https://linear.app/integrations/collaboration.html)

Contact

[Contact Approveit](mailto:support@approveit.today)

[Open website](https://approveit.today/integrations?utm_source=linear&utm_medium=marketplace&utm_campaign=integration_directory)

#### You might be interested in

[Browse all integrations](https://linear.app/integrations.html)

* [![Slack icon](https://webassets.linear.app/images/ornj730p/production/28e6449162d4a338f94e6e9d05ae2c9c7b988efb-640x640.png?w=256&q=95&auto=format&dpr=2)

  Slack

  By Linear

  Create issues from Slack messages and sync threads](slack.html)
* [![Linear Asks for Slack icon](https://webassets.linear.app/images/ornj730p/production/50523dc935cc10d87e73339ac5993e1cee96f96b-640x640.png?w=256&q=95&auto=format&dpr=2)

  Linear Asks for Slack

  By Linear

  Turn requests from Slack or email into actionable issues and enable helpdesk workflows](linear-asks.html)
* [![Hipporello Service Desk icon](https://webassets.linear.app/images/ornj730p/production/e0394ae8c1f5380d0e82930ad686f1e53cbb0177-640x640.png?w=256&q=95&auto=format&dpr=2)

  Hipporello Service Desk

  By hipporello

  Customer support, inside Linear](hipporello-service-desk.html)

## Build your own integration

Create your own integration with Linear’s API and submit it to the directory.

[Start building](https://linear.app/docs/integration-directory.html#build-your-own)

## Build your own integration

Create your own integration with Linear’s API and submit it to the directory.
