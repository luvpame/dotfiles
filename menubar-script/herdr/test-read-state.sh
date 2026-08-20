#!/bin/bash

set -euo pipefail

readonly script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly target="$script_dir/read-state.sh"
readonly focus_command="$script_dir/focus-agent.sh"

herdr() {
  if [[ "${HERDR_FAIL:-false}" == "true" ]]; then
    return 1
  fi

  if [[ "$*" == "agent list" ]]; then
    printf '%s\n' "${HERDR_RESPONSE:-}"
    return 0
  fi

  if [[ "$*" == "tab list" ]]; then
    if [[ "${HERDR_TAB_FAIL:-false}" == "true" ]]; then
      return 1
    fi

    printf '%s\n' "${HERDR_TAB_RESPONSE:-}"
    return 0
  fi

  return 2
}
export -f herdr

run_target() {
  run_target_with_tabs "$1" ""
}

run_target_with_tabs() {
  local response="$1"
  local tab_response="$2"
  local tab_fail="${3:-false}"

  HERDR_FAIL=false HERDR_RESPONSE="$response" HERDR_TAB_FAIL="$tab_fail" HERDR_TAB_RESPONSE="$tab_response" "$target"
}

assert_output() {
  local description="$1"
  local expected="$2"
  local response="$3"
  local actual

  actual="$(run_target "$response")"

  if [[ "$actual" != "$expected" ]]; then
    printf 'FAIL: %s\nexpected: <%s>\nactual: <%s>\n' "$description" "$expected" "$actual" >&2
    exit 1
  fi
}

assert_contains() {
  local description="$1"
  local expected="$2"
  local response="$3"
  local actual

  actual="$(run_target "$response")"

  if [[ "$actual" != *"$expected"* ]]; then
    printf 'FAIL: %s\nexpected substring: <%s>\nactual: <%s>\n' "$description" "$expected" "$actual" >&2
    exit 1
  fi
}

assert_output_with_tabs() {
  local description="$1"
  local expected="$2"
  local response="$3"
  local tab_response="$4"
  local tab_fail="${5:-false}"
  local actual

  actual="$(run_target_with_tabs "$response" "$tab_response" "$tab_fail")"

  if [[ "$actual" != "$expected" ]]; then
    printf 'FAIL: %s\nexpected: <%s>\nactual: <%s>\n' "$description" "$expected" "$actual" >&2
    exit 1
  fi
}

assert_contains_with_tabs() {
  local description="$1"
  local expected="$2"
  local response="$3"
  local tab_response="$4"
  local tab_fail="${5:-false}"
  local actual

  actual="$(run_target_with_tabs "$response" "$tab_response" "$tab_fail")"

  if [[ "$actual" != *"$expected"* ]]; then
    printf 'FAIL: %s\nexpected substring: <%s>\nactual: <%s>\n' "$description" "$expected" "$actual" >&2
    exit 1
  fi
}

assert_empty_with_tabs() {
  assert_output_with_tabs "$1" "" "$2" "$3"
}

assert_empty() {
  assert_output "$1" "" "$2"
}

assert_flat_agent_rows() {
  local description="$1"
  local response="$2"
  local actual

  actual="$(run_target "$response")"

  while IFS= read -r line; do
    case "$line" in
      '↗ '*)
        case "$line" in
          '↗ 🟢 '*|'↗ 🟠 '*|'↗ ✅ '*|'↗ ⚪ '*|'↗ ❔ '*) ;;
          *)
            printf 'FAIL: %s\ninvalid agent row: <%s>\n' "$description" "$line" >&2
            exit 1
            ;;
        esac
        ;;
    esac
  done <<< "$actual"

  if [[ "$actual" == *$'\n--↗'* \
     || "$actual" == *$'\n🟢 作業中 '* \
     || "$actual" == *$'\n🟠 入力待ち '* \
     || "$actual" == *$'\n✅ 完了 '* \
     || "$actual" == *$'\n⚪ 待機 '* \
     || "$actual" == *$'\n❔ 不明 '* ]]; then
    printf 'FAIL: %s\nactual: <%s>\n' "$description" "$actual" >&2
    exit 1
  fi
}

