---
title: "Cursor MCP Integration – Linear"
source_url: "https://linear.app/integrations/cursor-mcp"
fetched_at: "2026-10-27T08:17:41.028425+00:00"
---



1. [Integrations](https://linear.app/integrations.html)
2. Cursor MCP

# Connect Cursor to the Linear MCP server

![Linear and Cursor logo on a black background](https://webassets.linear.app/images/ornj730p/production/2da2806c4dac5fcfca1da805fba87da6cdfde453-1760x924.png?q=95&auto=format&dpr=2)

![Linear and Cursor logo on a black background](https://webassets.linear.app/images/ornj730p/production/2da2806c4dac5fcfca1da805fba87da6cdfde453-1760x924.png?q=95&auto=format&dpr=2)

### Overview[⁠](https://linear.app/integrations/cursor-mcp.html#overview)

Cursor is a code editor designed for AI-assisted development. Connecting Linear’s MCP server lets Cursor’s inline agent open context from your issues or create new issues without leaving the IDE.

### Setup instructions[⁠](https://linear.app/integrations/cursor-mcp.html#setup-instructions)

1. `CTRL/CMD`  `Shift`  `J` to open Cursor Settings.
2. Select **MCP**.
3. Select **Add new global MCP server**.
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
[cursor.com](https://www.cursor.com)

Category
[AI clients](https://linear.app/integrations/ai-clients.html)

[Add to Linear](https://linear.app/docs/mcp.html#cursor)

#### You might be interested in

[Browse all integrations](https://linear.app/integrations.html)

* [![Claude  icon](https://webassets.linear.app/images/ornj730p/production/b95ad5ddcb4b835b54ba093d237df7e019a9cb76-338x338.png?w=256&q=95&auto=format&dpr=2)

  Claude

  By Claude

  Connect Claude to the Linear MCP server](claude.html)
* [![Visual Studio Code MCP icon](https://webassets.linear.app/images/ornj730p/production/b9bd65818fa0387a381b7253d268518ad53e13c4-2048x2048.png?w=256&q=95&auto=format&dpr=2)

  Visual Studio Code MCP

  By Visual Studio Code

  Connect VS Code to the Linear MCP server](vs-code-mcp.html)
* [![Zed icon](https://webassets.linear.app/images/ornj730p/production/2f4d92efd0892885043f6f47141099f2de223cb0-400x400.jpg?w=256&q=95&auto=format&dpr=2)

  Zed

  By Zed

  Connect Zed to the Linear MCP server](zed/index.html)

## Build your own integration

Create your own integration with Linear’s API and submit it to the directory.

[Start building](https://linear.app/docs/integration-directory.html#build-your-own)

## Build your own integration

Create your own integration with Linear’s API and submit it to the directory.
