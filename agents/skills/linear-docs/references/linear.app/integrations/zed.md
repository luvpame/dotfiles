---
title: "Zed Integration – Linear"
source_url: "https://linear.app/integrations/zed"
fetched_at: "2026-10-27T08:17:41.028425+00:00"
---



1. [Integrations](https://linear.app/integrations.html)
2. Zed

# Connect Zed to the Linear MCP server

![Linear and Zed logos](https://webassets.linear.app/images/ornj730p/production/7a0abbff147338e0b28b6d3c3143770b435e6d71-1760x924.png?q=95&auto=format&dpr=2)

![Linear and Zed logos](https://webassets.linear.app/images/ornj730p/production/7a0abbff147338e0b28b6d3c3143770b435e6d71-1760x924.png?q=95&auto=format&dpr=2)

### Overview[⁠](https://linear.app/integrations/zed/index.html#overview)

Zed is a fast, multiplayer code editor with a built-in agentic AI interface. Point Zed at Linear’s MCP server and your in-editor chats can instantly pull information or open new issues without leaving Zed.

### Setup instructions[⁠](https://linear.app/integrations/zed/index.html#setup-instructions)

1. `CMD`  `,` to open Zed settings.
2. Add the following:

```
{
  "context_servers": {
    "linear": {
      "command": {
        "path": "npx",
        "args": ["-y", "mcp-remote", "https://mcp.linear.app/mcp"],
        "env": {}
      },
      "settings": {}
    }
  }
}
```

*Remote MCP connections are still early and we’ve found that the connection may fail or require multiple attempts. If you experience issues, try restarting your client or disabling and re-enabling the Linear MCP server.*

Website
[zed.dev](https://zed.dev)

Category
[AI clients](https://linear.app/integrations/ai-clients.html)

[Add to Linear](https://linear.app/docs/mcp.html#zed)

#### You might be interested in

[Browse all integrations](https://linear.app/integrations.html)

* [![Visual Studio Code MCP icon](https://webassets.linear.app/images/ornj730p/production/b9bd65818fa0387a381b7253d268518ad53e13c4-2048x2048.png?w=256&q=95&auto=format&dpr=2)

  Visual Studio Code MCP

  By Visual Studio Code

  Connect VS Code to the Linear MCP server](vs-code-mcp.html)

## Build your own integration

Create your own integration with Linear’s API and submit it to the directory.

[Start building](https://linear.app/docs/integration-directory.html#build-your-own)

## Build your own integration

Create your own integration with Linear’s API and submit it to the directory.
