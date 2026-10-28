---
title: "Windsurf Integration – Linear"
source_url: "https://linear.app/integrations/windsurf"
fetched_at: "2026-10-27T08:17:41.028425+00:00"
---



1. [Integrations](https://linear.app/integrations.html)
2. Windsurf

# Connect Windsurf to the Linear MCP server

![Linear and Windsurf logo on a black background](https://webassets.linear.app/images/ornj730p/production/7fbabff933f38d37524ec5241685e4ec39731e09-1760x924.png?q=95&auto=format&dpr=2)

![Linear and Windsurf logo on a black background](https://webassets.linear.app/images/ornj730p/production/7fbabff933f38d37524ec5241685e4ec39731e09-1760x924.png?q=95&auto=format&dpr=2)

### Overview[⁠](https://linear.app/integrations/windsurf.html#overview)

Windsurf is a next-generation AI IDE that keeps you “in flow” by letting agents reason over your entire project. Adding Linear’s MCP server makes Linear data available to those agents.

### Setup instructions[⁠](https://linear.app/integrations/windsurf.html#setup-instructions)

Select the Cascade plugins icon and scroll to find and install the Linear MCP server.

To configure manually, follow these steps:

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

*Remote MCP connections are still early and we’ve found that the connection may fail or require multiple attempts. If you experience issues, try restarting your client or disabling and re-enabling the Linear MCP server.*

Website
[windsurf.com](https://windsurf.com)

Category
[AI clients](https://linear.app/integrations/ai-clients.html)

[Add to Linear](https://linear.app/docs/mcp.html#windsurf)

#### You might be interested in

[Browse all integrations](https://linear.app/integrations.html)

* [![Claude  icon](https://webassets.linear.app/images/ornj730p/production/b95ad5ddcb4b835b54ba093d237df7e019a9cb76-338x338.png?w=256&q=95&auto=format&dpr=2)

  Claude

  By Claude

  Connect Claude to the Linear MCP server](claude.html)
* [![Cursor MCP icon](https://webassets.linear.app/images/ornj730p/production/a2bb8e6a60f530cb07b4c7363301206597b5e8b5-400x400.jpg?w=256&q=95&auto=format&dpr=2)

  Cursor MCP

  By Cursor

  Connect Cursor to the Linear MCP server](cursor-mcp.html)
* [![Visual Studio Code MCP icon](https://webassets.linear.app/images/ornj730p/production/b9bd65818fa0387a381b7253d268518ad53e13c4-2048x2048.png?w=256&q=95&auto=format&dpr=2)

  Visual Studio Code MCP

  By Visual Studio Code

  Connect VS Code to the Linear MCP server](vs-code-mcp.html)

## Build your own integration

Create your own integration with Linear’s API and submit it to the directory.

[Start building](https://linear.app/docs/integration-directory.html#build-your-own)

## Build your own integration

Create your own integration with Linear’s API and submit it to the directory.
