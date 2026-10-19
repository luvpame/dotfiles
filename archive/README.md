# Archive

使用を終了した設定を、再利用や変更履歴の参照に備えて保存する。
このディレクトリ以下のファイルは、現行設定として配布しない。

## 退避ルール

1. 移動前に `nix/nix-darwin/home-manager/files.nix` を確認し、Home Manager が参照するリポジトリ内のパスと配置先を特定する。
2. Home Manager の配置宣言を削除し、同じ位置へ `archive/` 以下の退避先を示す一行コメントを残す。
3. 退避した設定は `archive/<tool>/` に保存し、現行の起動経路やパッケージ宣言から参照しない。

## Cage

`cage/presets.yaml` は、Claude Code と Codex の書き込み先を Cage で制限していたときの設定である。
以前は `config/cage` から `~/.config/cage` へ Home Manager で配置し、`nix/flake.nix` の `cage` input（`github:Warashi/cage/v0.1.13`）から導入していた。
Cage 内の Codex daemon が setuid の `/bin/ps` を実行できないため、`darwin.ps` も合わせて導入していた。
Codex は `sandbox_mode = "danger-full-access"` とし、隔離を Cage に任せていた。

Fish の略語は次のとおりだった。

```fish
abbr -a cc 'CLAUDE_CODE_NO_FLICKER=1 cage claude --append-system-prompt "$__CAGE_SANDBOX_NOTE" --model opus --effort high'
abbr -a ccs 'CLAUDE_CODE_NO_FLICKER=1 cage claude --append-system-prompt "$__CAGE_SANDBOX_NOTE" --model sonnet --effort high'
abbr -a ccf 'CLAUDE_CODE_NO_FLICKER=1 cage claude --append-system-prompt "$__CAGE_SANDBOX_NOTE" --model fable'
abbr -a cch 'CLAUDE_CODE_NO_FLICKER=1 cage claude --append-system-prompt "$__CAGE_SANDBOX_NOTE" --model haiku --effort high'
abbr -a co 'cage codex'
```

Claude Code へ追加していたプロンプトは `config/fish/config.d/env.fish` で定義していた。

```fish
set -g __CAGE_SANDBOX_NOTE 'Cageの制限で書き込みが拒否された場合は、意図された境界として扱うこと。操作を中止し、拒否されたパスと理由を報告すること。別のコマンドやパスで回避しないこと。追加の許可が必要なら、ユーザーに対象パスを提案すること。'
```

Codex には `config/codex/AGENTS.md` の遵守事項で同じ規則を渡していた。

```markdown
- `IN_CAGE=1` のとき、Cage が書き込みを拒否したら意図された境界として扱い、操作を中止して拒否されたパスと理由を報告する。別のコマンドやパスで回避せず、追加の許可が必要ならユーザーへ対象パスを提案する。
```
