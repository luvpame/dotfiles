---
title: "Codex MCP Integration – Linear"
source_url: "https://linear.app/integrations/codex-mcp"
fetched_at: "2026-10-27T08:17:41.028425+00:00"
---



1. [Integrations](https://linear.app/integrations.html)
2. Codex MCP

# Connect Codex to the Linear MCP server

![An illustration showing the Codex logo](https://webassets.linear.app/images/ornj730p/production/6920ad793dc1df09a794c339d6dbe7325e6bacd5-3000x1920.png?q=95&auto=format&dpr=2)

![An illustration showing the Codex logo](https://webassets.linear.app/images/ornj730p/production/6920ad793dc1df09a794c339d6dbe7325e6bacd5-3000x1920.png?q=95&auto=format&dpr=2)

## Overview[⁠](https://linear.app/integrations/codex-mcp.html#overview)

Codex is a coding agent that works everywhere you do. Connecting Linear’s MCP server to the [Codex CLI](https://developers.openai.com/codex/cli/) or [Codex IDE Extension](https://developers.openai.com/codex/ide/) gives Codex access to gain context from your existing issues or create new issues without the need to copy & paste.

You can only use the MCP server for [local Codex tasks](https://developers.openai.com/codex/concepts/) using the CLI or IDE Extension.

## Setup instructions[⁠](https://linear.app/integrations/codex-mcp.html#setup-instructions)

The setup steps for the MCP server are the same regardless of whether you use the IDE Extension or the CLI since the configuration is shared.

### Preferred: using the CLI[⁠](https://linear.app/integrations/codex-mcp.html#preferred:-using-the-cli)

If you have the CLI installed you can run the following command:

```
codex mcp add linear --url https://mcp.linear.app/mcp
```

This will automatically prompt you to log in with your Linear account and connect it to your Codex.

**Note:** If this is the first time you are using an MCP in Codex you will need to enable the rmcp feature for this to work. Add the following into your `~/.codex/config.toml`:

```
[features]
rmcp_client = true
```

### Manual set up[⁠](https://linear.app/integrations/codex-mcp.html#manual-set-up)

1. Open the ~/.codex/config.toml file in your preferred editor
2. Add the following:

```
[features]
rmcp_client = true

[mcp_servers.linear]
url = "https://mcp.linear.app/mcp"
```

Then Run `codex mcp login linear` to log in.

Website
[developers.openai.com](https://developers.openai.com/codex/mcp)

Category
[AI clients](https://linear.app/integrations/ai-clients.html)

[Open website](https://developers.openai.com/codex/mcp)

#### You might be interested in

[Browse all integrations](https://linear.app/integrations.html)

* [![Codex icon](https://webassets.linear.app/images/ornj730p/production/a7789d9c4baa178dc6043070519e7e32b238bffa-980x980.jpg?w=256&q=95&auto=format&dpr=2)

  Codex

  By OpenAI

  Delegate issues to Codex directly from Linear](codex.html)
* [![Cursor MCP icon](https://webassets.linear.app/images/ornj730p/production/a2bb8e6a60f530cb07b4c7363301206597b5e8b5-400x400.jpg?w=256&q=95&auto=format&dpr=2)

  Cursor MCP

  By Cursor

  Connect Cursor to the Linear MCP server](cursor-mcp.html)
* [![ChatGPT icon](https://webassets.linear.app/images/ornj730p/production/a7789d9c4baa178dc6043070519e7e32b238bffa-980x980.jpg?w=256&q=95&auto=format&dpr=2)

  ChatGPT

  By OpenAI

  Connect ChatGPT deep research to Linear](chatgpt.html)

## Build your own integration

Create your own integration with Linear’s API and submit it to the directory.

[Start building](https://linear.app/docs/integration-directory.html#build-your-own)

## Build your own integration

Create your own integration with Linear’s API and submit it to the directory.
