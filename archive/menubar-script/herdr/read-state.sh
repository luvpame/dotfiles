#!/bin/bash

set -euo pipefail

home_dir="${HOME:-}"
user_name="${USER:-${LOGNAME:-}}"

if [[ -z "$home_dir" || -z "$user_name" ]]; then
  exit 0
fi

PATH="$home_dir/.nix-profile/bin:/etc/profiles/per-user/$user_name/bin:/run/current-system/sw/bin:/opt/homebrew/bin:/usr/local/bin:${PATH:-}"

if ! command -v herdr >/dev/null 2>&1 || ! command -v jq >/dev/null 2>&1; then
  exit 0
fi

focus_command="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/focus-agent.sh"

agent_list="$(herdr agent list 2>/dev/null)" || exit 0

tab_list='{"result":{"tabs":[]}}'
if tab_response="$(herdr tab list 2>/dev/null)" && [[ -n "$tab_response" ]]; then
  tab_list="$tab_response"
fi

summary="$(
  jq -er --arg focus_command "$focus_command" --argjson tab_payload "$tab_list" '
    def state_order:
      ["working", "blocked", "done", "idle", "unknown"];

    def header_state_order:
      ["working", "done", "idle", "unknown"];

    def header_prefix:
      "🐏";

    def header_state_rank:
      . as $state
      | header_state_order
      | index($state);

    def state_rank:
      . as $state
      | state_order
      | index($state);

    def normalize_state:
      . as $state
      | if (state_order | index($state)) != null then
          $state
        else
          "unknown"
        end;

    def normalize_text:
      if type != "string" then
        error("invalid schema")
      else
        gsub("[|｜]"; " ")
        | gsub("[[:space:]]+"; " ")
        | sub("^ +"; "")
        | sub(" +$"; "")
        | sub("^-+"; "")
      end;

    def normalize_kind:
      gsub("[×]"; " ")
      | normalize_text
      | if . == "" then "その他" else . end;

    def public_id($id):
      if ($id | type) != "string" then
        false
      else
        ($id | test("^[A-Za-z0-9][A-Za-z0-9_.:-]*$"))
      end;

    def valid_optional_strings:
      ((.display_agent == null) or ((.display_agent | type) == "string"))
      and ((.agent == null) or ((.agent | type) == "string"))
      and ((.title == null) or ((.title | type) == "string"))
      and ((.terminal_title_stripped == null) or ((.terminal_title_stripped | type) == "string"))
      and ((.name == null) or ((.name | type) == "string"));

    def valid_tokens:
      if .tokens == null then
        true
      elif (.tokens | type) != "object" then
        false
      else
        ((.tokens["thread_title"] == null) or ((.tokens["thread_title"] | type) == "string"))
        and ((.tokens["thread-title"] == null) or ((.tokens["thread-title"] | type) == "string"))
        and ((.tokens["task_progress"] == null) or ((.tokens["task_progress"] | type) == "string"))
        and ((.tokens["task-progress"] == null) or ((.tokens["task-progress"] | type) == "string"))
      end;

    def valid_state_labels:
      if .state_labels == null then
        true
      elif (.state_labels | type) != "object" then
        false
      else
        all(.state_labels[]; (type == "string") or (type == "null"))
      end;

    def normalize_agent:
      if ((.agent_status | type) != "string")
         or ((.workspace_id | type) != "string")
         or (public_id(.tab_id) | not)
         or (public_id(.pane_id) | not)
         or (valid_optional_strings | not)
         or (valid_tokens | not)
         or (valid_state_labels | not) then
        error("invalid schema")
      else
        (.agent_status | normalize_state) as $state
        | (.workspace_id | normalize_text) as $workspace
        | ((.display_agent // .agent // "その他") | normalize_kind) as $kind
        | ([
             .tokens["thread_title"],
             .tokens["thread-title"],
             .tokens["task_progress"],
             .tokens["task-progress"],
             .title,
             .terminal_title_stripped,
             .name,
             .pane_id,
             "名称なし"
           ]
           | map(select(. != null) | normalize_text | select(. != ""))
           | .[0] // "名称なし") as $summary_base
        | ((.state_labels.blocked // null)
           | if type == "string" then normalize_text else "" end) as $blocked_label
        | (if $state == "blocked"
              and $blocked_label != ""
              and $blocked_label != "blocked"
              and $blocked_label != "入力待ち"
              and (($summary_base | contains($blocked_label)) | not) then
             "\($summary_base) · \($blocked_label)"
           else
             $summary_base
           end) as $summary
        | {
            state: $state,
            workspace: $workspace,
            kind: $kind,
            summary: $summary,
            tab_id: .tab_id,
            pane_id: .pane_id
          }
      end;

    def normalize_tab:
      if (public_id(.tab_id) | not)
         or ((.workspace_id | type) != "string")
         or ((.label | type) != "string") then
        error("invalid schema")
      else
        {
          tab_id: .tab_id,
          label: (.label | normalize_text)
        }
      end;

    def normalize_tabs:
      if (($tab_payload.result.tabs | type) != "array")
         or any($tab_payload.result.tabs[]; type != "object") then
        error("invalid schema")
      else
        ($tab_payload.result.tabs | map(normalize_tab))
      end;

    def state_meta($state):
      if $state == "working" then
        {icon: "🟢", color: "green"}
      elif $state == "blocked" then
        {icon: "🟠", color: "orange"}
      elif $state == "done" then
        {icon: "✅", color: "blue"}
      elif $state == "idle" then
        {icon: "⚪", color: "gray"}
      else
        {icon: "❔", color: "purple"}
      end;

    def clickable_agent:
      (state_meta(.state)) as $meta
      | "↗ \($meta.icon) \(.summary) · \(.kind) · \(.workspace) | color=\($meta.color) | shell=\($focus_command) | param1=\(.pane_id) | terminal=false | refresh=true";

    (normalize_tabs) as $tabs
    | ($tabs | reduce .[] as $tab ({}; .[$tab.tab_id] = $tab.label)) as $tab_labels
    | .result.agents
    | if type != "array" then
        error("invalid schema")
      elif any(.[]; type != "object") then
        error("invalid schema")
      else
        map(normalize_agent)
      end
    | . as $agents
    | length as $total
    | if $total == 0 then
        "\(header_prefix) | dropdown=false"
      else
        ($agents | map(.workspace) | unique | length) as $workspace_count
        | ($agents | map(select(.state == "blocked")) | length) as $blocked_count
        | (if $blocked_count > 0 then
             ($agents
              | map(select(.state == "blocked"))
              | group_by(.tab_id)
              | map(
                  . as $tab_agents
                  | ($tab_agents | sort_by([.summary, .pane_id]) | .[0].summary) as $fallback
                  | ($tab_labels[$tab_agents[0].tab_id] // "") as $label
                  | {
                      tab_id: $tab_agents[0].tab_id,
                      header: (if $label != "" then $label else $fallback end)
                    }
                )
              | sort_by([.header, .tab_id])
              | to_entries
              | . as $blocked_tabs
              | map(
                  if ($blocked_tabs | length) > 1 then
                    "\(header_prefix) 🟠 \(.key + 1)/\($blocked_tabs | length) \(.value.header) | color=orange | dropdown=false | length=36"
                  else
                    "\(header_prefix) 🟠 \(.value.header) | color=orange | dropdown=false | length=36"
                  end
                ))
           else
             ($agents
              | sort_by([(.state | header_state_rank), .summary, .kind, .workspace, .pane_id])) as $header_agents
             | ($header_agents | length) as $header_total
             | ($header_agents
                | to_entries
                | map(
                    . as $entry
                    | (state_meta($entry.value.state)) as $meta
                    | if $header_total > 1 then
                        "\(header_prefix) \($meta.icon) \($entry.key + 1)/\($header_total) \($entry.value.summary) | color=\($meta.color) | dropdown=false | length=36"
                      else
                        "\(header_prefix) \($meta.icon) \($entry.value.summary) | color=\($meta.color) | dropdown=false | length=36"
                      end
                  ))
           end) as $headers
        | ($agents
           | sort_by([(.state | state_rank), .summary, .kind, .workspace, .pane_id])
           | map(clickable_agent)) as $agent_lines
        | ($agents
           | map(.kind)
           | group_by(.)
           | sort_by(.[0])
           | map("\(.[0]) ×\(length)")
           | join(" · ")) as $kind_counts
        | ($headers + [
             "---",
             "Herdr · \($total) agents · \($workspace_count) workspaces | color=gray",
             "---"
           ] + $agent_lines + [
             "---",
             "\($kind_counts) | color=gray"
           ] | join("\n"))
      end
  ' <<< "$agent_list" 2>/dev/null
)" || exit 0

if [[ -n "$summary" ]]; then
  printf '%s\n' "$summary"
fi
