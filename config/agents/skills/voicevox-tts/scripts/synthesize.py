#!/usr/bin/env -S uv run --script
# /// script
# requires-python = ">=3.13"
# dependencies = [
#   "voicevox-core @ https://github.com/VOICEVOX/voicevox_core/releases/download/0.17.0/voicevox_core-0.17.0-cp310-abi3-macosx_11_0_arm64.whl",
# ]
# ///

import argparse
import math
import os
import subprocess
import sys
import tempfile
from importlib.metadata import version
from pathlib import Path


def save_wav(output: Path, wav: bytes) -> None:
    with tempfile.NamedTemporaryFile(dir=output.parent, suffix=".wav") as temporary:
        temporary.write(wav)
        temporary.flush()
        os.link(temporary.name, output)


def main() -> None:
    parser = argparse.ArgumentParser(description="VOICEVOXで文章をWAVに保存する。")
    parser.add_argument("text", nargs="?", help="読む文章。- は標準入力。")
    parser.add_argument(
        "--list-speakers", action="store_true", help="導入済みの声とstyle IDを表示する。"
    )
    parser.add_argument("--style-id", type=int, default=3)
    parser.add_argument("--speed", type=float, default=1.0)
    parser.add_argument("--output", type=Path, default=Path("output.wav"))
    parser.add_argument("--play", action="store_true", help="保存後にafplayで再生する。")
    args = parser.parse_args()

    if not math.isfinite(args.speed) or args.speed <= 0:
        parser.error("--speedは0より大きい有限の数を指定してください。")
    text = sys.stdin.read() if args.text == "-" else args.text
    if not args.list_speakers:
        if not text or not text.strip():
            parser.error("読む文章を指定してください。")
        if args.output.exists() or args.output.is_symlink():
            parser.error(f"既存ファイルは上書きしません: {args.output}")

    from voicevox_core.blocking import (
        Onnxruntime,
        OpenJtalk,
        Synthesizer,
        VoiceModelFile,
    )

    data_home = Path(os.environ.get("XDG_DATA_HOME", Path.home() / ".local/share"))
    runtime = Path(
        os.environ.get("VOICEVOX_HOME", data_home / "voicevox" / version("voicevox-core"))
    )
    try:
        styles: dict[int, tuple[Path, str, str]] = {}
        for path in sorted((runtime / "models/vvms").glob("*.vvm")):
            with VoiceModelFile.open(str(path)) as model:
                for speaker in model.metas:
                    for style in speaker.styles:
                        styles[style.id] = (path, speaker.name, style.name)
        if not styles:
            parser.error("モデルがありません。先にscripts/setup.shを実行してください。")
        if args.list_speakers:
            for style_id, (_, speaker, style) in sorted(styles.items()):
                print(f"{style_id}\t{speaker}\t{style}")
            return
        if args.style_id not in styles:
            parser.error("指定されたstyle IDは未導入です。--list-speakersで確認してください。")

        model_path, speaker, style = styles[args.style_id]
        synthesizer = Synthesizer(
            Onnxruntime.load_once(
                filename=str(
                    runtime / "onnxruntime/lib"
                    / Onnxruntime.LIB_RECOMMENDED_VERSIONED_FILENAME
                )
            ),
            OpenJtalk(str(runtime / "dict/open_jtalk_dic_utf_8-1.11")),
            acceleration_mode="CPU",
        )
        with VoiceModelFile.open(str(model_path)) as model:
            synthesizer.load_voice_model(model)
        query = synthesizer.create_audio_query(text, args.style_id)
        query.speed_scale = args.speed
        save_wav(args.output, synthesizer.synthesis(query, args.style_id))
    except (OSError, ValueError, RuntimeError) as error:
        parser.exit(1, f"音声生成に失敗しました: {error}\n")

    print(f"保存しました: {args.output.resolve()}\nVOICEVOX:{speaker} / {style}", flush=True)
    if args.play:
        try:
            subprocess.run(["afplay", str(args.output.resolve())], check=True)
        except (OSError, subprocess.CalledProcessError) as error:
            parser.exit(1, f"WAVは保存済みですが、再生に失敗しました: {error}\n")


if __name__ == "__main__":
    main()