assert_output \
  "blocked 1件だけをheaderに表示し、nonblocked agentをheaderに混ぜずdropdownのagent行をクリック可能にする" \
  $'🐏 🟠 Need decision · Approval | color=orange | dropdown=false | length=36\n---\nHerdr · 2 agents · 1 workspaces | color=gray\n---\n↗ 🟢 alpha · Codex · ws-a | color=green | shell='"$focus_command"$' | param1=w1:p2 | terminal=false | refresh=true\n↗ 🟠 Need decision · Approval · Codex · ws-a | color=orange | shell='"$focus_command"$' | param1=w1:p1 | terminal=false | refresh=true\n---\nCodex ×2 | color=gray' \
  '{"result":{"agents":[{"agent_status":"blocked","workspace_id":"ws-a","tab_id":"tab-a","pane_id":"w1:p1","display_agent":"Codex","tokens":{"thread_title":"Need decision"},"state_labels":{"blocked":"Approval"}},{"agent_status":"working","workspace_id":"ws-a","tab_id":"tab-a","pane_id":"w1:p2","display_agent":"Codex","name":"alpha"}]}}'

assert_contains_with_tabs \
  "blocked headerはtoken summaryよりtab labelを優先する" \
  $'🐏 🟠 Review PR | color=orange | dropdown=false | length=36' \
  '{"result":{"agents":[{"agent_status":"blocked","workspace_id":"ws-a","tab_id":"tab-a","pane_id":"w1:p1","display_agent":"Codex","tokens":{"thread_title":"Need decision"}}]}}' \
  '{"result":{"tabs":[{"tab_id":"tab-a","workspace_id":"ws-a","label":"Review PR"}]}}'

assert_output_with_tabs \
  "blocked複数tabをtab label辞書順でcycle表示する" \
  $'🐏 🟠 1/2 Alpha tab | color=orange | dropdown=false | length=36\n🐏 🟠 2/2 Zulu tab | color=orange | dropdown=false | length=36\n---\nHerdr · 2 agents · 1 workspaces | color=gray\n---\n↗ 🟠 Alpha summary · Claude · ws-a | color=orange | shell='"$focus_command"$' | param1=w1:p1 | terminal=false | refresh=true\n↗ 🟠 Zeta summary · Claude · ws-a | color=orange | shell='"$focus_command"$' | param1=w1:p3 | terminal=false | refresh=true\n---\nClaude ×2 | color=gray' \
  '{"result":{"agents":[{"agent_status":"blocked","workspace_id":"ws-a","tab_id":"tab-b","pane_id":"w1:p3","display_agent":"Claude","title":"Zeta summary"},{"agent_status":"blocked","workspace_id":"ws-a","tab_id":"tab-a","pane_id":"w1:p1","display_agent":"Claude","title":"Alpha summary"}]}}' \
  '{"result":{"tabs":[{"tab_id":"tab-b","workspace_id":"ws-a","label":"Zulu tab"},{"tab_id":"tab-a","workspace_id":"ws-a","label":"Alpha tab"}]}}'

assert_output_with_tabs \
  "同一tabの複数blocked agentはheaderを1行にまとめる" \
  $'🐏 🟠 Review PR | color=orange | dropdown=false | length=36\n---\nHerdr · 2 agents · 1 workspaces | color=gray\n---\n↗ 🟠 Alpha summary · Claude · ws-a | color=orange | shell='"$focus_command"$' | param1=w1:p1 | terminal=false | refresh=true\n↗ 🟠 Zeta summary · Claude · ws-a | color=orange | shell='"$focus_command"$' | param1=w1:p3 | terminal=false | refresh=true\n---\nClaude ×2 | color=gray' \
  '{"result":{"agents":[{"agent_status":"blocked","workspace_id":"ws-a","tab_id":"tab-a","pane_id":"w1:p3","display_agent":"Claude","title":"Zeta summary"},{"agent_status":"blocked","workspace_id":"ws-a","tab_id":"tab-a","pane_id":"w1:p1","display_agent":"Claude","title":"Alpha summary"}]}}' \
  '{"result":{"tabs":[{"tab_id":"tab-a","workspace_id":"ws-a","label":"Review PR"}]}}'

assert_contains_with_tabs \
  "空のtab labelはblocked agent summaryへfallbackする" \
  $'🐏 🟠 Need decision · Approval | color=orange | dropdown=false | length=36' \
  '{"result":{"agents":[{"agent_status":"blocked","workspace_id":"ws-a","tab_id":"tab-a","pane_id":"w1:p1","display_agent":"Codex","tokens":{"thread_title":"Need decision"},"state_labels":{"blocked":"Approval"}}]}}' \
  '{"result":{"tabs":[{"tab_id":"tab-a","workspace_id":"ws-a","label":"   "}]}}'

