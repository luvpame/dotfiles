---
title: "Claude  Integration – Linear"
source_url: "https://linear.app/integrations/claude"
fetched_at: "2026-10-27T08:17:41.028425+00:00"
---



1. [Integrations](https://linear.app/integrations.html)
2. Claude

# Connect Claude to the Linear MCP server

![Linear and Claude logos on a black background](https://webassets.linear.app/images/ornj730p/production/778f177504fd3eb04015c43d348ef9b587bca257-1760x924.png?q=95&auto=format&dpr=2)

Connect Linear and Claude using the Linear MCP server

![Linear and Claude logos on a black background](https://webassets.linear.app/images/ornj730p/production/778f177504fd3eb04015c43d348ef9b587bca257-1760x924.png?q=95&auto=format&dpr=2)

Connect Linear and Claude using the Linear MCP server

### Overview[⁠](https://linear.app/integrations/claude.html#overview)

Claude is a conversational AI assistant from Anthropic. By connecting it to Linear via the MCP server, Claude can search, create, and update Linear issues, projects, and comments directly from a conversation.

## **Setup instructions**[⁠](https://linear.app/integrations/claude.html#setup-instructions)

**Browser and desktop app**

Navigate to the [connectors](https://claude.ai/customize/connectors) page in Claude settings and connect Linear.

**Claude Code**

```
claude mcp add --transport http linear-server https://mcp.linear.app/mcp
```

then run `/mcp` once you’ve opened a Claude Code session to go through the authentication flow.

*Remote MCP connections are still early and we’ve found that the connection may fail or require multiple attempts. If you experience issues, try restarting your client or disabling and re-enabling the Linear MCP server.*

Website
[claude.ai](https://claude.ai)

Category
[AI clients](https://linear.app/integrations/ai-clients.html)

[Add to Linear](https://linear.app/docs/mcp.html#claude)

#### You might be interested in

[Browse all integrations](https://linear.app/integrations.html)

* [![Visual Studio Code MCP icon](https://webassets.linear.app/images/ornj730p/production/b9bd65818fa0387a381b7253d268518ad53e13c4-2048x2048.png?w=256&q=95&auto=format&dpr=2)

  Visual Studio Code MCP

  By Visual Studio Code

  Connect VS Code to the Linear MCP server](vs-code-mcp.html)
* [![Zed icon](https://webassets.linear.app/images/ornj730p/production/2f4d92efd0892885043f6f47141099f2de223cb0-400x400.jpg?w=256&q=95&auto=format&dpr=2)

  Zed

  By Zed

  Connect Zed to the Linear MCP server](zed/index.html)
* [![Cursor MCP icon](https://webassets.linear.app/images/ornj730p/production/a2bb8e6a60f530cb07b4c7363301206597b5e8b5-400x400.jpg?w=256&q=95&auto=format&dpr=2)

  Cursor MCP

  By Cursor

  Connect Cursor to the Linear MCP server](cursor-mcp.html)

## Build your own integration

Create your own integration with Linear’s API and submit it to the directory.

[Start building](https://linear.app/docs/integration-directory.html#build-your-own)

## Build your own integration

Create your own integration with Linear’s API and submit it to the directory.
