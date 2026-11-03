---
title: "MCP server – Linear Docs"
source_url: "https://linear.app/docs/mcp"
fetched_at: "2026-10-27T08:17:41.028425+00:00"
---



* Getting started
* Intake
* Projects and initiatives
* Issues and cycles
* Coding and review
* Agents and automation

  + [![Linear Agent](https://webassets.linear.app/images/ornj730p/production/1da47a1cbf8563070d25e5794910b622f03a428d-16x16.svg?q=95&auto=format&dpr=2)Linear Agent](linear-agent.html)
  + [![Loops](https://webassets.linear.app/images/ornj730p/production/0ba9c78fdd4e19b308e1b9bdb530743e3090e397-16x16.svg?q=95&auto=format&dpr=2)Loops](loops.html)
  + [![AI Agents](https://webassets.linear.app/images/ornj730p/production/5914e5199f95b48d50cdd2eb6cb02e0a8d6e7a24-16x16.svg?q=95&auto=format&dpr=2)AI Agents](agents-in-linear.html)
  + [![Triage Intelligence](https://webassets.linear.app/images/ornj730p/production/2308492a72303e9c95f13dad1591c985c13c0c0a-16x16.svg?q=95&auto=format&dpr=2)Triage Intelligence](product-intelligence.html)
  + [![Code Intelligence](https://webassets.linear.app/images/ornj730p/production/6c9a57ffb812e20c93862d04b62ae5ee5893358e-16x16.svg?q=95&auto=format&dpr=2)Code Intelligence](code-intelligence.html)
  + [![MCP server](https://webassets.linear.app/images/ornj730p/production/6b6af6cd841b626b6949c15c3393d726b85d51db-16x16.svg?q=95&auto=format&dpr=2)MCP server](mcp.html)
* Insights and outcomes
* Working in Linear
* Integrations
* Administration
* Importers

# MCP server

![Abstract image of a drive with Linear's logo and the words "Remote MCP server"](https://webassets.linear.app/images/ornj730p/production/54373418b3cb31208f112cd8137d7dd825d1b7c0-3600x1800.png?w=1440&q=95&auto=format&dpr=2)

The Model Context Protocol (MCP) server provides a standardized interface that allows any compatible AI model or agent to access your Linear data in a simple and secure way.

Connect to our MCP server natively in Claude, Cursor, and other clients or use the [`mcp-remote`](https://github.com/geelen/mcp-remote) module for backwards compatibility with clients that do not support remote MCP.

Linear’s MCP server follows the authenticated remote [MCP spec](https://modelcontextprotocol.io/specification/2025-03-26), so the server is centrally hosted and managed. The Linear MCP server has tools available for finding, creating, and updating objects in Linear like issues, projects, and comments — with more functionality on the way, and [feedback](https://linear.app/contact/support.html) on its functionality is welcomed.

For help getting started after setup, see some of our [example prompts](https://linear.app/docs/mcp.html#common-use-cases).

## Setup[⁠](https://linear.app/docs/mcp.html#setup)

### General[⁠](https://linear.app/docs/mcp.html#general)

Our MCP server uses Streamable HTTP as the primary transport, accessible at the following address. The interactive setup flow uses OAuth 2.1 with dynamic client registration. You can also authenticate directly with a bearer token or Linear API key — see the FAQ for details.

Read-write access is provided through `https://mcp.linear.app/mcp` by default.

For read-only access, you have two options:

* Connect to `https://mcp.linear.app/mcp/readonly`, which only ever exposes read tools.
* Use the standard `/mcp` endpoint, but only request the `read` OAuth scope. Clients that request `read` are granted read-only access, and the underlying token can’t reach write APIs.

For instructions for specific clients, read on. Dedicated setup pages are also available for [Claude](https://linear.app/integrations/claude.html), [Cursor](https://linear.app/integrations/cursor-mcp.html), [VS Code](https://linear.app/integrations/vs-code-mcp.html), [Windsurf](https://linear.app/integrations/windsurf.html), and [Zed](https://linear.app/integrations/zed/index.html).

### Claude[⁠](https://linear.app/docs/mcp.html#claude)

**Team, Enterprise (Claude.ai)**

Navigate to the [connectors](https://claude.ai/customize/connectors) page and connect Linear.

**Free, Pro (Claude desktop)**

From Claude settings > Connectors you can add the Linear connector.

#### Enterprise-managed authorization[⁠](https://linear.app/docs/mcp.html#enterprise-managed-authorization)

If you use Okta, first configure SAML for Linear using [Okta’s OIN](https://linear.app/docs/saml-and-access-control.html#configure). Then enable **MCP enterprise managed authentication** from the bottom of your Okta identity provider settings in Linear.

![MCP Enterprise managed authentication settings located at the bottom of Okta Configuration Settings](https://webassets.linear.app/images/ornj730p/production/a3e0541408aa39d02ee4b19a7dcdd75fdf14c5f7-1140x362.png?w=1440&q=95&auto=format&dpr=2)

Once this is toggled on, copy the [**Issuer URI**](https://developer.okta.com/docs/guides/sign-into-spa-redirect/-/main/#find-your-config-values) for the authorization server from Okta’s side and paste this into your Linear settings:

```
e.g. https://your-org.okta.com
```

![Okta API Settings for Authorization Server Issuer URL](https://webassets.linear.app/images/ornj730p/production/17ff81dae2e68d7a3a5a7eddb13ac327a99b5812-780x258.png?w=1440&q=95&auto=format&dpr=2)

![Okta API Settings for Authorization Server Issuer URL](https://webassets.linear.app/images/ornj730p/production/17ff81dae2e68d7a3a5a7eddb13ac327a99b5812-780x258.png?w=1440&q=95&auto=format&dpr=2)

This allows supported external MCP clients such as Claude to authenticate users automatically using your Okta-managed access policies.

### Claude Code[⁠](https://linear.app/docs/mcp.html#claude-code)

```
claude mcp add --transport http linear-server https://mcp.linear.app/mcp
```

Then run `/mcp` once you’ve opened a Claude Code session to go through the authentication flow.

### Codex[⁠](https://linear.app/docs/mcp.html#codex)

The setup steps for the MCP server are the same regardless of whether you use the IDE Extension or the CLI since the configuration is shared.

**Configuration via CLI:**

Run the following command in Terminal:

```
codex mcp add linear --url https://mcp.linear.app/mcp
```

This will automatically prompt you to log in with your Linear account and connect it to your Codex.

**Note**: If this is the first time you are using an MCP in Codex you will need to enable the `rmcp` feature for this to work. Add the following into your `~/.codex/config.toml`:

```
[features]
experimental_use_rmcp_client = true
```

**Configuration through environment variables:**

1. Open the `~/.codex/config.toml` file in your preferred editor
2. Add the following:

```
[features]
experimental_use_rmcp_client = true

[mcp_servers.linear]
url = "https://mcp.linear.app/mcp"
```

Run `codex mcp login linear` to move through the authentication flow.

### Cursor[⁠](https://linear.app/docs/mcp.html#cursor)

To add the MCP to Cursor, you can install by clicking [here](cursor://anysphere.cursor-deeplink/mcp/install?name=Linear&config=eyJ1cmwiOiJodHRwczovL21jcC5saW5lYXIuYXBwL21jcCJ9), or searching for Linear from Cursor’s [MCP tools page](https://cursor.com/docs/context/mcp/directory).

![C](https://webassets.linear.app/images/ornj730p/production/7ff4a8f3f3f95e1a25a241c49f5d46c66e17b80a-760x343.png?w=1440&q=95&auto=format&dpr=2)

### Jules[⁠](https://linear.app/docs/mcp.html#jules)

* In Linear, go to **Settings** > **Account** > **[Security & Access](https://linear.app/settings/account/security.html)**
* Generate a new API key and copy it somewhere secure
* Now in Jules, go to [**MCP Settings**](https://jules.google.com/settings/mcp)
* Select **Connect** on the Linear server and paste your API key

### Visual Studio Code[⁠](https://linear.app/docs/mcp.html#visual-studio-code)

```
{
  "mcpServers": {
    "linear": {
      "command": "npx",
      "args": ["-y", "mcp-remote", "https://mcp.linear.app/mcp"]
    }
  }
}
```

1. `CTRL/CMD`  `P` and search for **MCP: Add Server**.
2. Select **Command (stdio)**
3. Enter the following configuration, and hit enter.

`npx mcp-remote https://mcp.linear.app/mcp`

1. Enter the name **Linear** and hit enter.
2. Activate the server using **MCP: List Servers** and selecting **Linear**, and selecting **Start Server**.

### v0 by Vercel[⁠](https://linear.app/docs/mcp.html#v0-by-vercel)

To add the MCP to v0, you can install from the [connections](https://v0.app/chat/settings/mcp-connections) page.

### Windsurf[⁠](https://linear.app/docs/mcp.html#windsurf)

1. `CTRL/CMD`  `,` to open Windsurf settings.
2. Under Scroll to Cascade -> MCP servers
3. Select **Add Server -> Add custom server**
4. Add the following:

```
{
  "mcpServers": {
    "linear": {
      "command": "npx",
      "args": ["-y", "mcp-remote", "https://mcp.linear.app/mcp"]
    }
  }
}
```

### Zed[⁠](https://linear.app/docs/mcp.html#zed)

1. `CMD`  `,` to open Zed settings.
2. Add the following:

```
{
  "context_servers": {
    "linear": {
      "source": "custom",
      "command": "npx",
      "args": ["-y", "mcp-remote", "https://mcp.linear.app/mcp"],
      "env": {}
    }
  }
}
```

### Others[⁠](https://linear.app/docs/mcp.html#others)

Hundreds of other tools now support MCP servers, you can configure them to use Linear’s MCP server with the following settings:

* **Command**: `npx`
* **Arguments**: `-y mcp-remote https://mcp.linear.app/mcp`
* **Environment**: None

## Common use cases[⁠](https://linear.app/docs/mcp.html#common-use-cases)

The MCP server lets you work with your Linear data from any compatible AI client. To help get started with the Linear MCP tooling, feel free to copy some example prompts into your own client to explore what’s possible.

Roadmap planning

**Use case**

Use this workflow to turn a planning document into a structured Linear project, with issues, milestones, and relationships that make the work easier to organize and track.

**Example prompt**

You are helping turn a planning document into a well-structured Linear project.

Read the document, create a project that reflects its objective, scope, and timeline, then create the issues needed to represent the work with clear titles and populated descriptions. Each issue should make the work actionable by capturing the problem, the goal, the proposed approach when one is provided, and any open questions that remain. Organize issues into milestones when the document clearly implies phases, deliverables, or checkpoints, and add related relationships where issues are meaningfully connected, but do not invent dependencies or structure that the source material does not support.

If the document is too vague or ambiguous to produce high-quality work, flag the uncertainty and return a proposed outline for review instead of guessing.

Before creating anything, show the proposed project, milestones, issues, relationships, and any decisions that need review.

Standup note automation

**Use case**

Use this workflow to turn standup notes into clear updates on the relevant Linear issues, so progress and blockers stay documented without extra manual work.

**Example prompt**

You are helping turn live standup notes into updates on existing Linear issues.

Read the notes, identify any issues mentioned by ID, title, owner, or clear surrounding context, and match each note only when the connection is strong.

For every confident match, add a concise comment that captures what changed, the current status or blocker, and the next step if one is mentioned. Keep each comment factual and specific to that issue. If a note is ambiguous or you cannot confidently match it, do not guess or create work from it; return it as unmatched with a short explanation.

Before applying any changes, show which issues you plan to update and the exact comment you would post to each one, then apply the comments and separately list any notes you skipped.

Standup notes: `[Paste the notes’ raw text here or attach the transcript as a document]`

Incoming bug investigation

**Use case**

Use this workflow to investigate a reported bug from an existing Linear issue, identify a likely root cause, and capture the findings back on the issue for the team.

**Example prompt**

You are helping investigate a bug that is already tracked in Linear.

Start from the referenced issue, use its description and any linked context as the starting point, and search for the most likely root cause by following relevant technical, product, or workflow clues.

Focus on producing a clear, evidence-based explanation of what is happening, what changed if that is relevant, and what the likely cause appears to be. Do not guess when the evidence is weak; instead, call out uncertainty and explain what additional context would help.

Once you have enough information, write a concise summary of the findings and post that summary as a comment on the issue so the investigation is documented for the team.

Linear issue to investigate: `[LIN-123]`

Team cycle summarization

**Use case**

Use this workflow to summarize what a team completed during a specific cycle or timeframe, making it easier to review progress and communicate outcomes.

**Example prompt**

You are helping summarize work completed during a specific Linear cycle or timeframe.

Identify the most recently completed cycle to analyze for the selected team or teams, gather the relevant issues, and produce a concise summary of what was accomplished. Focus on the work that was actually completed, the main themes across that work, and any notable patterns such as bugs resolved, projects advanced, or areas of concentrated effort.

Keep the summary clear and useful for sharing with others, and avoid overstating progress where the underlying work is still in flight.

Team identifiers: `[LIN, FEA]`

Timeline generation

**Use case**

Use this workflow to build a historical timeline of work in Linear around a topic, so teams can understand how a project, incident, or theme evolved over time.

**Example prompt**

You are helping document the history of work in Linear around a specific topic.

Gather the relevant issues and projects connected to that topic, review their historical activity, and produce a timeline that shows the key developments in chronological order.

Focus on meaningful milestones such as when work was created, when direction changed, when major decisions or updates were recorded, and when important work was completed.

Keep the timeline factual and grounded in the underlying activity, and call out any gaps or ambiguity rather than inferring events that are not clearly supported.

Topic: `[Insert a specific topic from your workspace]`

Implementation plan

**Use case**

Use this workflow to turn an initial idea into a reviewed implementation plan, then create the corresponding Linear work and delegate execution to the right people or agents.

**Example prompt**

You are helping plan and structure a development effort in Linear.

Start by designing an approach based on the provided context, with enough detail to explain the proposed solution, major workstreams, and any important tradeoffs or open questions. Treat that initial plan as a draft that can be reviewed and edited before any work is created.

Once the plan is approved, create a parent issue that captures the overall goal and create sub-issues for the concrete pieces of work needed to execute it.

Keep the breakdown clear and actionable, and assign or delegate work only when the requested owners or agents are explicitly specified.

Context: `[Insert enough context to help orient the agent]`

## FAQ[⁠](https://linear.app/docs/mcp.html#faq)

Why am I seeing an internal server error when trying to connect?

Enter the following in the Terminal to clear saved auth info: `rm -rf ~/.mcp-auth` then try again to connect.

Additionally you may need to update to a newer version of node if required.

Can I authenticate with multiple Linear workspaces?

The Linear MCP server authenticates each session via OAuth. Because reconnecting alone does not switch the workspace within an existing auth session, each workspace needs its own separate authentication context.

If your client or the `mcp-remote` module supports a configuration directory (for example via `MCP_REMOTE_CONFIG_DIR`), point each workspace to a different path:

```
MCP_REMOTE_CONFIG_DIR=~/.mcp-auth/workspace-a npx mcp-remote https://mcp.linear.app/mcp
MCP_REMOTE_CONFIG_DIR=~/.mcp-auth/workspace-b npx mcp-remote https://mcp.linear.app/mcp
```

Authenticate each configuration separately. For clients that manage their own auth storage, check the client’s documentation for workspace-switching options.

Can I authenticate with my own API keys or OAuth access tokens?

The MCP server supports passing OAuth token and API keys directly in the `Authorization: Bearer <yourtoken>` header instead of using the interactive authentication flow.

You can use this to interact with the MCP server as an `app` user, provide read-only access through a restricted API key, or integrate with an existing Linear OAuth application without an extra authentication hop.

For an alternative read-only approach with your own API key, create a Linear API key with only the `Read` permission enabled.

What about the SSE endpoint?

The SSE endpoint at `https://mcp.linear.app/sse` is a deprecated fallback for clients that do not support Streamable HTTP.

For all new setups, use the primary Streamable HTTP endpoint at `https://mcp.linear.app/mcp`.

My remote MCP connection dropped or isn't responding

Remote MCP connections can occasionally need a reconnect in some client setups. Try disconnecting and reconnecting the server from your client’s MCP settings. This is a routine client-side reset and does not affect your Linear data or authentication session.

I'm using WSL on Windows, and seeing an error

The default connection uses Streamable HTTP at `https://mcp.linear.app/mcp`. If that does not work in WSL, use this SSE fallback instead (`/sse` is a legacy path for clients that do not support Streamable HTTP):

`{"mcpServers": {"linear": {"command": "wsl","args": ["npx","-y","mcp-remote","https://mcp.linear.app/sse","--transport sse-only"]}}}`

[Previous

Code Intelligence](https://linear.app/docs/code-intelligence.html)[Next

Dashboards](https://linear.app/docs/dashboards.html)

* [Setup](https://linear.app/docs/mcp.html#setup)
* [General](https://linear.app/docs/mcp.html#general)
* [Claude](https://linear.app/docs/mcp.html#claude)
* [Enterprise-managed authorization](https://linear.app/docs/mcp.html#enterprise-managed-authorization)
* [Claude Code](https://linear.app/docs/mcp.html#claude-code)
* [Codex](https://linear.app/docs/mcp.html#codex)
* [Cursor](https://linear.app/docs/mcp.html#cursor)
* [Jules](https://linear.app/docs/mcp.html#jules)
* [Visual Studio Code](https://linear.app/docs/mcp.html#visual-studio-code)
* [v0 by Vercel](https://linear.app/docs/mcp.html#v0-by-vercel)
* [Windsurf](https://linear.app/docs/mcp.html#windsurf)
* [Zed](https://linear.app/docs/mcp.html#zed)
* [Others](https://linear.app/docs/mcp.html#others)
* [Common use cases](https://linear.app/docs/mcp.html#common-use-cases)
* [FAQ](https://linear.app/docs/mcp.html#faq)