assert_contains_with_tabs \
  "見つからないtabはblocked agent summaryへfallbackする" \
  $'🐏 🟠 Need decision · Approval | color=orange | dropdown=false | length=36' \
  '{"result":{"agents":[{"agent_status":"blocked","workspace_id":"ws-a","tab_id":"tab-a","pane_id":"w1:p1","display_agent":"Codex","tokens":{"thread_title":"Need decision"},"state_labels":{"blocked":"Approval"}}]}}' \
  '{"result":{"tabs":[{"tab_id":"tab-other","workspace_id":"ws-a","label":"Other tab"}]}}'

assert_empty_with_tabs \
  "tab schemaが不正なら空出力" \
  '{"result":{"agents":[{"agent_status":"working","workspace_id":"ws-a","tab_id":"tab-a","pane_id":"w1:p1","display_agent":"Codex","title":"Working"}]}}' \
  '{"result":{"tabs":[{"tab_id":"tab-a","workspace_id":"ws-a","label":true}]}}'

assert_contains_with_tabs \
  "tab list失敗時はblocked agent summaryへfallbackする" \
  $'🐏 🟠 Need decision · Approval | color=orange | dropdown=false | length=36' \
  '{"result":{"agents":[{"agent_status":"blocked","workspace_id":"ws-a","tab_id":"tab-a","pane_id":"w1:p1","display_agent":"Codex","tokens":{"thread_title":"Need decision"},"state_labels":{"blocked":"Approval"}}]}}' \
  '{"result":{"tabs":[{"tab_id":"tab-a","workspace_id":"ws-a","label":"Review PR"}]}}' \
  true

assert_output \
  "blocked複数件のheaderをsummary順でcycle表示する" \
  $'🐏 🟠 1/2 Alpha | color=orange | dropdown=false | length=36\n🐏 🟠 2/2 Zeta | color=orange | dropdown=false | length=36\n---\nHerdr · 2 agents · 1 workspaces | color=gray\n---\n↗ 🟠 Alpha · Claude · ws-a | color=orange | shell='"$focus_command"$' | param1=w1:p1 | terminal=false | refresh=true\n↗ 🟠 Zeta · Claude · ws-a | color=orange | shell='"$focus_command"$' | param1=w1:p3 | terminal=false | refresh=true\n---\nClaude ×2 | color=gray' \
  '{"result":{"agents":[{"agent_status":"blocked","workspace_id":"ws-a","tab_id":"tab-b","pane_id":"w1:p3","display_agent":"Claude","title":"Zeta"},{"agent_status":"blocked","workspace_id":"ws-a","tab_id":"tab-a","pane_id":"w1:p1","display_agent":"Claude","name":"Alpha"}]}}'

assert_contains \
  "doneだけならsession summary header" \
  $'🐏 ✅ Complete | color=blue | dropdown=false | length=36' \
  '{"result":{"agents":[{"agent_status":"done","workspace_id":"ws-a","tab_id":"tab-a","pane_id":"w1:p1","display_agent":"Codex","title":"Complete"}]}}'

assert_contains \
  "workingだけならsession summary header" \
  $'🐏 🟢 Working | color=green | dropdown=false | length=36' \
  '{"result":{"agents":[{"agent_status":"working","workspace_id":"ws-a","tab_id":"tab-a","pane_id":"w1:p1","display_agent":"Codex","title":"Working"}]}}'

assert_contains \
  "idleだけならsession summary header" \
  $'🐏 ⚪ Idle | color=gray | dropdown=false | length=36' \
  '{"result":{"agents":[{"agent_status":"idle","workspace_id":"ws-a","tab_id":"tab-a","pane_id":"w1:p1","display_agent":"Codex","title":"Idle"}]}}'

assert_output \
  "agent 0件でも羊headerを表示する" \
  $'🐏 | dropdown=false' \
  '{"result":{"agents":[]}}'

assert_contains \
  "summaryはthread_titleを最優先する" \
  $'↗ 🟢 thread · Codex · ws-a' \
  '{"result":{"agents":[{"agent_status":"working","workspace_id":"ws-a","tab_id":"tab-a","pane_id":"w1:p1","display_agent":"Codex","tokens":{"thread_title":"thread","thread-title":"hyphen","task_progress":"progress","task-progress":"hyphen-progress"},"title":"title","terminal_title_stripped":"terminal","name":"name"}]}}'

assert_contains \
  "summaryはthread-titleへfallbackする" \
  $'↗ 🟢 hyphen · Codex · ws-a' \
  '{"result":{"agents":[{"agent_status":"working","workspace_id":"ws-a","tab_id":"tab-a","pane_id":"w1:p1","display_agent":"Codex","tokens":{"thread_title":"","thread-title":"hyphen"}}]}}'

