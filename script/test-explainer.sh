#!/bin/bash
set -euo pipefail

explainer_bin="${1:-$(command -v explainer)}"
test_dir="$(mktemp -d)"
trap 'rm -rf "$test_dir"' EXIT
cd "$test_dir"

# 図を置くプロジェクトの依存ではなく、固定した実行環境を使うことを確認する。
printf '%s\n' '{"name":"fixture","dependencies":{"playwright":"0.0.0"}}' >package.json
cat >valid.svg <<'SVG'
<svg xmlns="http://www.w3.org/2000/svg" width="360" height="120" viewBox="0 0 360 120" role="img" aria-labelledby="title desc">
  <title id="title">長いファイル名</title>
  <desc id="desc">ファイル名を全文のまま二行に分け、枠内に表示する。</desc>
  <rect width="360" height="120" fill="#fff"/>
  <rect x="20" y="20" width="320" height="80" fill="#fff" stroke="#0055ed"/>
  <text x="36" y="48" fill="#17202e" font-family="monospace" font-size="16"><tspan x="36" dy="0">api_admin_inspection_</tspan><tspan x="36" dy="24">reviews.yaml</tspan></text>
</svg>
SVG
printf '%s\n' '{"labels":["api_admin_inspection_reviews.yaml"],"forbidden":[]}' >valid.facts.json

"$explainer_bin" setup --dry-run >setup.log
"$explainer_bin" run figure-check.mjs valid.svg --facts valid.facts.json --out valid-check | tee valid.log
rg -q 'figure verdict: CLEAN' valid.log

# 同じラベルを枠の右辺に移すと、はみ出しを検出して失敗する。
sed 's/x="36"/x="320"/g' valid.svg >invalid.svg
if "$explainer_bin" run figure-check.mjs invalid.svg --facts valid.facts.json --out invalid-check >invalid.log; then
  printf 'Expected overflow detection to fail.\n' >&2
  exit 1
fi
rg -q 'cross a box edge|outside the figure' invalid.log
printf 'explainer: 固定環境での描画・正常図の通過・はみ出しの検出 OK\n'
