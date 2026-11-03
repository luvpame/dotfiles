---
title: "Connect MCP Servers to Linear Agent – Linear Docs"
source_url: "https://linear.app/docs/connect-mcp-servers"
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
* Importers

# Connect MCP Servers to Linear Agent

![DataDog and Sentry MCP servers connected with Linear Agent to help analyze a bug report.](https://webassets.linear.app/images/ornj730p/production/74b8e0c4616b9593aad2293afb62477c096652a4-758x1134.png?w=1440&q=95&auto=format&dpr=2)

## Overview[⁠](https://linear.app/docs/connect-mcp-servers-to-linear-agent.html#overview)

Linear Agent can connect to MCP servers to access tools and data outside of Linear.

This lets the agent bring external context into your workflows to investigate issues, plan projects, write specs, and draft updates grounded in your full context.

MCP works across Linear Agent chat, comments, and automations, and is enabled at the workspace level by Admins.

### Available MCP servers[⁠](https://linear.app/docs/connect-mcp-servers-to-linear-agent.html#available-mcp-servers)

* Amplitude
* Attio
* Better Stack
* Datadog
* GitHub
* Glean
* Granola
* HubSpot
* incident.io
* Intercom
* Jam
* Notion
* PostHog
* Sentry
* Slack
* Stripe

## Setup[⁠](https://linear.app/docs/connect-mcp-servers-to-linear-agent.html#setup)

A workspace owner or admin can enable or disable MCP support for the workspace, restrict usage to approved MCP servers, and manage workspace-connected MCP servers.

Inherited from workspace-level settings, users can then configure their preferred MCP servers to leverage when collaborating with Linear Agent.

### Workspace configuration[⁠](https://linear.app/docs/connect-mcp-servers-to-linear-agent.html#workspace-configuration)

1. Open [Workspace settings > Security](https://linear.app/settings/security.html)
2. Beside **Enable MCP servers** toggle it to **“On”**
3. Under **Allowed MCP servers**, choose **All servers** or **Only specific servers**
4. Scroll down to MCP servers and select any that users and automations can connect to via Linear Agent

![Workspace MCP connector settings showing access controls and the Selected connectors option](https://webassets.linear.app/images/ornj730p/production/edd247935723320b36a2592447ed0793bf5c8a7a-959x625.png?w=1440&q=95&auto=format&dpr=2)

![Workspace MCP connector settings showing access controls and the Selected connectors option](https://webassets.linear.app/images/ornj730p/production/56dc4e78b28dc26e05409d93c0f7ef8e1ad2a3d7-950x634.png?w=1440&q=95&auto=format&dpr=2)

![Workspace MCP connector settings with Selected connectors enabled and the Search connectors picker open](https://webassets.linear.app/images/ornj730p/production/18dc9f1fe8d117550daf0d3ceeceedd559843ca0-2016x1186.png?w=1440&q=95&auto=format&dpr=2)

![Workspace MCP connector settings with Selected connectors enabled and the Search connectors picker open](https://webassets.linear.app/images/ornj730p/production/17bd1393f94b40a00f4fe28bcacbe5b38e0fd0b0-2016x1186.png?w=1440&q=95&auto=format&dpr=2)

Select available servers for the workspace including any custom servers using a URL

### Individual server connection[⁠](https://linear.app/docs/connect-mcp-servers-to-linear-agent.html#individual-server-connection)

Each user in your Linear workspace can configure their preferred MCP servers, based on restrictions defined at the workspace-level.

1. Open [Settings > Agent personalization](https://linear.app/settings/account/agents.html)
2. Under MCP servers click on the **“+” (Add server)** button
3. Choose a server and start the connection flow
4. Complete authentication with the provider
5. Return to Linear and confirm the server shows as connected

![Agent personalization settings showing MCP connectors, No connectors added, and the Add connector picker open](https://webassets.linear.app/images/ornj730p/production/0b29a39be907c2048525f028829f7ffd8cafd62f-3452x2358.png?w=1440&q=95&auto=format&dpr=2)

![Agent personalization settings showing MCP connectors, No connectors added, and the Add connector picker open](https://webassets.linear.app/images/ornj730p/production/72878c4a04353bbb74188ae1e5f1de5273e722b2-3452x2358.png?w=1440&q=95&auto=format&dpr=2)

After a server is connected, users can reference it in natural language when using Linear Agent. The agent can use the connected MCP server to gather information or perform supported actions.

![Prompt example for MCP server](https://webassets.linear.app/images/ornj730p/production/461e38065d0a92659e96488a59c4f0b46e74d0dc-503x636.png?w=1440&q=95&auto=format&dpr=2)

### Custom server connection[⁠](https://linear.app/docs/connect-mcp-servers-to-linear-agent.html#custom-server-connection)

1. Click **+ Custom URL…**
2. Select **Custom URL…**
3. Enter your server URL (must start with `http://` or `https://`) and complete the connection flow:

* No authentication → connects immediately
* OAuth supported → sign in and authorize
* Authentication headers → enter your custom headers

Custom servers can authenticate with OAuth or with Authentication headers, depending on how the server is set up. Once connected, the custom server will be available for users to connect to through their settings.

![Add custom MCP connector dialog with a blank Connector URL field, Advanced options, Cancel, and Add connector buttons](https://webassets.linear.app/images/ornj730p/production/5e22f312864d0bb306570d1a478208b13bbd1558-3452x2358.png?w=1440&q=95&auto=format&dpr=2)

![Add custom MCP connector dialog with a blank Connector URL field, Advanced options, Cancel, and Add connector buttons](https://webassets.linear.app/images/ornj730p/production/819fc94df30a21a8c482b19773ebf8c3094b8b2d-3452x2358.png?w=1440&q=95&auto=format&dpr=2)

## Example prompts[⁠](https://linear.app/docs/connect-mcp-servers-to-linear-agent.html#example-prompts)

> [Investigate this issue using Sentry and summarize the likely cause](https://linear.app/agent%3Fprompt=Investigate%20this%20issue%20using%20Sentry%20and%20summarize%20the%20likely%20cause.html)

> [Check Datadog for recent errors related to this workflow](https://linear.app/agent%3Fprompt=Check%20Datadog%20for%20recent%20errors%20related%20to%20this%20workflow.html)

> [Look up the latest notes about this customer in Intercom](https://linear.app/agent%3Fprompt=Look%20up%20the%20latest%20notes%20about%20this%20customer%20in%20Intercom.html)

> [Search Notion for relevant documents and generate a guide ahead of launch](https://linear.app/agent%3Fprompt=Search%20Notion%20for%20relevant%20documents%20and%20generate%20a%20guide%20ahead%20of%20launch.html)

> [Use GitHub to find the pull request that likely introduced this change](https://linear.app/agent%3Fprompt=Use%20GitHub%20to%20find%20the%20pull%20request%20that%20likely%20introduced%20this%20change.html)

* [Overview](https://linear.app/docs/connect-mcp-servers-to-linear-agent.html#overview)
* [Available MCP servers](https://linear.app/docs/connect-mcp-servers-to-linear-agent.html#available-mcp-servers)
* [Setup](https://linear.app/docs/connect-mcp-servers-to-linear-agent.html#setup)
* [Workspace configuration](https://linear.app/docs/connect-mcp-servers-to-linear-agent.html#workspace-configuration)
* [Individual server connection](https://linear.app/docs/connect-mcp-servers-to-linear-agent.html#individual-server-connection)
* [Custom server connection](https://linear.app/docs/connect-mcp-servers-to-linear-agent.html#custom-server-connection)
* [Example prompts](https://linear.app/docs/connect-mcp-servers-to-linear-agent.html#example-prompts)
