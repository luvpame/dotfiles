#!/usr/bin/env python3
"""Run copyHerdrConfig's bash on every small file state and check the result."""

import re
import stat
import subprocess
import sys
import tempfile
from pathlib import Path

ROOT = Path(__file__).resolve().parents[3]
FILES_NIX = ROOT / "nix/nix-darwin/home-manager/files.nix"
CONTENTS = {
    "empty": b"",
    "a": b"a\n",
    "gui": b"GUI\n",
}


def store_prefix(glob: str) -> Path:
    matches = sorted(Path("/nix/store").glob(glob))
    if not matches:
        raise SystemExit(f"no /nix/store match for {glob}")
    # .../bin/<tool> -> package prefix, two parents up from the file.
    return matches[-1].parents[1]


def load_script() -> str:
    text = FILES_NIX.read_text()
    match = re.search(
        r"home\.activation\.copyHerdrConfig = .*? ''\n(.*?)\n  '';",
        text,
        re.DOTALL,
    )
    if not match:
        raise SystemExit("copyHerdrConfig bash not found in files.nix")
    script = match.group(1)
    if "cmp -s" not in script or "for file in config.toml" not in script:
        raise SystemExit("extracted bash is not the config.toml copy loop")
    replacements = {
        "${configRoot}": "__CONFIG_ROOT__",
        "${config.xdg.configHome}": "__CONFIG_HOME__",
        "${config.xdg.stateHome}": "__STATE_HOME__",
        "${pkgs.coreutils}": str(store_prefix("*-coreutils-*/bin/install")),
        "${pkgs.diffutils}": str(store_prefix("*-diffutils-*/bin/cmp")),
    }
    for old, new in replacements.items():
        if old not in script:
            raise SystemExit(f"activation script has no {old}")
        script = script.replace(old, new)
    return script


def write_file(path: Path, body: bytes | None) -> None:
    if body is None:
        if path.exists() or path.is_symlink():
            path.unlink()
        return
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_bytes(body)
    path.chmod(0o644)


def mode_bits(path: Path) -> int:
    return stat.S_IMODE(path.stat().st_mode)


def run_activation(script: str, root: Path) -> None:
    concrete = (
        script.replace("__CONFIG_ROOT__", str(root / "repo/config"))
        .replace("__CONFIG_HOME__", str(root / "config"))
        .replace("__STATE_HOME__", str(root / "state"))
    )
    subprocess.run(
        ["bash", "-c", 'set -euo pipefail\nrun() { "$@"; }\n' + concrete],
        check=True,
    )


def expect(source: bytes, target: bytes | None, previous: bytes | None) -> tuple[bytes, bytes, bool]:
    changed = previous is not None and previous != source
    copied = target is None or changed
    return (source if copied else target, source, copied)


def check_case(script: str, source_name: str, target_name: str | None, previous_name: str | None) -> None:
    source = CONTENTS[source_name]
    target = None if target_name is None else CONTENTS[target_name]
    previous = None if previous_name is None else CONTENTS[previous_name]
    want_target, want_previous, copied = expect(source, target, previous)

    with tempfile.TemporaryDirectory(prefix="herdr-sync-") as tmp:
        root = Path(tmp)
        write_file(root / "repo/config/herdr/config.toml", source)
        write_file(root / "config/herdr/config.toml", target)
        write_file(root / "state/dotfiles/herdr/config.toml", previous)
        run_activation(script, root)
        got_target = (root / "config/herdr/config.toml").read_bytes()
        got_previous = (root / "state/dotfiles/herdr/config.toml").read_bytes()
        target_mode = mode_bits(root / "config/herdr/config.toml")
        previous_mode = mode_bits(root / "state/dotfiles/herdr/config.toml")

    problems = []
    if got_target != want_target:
        problems.append(f"target {got_target!r} != {want_target!r}")
    if got_previous != want_previous:
        problems.append(f"previous {got_previous!r} != {want_previous!r}")
    if copied and target_mode != 0o600:
        problems.append(f"copied target mode {target_mode:o} != 600")
    if not copied and target_mode != 0o644:
        problems.append(f"kept target mode {target_mode:o} != 644")
    if previous_mode != 0o600:
        problems.append(f"previous mode {previous_mode:o} != 600")
    if problems:
        print(
            "FAIL "
            f"source={source_name} target={target_name} previous={previous_name}: "
            + "; ".join(problems)
        )
        raise SystemExit(1)


def story(script: str) -> None:
    """Adopt an existing file, keep a GUI edit, then apply a dotfiles change."""
    with tempfile.TemporaryDirectory(prefix="herdr-story-") as tmp:
        root = Path(tmp)
        source = root / "repo/config/herdr/config.toml"
        target = root / "config/herdr/config.toml"
        write_file(source, CONTENTS["a"])
        write_file(target, CONTENTS["gui"])
        run_activation(script, root)
        if target.read_bytes() != CONTENTS["gui"]:
            print("FAIL story: first run replaced an existing config.toml")
            raise SystemExit(1)
        target.write_bytes(CONTENTS["gui"])
        run_activation(script, root)
        if target.read_bytes() != CONTENTS["gui"]:
            print("FAIL story: unchanged dotfiles copy wiped the GUI edit")
            raise SystemExit(1)
        source.write_bytes(CONTENTS["a"] + b"changed\n")
        run_activation(script, root)
        if target.read_bytes() != source.read_bytes():
            print("FAIL story: a changed dotfiles copy did not reach config.toml")
            raise SystemExit(1)
    print("PASS story adopt, keep GUI, apply dotfiles change")


def main() -> None:
    script = load_script()
    count = 0
    for source_name in CONTENTS:
        for target_name in (None, *CONTENTS):
            for previous_name in (None, *CONTENTS):
                check_case(script, source_name, target_name, previous_name)
                count += 1
    print(f"PASS {count} single-step cases")
    story(script)
    print("PASS herdr-config-sync")


if __name__ == "__main__":
    try:
        main()
    except subprocess.CalledProcessError as error:
        print(f"FAIL activation exited {error.returncode}", file=sys.stderr)
        raise SystemExit(1) from error