assert_contains \
  "summaryはtask_progressへfallbackする" \
  $'↗ 🟢 progress · Codex · ws-a' \
  '{"result":{"agents":[{"agent_status":"working","workspace_id":"ws-a","tab_id":"tab-a","pane_id":"w1:p1","display_agent":"Codex","tokens":{"thread_title":"","thread-title":"","task_progress":"progress"}}]}}'

assert_contains \
  "summaryはtask-progressへfallbackする" \
  $'↗ 🟢 hyphen-progress · Codex · ws-a' \
  '{"result":{"agents":[{"agent_status":"working","workspace_id":"ws-a","tab_id":"tab-a","pane_id":"w1:p1","display_agent":"Codex","tokens":{"task_progress":"","task-progress":"hyphen-progress"}}]}}'

assert_contains \
  "summaryはtitleへfallbackする" \
  $'↗ 🟢 title · Codex · ws-a' \
  '{"result":{"agents":[{"agent_status":"working","workspace_id":"ws-a","tab_id":"tab-a","pane_id":"w1:p1","display_agent":"Codex","title":"title"}]}}'

assert_contains \
  "summaryはterminal titleへfallbackする" \
  $'↗ 🟢 terminal · Codex · ws-a' \
  '{"result":{"agents":[{"agent_status":"working","workspace_id":"ws-a","tab_id":"tab-a","pane_id":"w1:p1","display_agent":"Codex","terminal_title_stripped":"terminal"}]}}'

assert_contains \
  "summaryはnameへfallbackする" \
  $'↗ 🟢 name · Codex · ws-a' \
  '{"result":{"agents":[{"agent_status":"working","workspace_id":"ws-a","tab_id":"tab-a","pane_id":"w1:p1","display_agent":"Codex","name":"name"}]}}'

assert_contains \
  "summaryはpane_idへfallbackする" \
  $'↗ 🟢 w1:p1 · Codex · ws-a' \
  '{"result":{"agents":[{"agent_status":"working","workspace_id":"ws-a","tab_id":"tab-a","pane_id":"w1:p1","display_agent":"Codex"}]}}'

assert_contains \
  "summaryとworkspaceをXBar向けに正規化する" \
  $'↗ 🟢 A B C · Claude Test · ws id | color=green' \
  '{"result":{"agents":[{"agent_status":"working","workspace_id":"ws | id","tab_id":"tab-a","pane_id":"w1:p1","display_agent":"  Claude   Test  ","title":"  ---A | B\nC  "}]}}'

assert_output \
  "blockedなしのmixed 4 agentsをstate順とsummary順でheader cycleする" \
  $'🐏 🟢 1/4 Zeta | color=green | dropdown=false | length=36\n🐏 ✅ 2/4 Alpha | color=blue | dropdown=false | length=36\n🐏 ⚪ 3/4 Beta | color=gray | dropdown=false | length=36\n🐏 ❔ 4/4 Gamma | color=purple | dropdown=false | length=36\n---\nHerdr · 4 agents · 1 workspaces | color=gray\n---\n↗ 🟢 Zeta · Codex · ws-a | color=green | shell='"$focus_command"$' | param1=w1:p1 | terminal=false | refresh=true\n↗ ✅ Alpha · Claude · ws-a | color=blue | shell='"$focus_command"$' | param1=w1:p2 | terminal=false | refresh=true\n↗ ⚪ Beta · Codex · ws-a | color=gray | shell='"$focus_command"$' | param1=w1:p3 | terminal=false | refresh=true\n↗ ❔ Gamma · Other · ws-a | color=purple | shell='"$focus_command"$' | param1=w1:p4 | terminal=false | refresh=true\n---\nClaude ×1 · Codex ×2 · Other ×1 | color=gray' \
  '{"result":{"agents":[{"agent_status":"idle","workspace_id":"ws-a","tab_id":"tab-a","pane_id":"w1:p3","display_agent":"Codex","title":"Beta"},{"agent_status":"waiting","workspace_id":"ws-a","tab_id":"tab-a","pane_id":"w1:p4","display_agent":"Other","title":"Gamma"},{"agent_status":"done","workspace_id":"ws-a","tab_id":"tab-a","pane_id":"w1:p2","display_agent":"Claude","title":"Alpha"},{"agent_status":"working","workspace_id":"ws-a","tab_id":"tab-a","pane_id":"w1:p1","display_agent":"Codex","title":"Zeta"}]}}'

