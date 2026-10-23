---
name: voicevox-tts
description: VOICEVOXで指定した日本語の文章をWAVに保存し、必要に応じて読み上げる。音声ファイルの作成、ずんだもんや四国めたんでの読み上げを頼まれたときに使う。
---

# VOICEVOXで文章を読み上げる

macOSのApple Silicon向け。`uv`と`curl`を使う。以下の`<skill-dir>`は、このSKILL.mdがあるディレクトリの絶対パスに置き換える。

## 初回の準備

`bash <skill-dir>/scripts/setup.sh --dry-run`で保存先を確認する。未導入なら、[音声モデルの利用規約](https://github.com/VOICEVOX/voicevox_vvm/blob/0.17.0/README.md)への同意をユーザーに確認してから実行する。既にこの会話で同意済みなら再確認は不要。

```bash
bash <skill-dir>/scripts/setup.sh --accept-terms
```

VOICEVOX Core 0.17.0用のランタイム、辞書、基本モデルを取得する。ずんだもん、四国めたん、春日部つむぎ、雨晴はうを使える。保存先は`${XDG_DATA_HOME:-$HOME/.local/share}/voicevox/0.17.0`。`VOICEVOX_HOME`を指定すると変更できる。Python依存は`uv`が管理する。モデルや生成音声をスキルのディレクトリに置かない。

## 音声を作る

1. 読む文章と保存先を依頼から決める。文章がなければ確認する。声の指定がなければ、ずんだもんのノーマルを使う。
2. 声の指定があるときは、インストール済みの一覧からstyle IDを選ぶ。

   ```bash
   uv run <skill-dir>/scripts/synthesize.py --list-speakers
   ```

3. 文章を引用して合成する。読み上げの依頼には`--play`を付ける。保存だけの依頼では付けない。

   ```bash
   uv run <skill-dir>/scripts/synthesize.py 'こんにちは、ずんだもんなのだ。' --style-id 3 --output ./hello.wav --play
   ```

   `--speed 1.2`で速さを変更できる。既存ファイルは上書きしない。存在するときは別名を選ぶ。長文は`text`に`-`を渡して標準入力から読ませる。

4. 成功時に表示されたWAVへのリンクと声を返す。生成に失敗した場合は生成済みと報告しない。再生だけ失敗した場合は、保存済みのWAVを`afplay`で再生する。再合成は不要。

初期モデルにない声を頼まれたら、その旨を伝える。追加モデルは[公式のモデル対応表](https://github.com/VOICEVOX/voicevox_vvm/blob/0.17.0/README.md)で確認する。

公開・配布する音声には、使用した声の利用条件に従い`VOICEVOX:ずんだもん`などのクレジットを付ける。
