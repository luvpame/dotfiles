---
name: agent-browser
description: Use agent-browser for interactive web UI work such as clicking controls, filling forms, taking screenshots, or verifying browser-rendered behavior. Invoke it for browser interaction, not ordinary web search or text-only documentation lookup.
---

# agent-browser

Use this skill when the task requires an interactive browser session to operate or verify a web UI.

Before using the CLI, load the instructions bundled with the installed version:

```bash
agent-browser skills get core
```

Follow the returned instructions for the rest of the browser task. This skill is only a trigger and loader; the bundled procedure is the source of truth.

## Cage on macOS

When `IN_CAGE=1`, reuse the agent-browser daemon prewarmed by the standard aliases.
Do not run `agent-browser close`: Cage cannot relaunch Chrome after it closes, so let idle cleanup reclaim it.
If no daemon is available, keep the boundary intact and ask the user to restart through a standard alias.