assert_flat_agent_rows \
  "dropdownのagent行はroot直下のクリック可能な平坦リストにする" \
  '{"result":{"agents":[{"agent_status":"idle","workspace_id":"ws-a","tab_id":"tab-a","pane_id":"w1:p3","display_agent":"Codex","title":"Beta"},{"agent_status":"waiting","workspace_id":"ws-a","tab_id":"tab-a","pane_id":"w1:p4","display_agent":"Other","title":"Gamma"},{"agent_status":"done","workspace_id":"ws-a","tab_id":"tab-a","pane_id":"w1:p2","display_agent":"Claude","title":"Alpha"},{"agent_status":"working","workspace_id":"ws-a","tab_id":"tab-a","pane_id":"w1:p1","display_agent":"Codex","title":"Zeta"}]}}'

assert_contains \
  "agent 1件ならheaderの番号を省略する" \
  $'🐏 ✅ Solo | color=blue | dropdown=false | length=36\n---' \
  '{"result":{"agents":[{"agent_status":"done","workspace_id":"ws-a","tab_id":"tab-a","pane_id":"w1:p1","display_agent":"Codex","title":"Solo"}]}}'

assert_output \
  "agentのsort順をsummaryで安定化する" \
  $'🐏 🟢 1/2 alpha | color=green | dropdown=false | length=36\n🐏 🟢 2/2 zeta | color=green | dropdown=false | length=36\n---\nHerdr · 2 agents · 1 workspaces | color=gray\n---\n↗ 🟢 alpha · Codex · ws-a | color=green | shell='"$focus_command"$' | param1=w1:p1 | terminal=false | refresh=true\n↗ 🟢 zeta · Codex · ws-a | color=green | shell='"$focus_command"$' | param1=w1:p2 | terminal=false | refresh=true\n---\nCodex ×2 | color=gray' \
  '{"result":{"agents":[{"agent_status":"working","workspace_id":"ws-a","tab_id":"tab-a","pane_id":"w1:p2","display_agent":"Codex","name":"zeta"},{"agent_status":"working","workspace_id":"ws-a","tab_id":"tab-a","pane_id":"w1:p1","display_agent":"Codex","name":"alpha"}]}}'

assert_contains \
  "unknown状態を不明として表示する" \
  $'🐏 ❔ unknown | color=purple | dropdown=false | length=36\n---\nHerdr · 1 agents · 1 workspaces | color=gray\n---\n↗ ❔ unknown · その他 · ws-a' \
  '{"result":{"agents":[{"agent_status":"waiting","workspace_id":"ws-a","tab_id":"tab-a","pane_id":"w1:p1","name":"unknown"}]}}'

assert_empty \
  "pane_idが欠落したschemaは空出力" \
  '{"result":{"agents":[{"agent_status":"working","workspace_id":"ws-a","tab_id":"tab-a"}]}}'

assert_empty \
  "tab_idが欠落したschemaは空出力" \
  '{"result":{"agents":[{"agent_status":"working","workspace_id":"ws-a","pane_id":"w1:p1"}]}}'

assert_empty \
  "tab_idにshell meta文字があれば空出力" \
  '{"result":{"agents":[{"agent_status":"working","workspace_id":"ws-a","tab_id":"tab;p1","pane_id":"w1:p1"}]}}'

assert_empty \
  "pane_idが不正型のschemaは空出力" \
  '{"result":{"agents":[{"agent_status":"working","workspace_id":"ws-a","tab_id":"tab-a","pane_id":true}]}}'

assert_empty \
  "pane_idにshell meta文字があれば空出力" \
  '{"result":{"agents":[{"agent_status":"working","workspace_id":"ws-a","tab_id":"tab-a","pane_id":"w1;p1"}]}}'

assert_empty \
  "tokensの候補値が不正型なら空出力" \
  '{"result":{"agents":[{"agent_status":"working","workspace_id":"ws-a","tab_id":"tab-a","pane_id":"w1:p1","tokens":{"thread_title":true}}]}}'

assert_empty \
  "state_labelsが不正型なら空出力" \
  '{"result":{"agents":[{"agent_status":"working","workspace_id":"ws-a","tab_id":"tab-a","pane_id":"w1:p1","state_labels":[]}]}}'

assert_empty \
  "result.agentsがなければ空出力" \
  '{"result":{}}'

assert_empty \
  "不正JSONは空出力" \
  '{'

actual="$(HERDR_FAIL=true "$target")"
if [[ -n "$actual" ]]; then
  printf 'FAIL: CLI取得失敗時は空出力\nactual: <%s>\n' "$actual" >&2
  exit 1
fi

printf 'PASS\n'
