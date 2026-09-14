---
name: obsidian
description: Manage an Obsidian vault through the local `obsidian` CLI. Use when the user wants vault notes or metadata queried or changed, Obsidian UI state controlled, plugins or themes managed, or Obsidian developer state inspected.
---

# Obsidian CLI

Treat the installed CLI help as the **live schema**. Its commands can change with the Obsidian version and enabled plugins.

## Procedure

1. Read the live schema before choosing a command:

   ```bash
   obsidian --help
   obsidian help <command>
   ```

   Continue once the selected command and every planned option appear in the current help output. Plugin-provided commands are valid when they appear there.

2. Pin the target vault:

   ```bash
   obsidian vaults verbose
   ```

   Resolve the vault from an explicit user choice, then from the current working directory falling inside a listed vault path, then from a single listed vault. Stop when an explicitly named vault is not listed. Ask which vault to use when more than one candidate remains.

   After resolving the vault, pass `vault="<name>"` to every command that reads or changes vault state. Schema commands such as `obsidian help <command>` do not target a vault.

3. Pin note targets before changing them. Prefer `path=` after the exact vault-relative path is known. Use `file=` when name-based wikilink resolution is intentional. When the user refers to the active note, resolve it first:

   ```bash
   obsidian file vault="<name>"
   ```

   Continue once every changing command has an explicit vault and, when applicable, an exact path.

4. Inspect the current state with the narrowest read command, perform the requested operation, then inspect the affected state again. Completion requires observing the requested state through a read-only CLI command.

## Command selection

Use `obsidian help <command>` to load details for the relevant branch:

- Discover content with `files`, `folders`, `search`, and `search:context`; inspect notes with `read`, `file`, `outline`, and `wordcount`.
- Inspect relationships with `links`, `backlinks`, `aliases`, `tags`, `orphans`, `deadends`, and `unresolved`.
- Change notes with `create`, `append`, `prepend`, `move`, `rename`, and `delete`; use the `daily:*` and `template:*` commands for their specialized workflows.
- Work with structured data through `properties`, `property:*`, `tasks`, `task`, `bases`, and `base:*`.
- Control visible application state through `open`, `tabs`, `tab:open`, `workspace`, `command`, `reload`, and `restart`. Resolve an arbitrary command ID with `commands` before invoking `command`.
- Manage extensions and appearance through `plugins`, `plugin:*`, `snippets`, `snippet:*`, `themes`, and `theme:*`.
- Inspect recovery or synchronization state through `history`, `history:*`, and `diff`.
- Use `dev:*`, `devtools`, and `eval` for Obsidian development. Choose a structured CLI command whenever it covers the task; otherwise keep an `eval` expression narrowly scoped to the requested result.

Request machine-readable output with `format=json` only when the live schema offers it. Use compact scalar options such as `total`, `words`, or `characters` when the user needs only that value.

## Mutation boundaries

- Read a note before replacing it. Add `overwrite` only after the user has authorized replacing the resolved target.
- Send deleted files to Obsidian's trash by omitting `permanent`. Add `permanent` only when the user explicitly requests irreversible deletion of the resolved target.
- Inspect the exact plugin, theme, history version, command ID, task reference, or destination before an install, uninstall, restore, execution, status change, move, or rename.
- Ask for direction when the requested outcome does not authorize an irreversible, replacement, or application-wide change.

## Shell arguments

Pass options as `key=value` arguments and quote values for the active shell. Preserve `\n` and `\t` escapes when supplying content.

```bash
obsidian search vault="Work" query="release checklist" format=json
obsidian read vault="Work" path="Projects/Release.md"
obsidian append vault="Work" path="Projects/Release.md" content="\n- [ ] Verify rollout"
```

If name-based resolution is ambiguous, use the discovery commands to obtain the vault-relative path and retry with `path=`. If a command or option is rejected, return to the live schema instead of guessing a replacement.
