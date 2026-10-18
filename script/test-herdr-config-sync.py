#!/usr/bin/env python3
import os
import re
import subprocess
import tempfile
import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
FILES = ("config.toml", "config-gpui.local.toml")


class HerdrConfigSyncTest(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory(prefix="herdr config ")
        self.addCleanup(self.temp.cleanup)
        self.root = Path(self.temp.name)
        self.source = self.root / "repo/herdr"
        self.target = self.root / "config/herdr"
        self.source.mkdir(parents=True)
        self.target.mkdir(parents=True)
        for name in FILES:
            (self.source / name).write_text("original\n")
        module = (ROOT / "nix/nix-darwin/home-manager/files.nix").read_text()
        self.script = re.search(
            r"home\.activation\.copyHerdrConfig = .*? ''\n(.*?)\n  '';",
            module,
            re.DOTALL,
        ).group(1)
        substitutions = {
            "${configRoot}": str(self.root / "repo"),
            "${config.xdg.configHome}": str(self.root / "config"),
            "${config.xdg.stateHome}": str(self.root / "state"),
            "${pkgs.coreutils}": str(
                next(Path("/nix/store").glob("*-coreutils-*/bin/install")).parents[1]
            ),
            "${pkgs.diffutils}": str(
                next(Path("/nix/store").glob("*-diffutils-*/bin/cmp")).parents[1]
            ),
        }
        for old, new in substitutions.items():
            self.script = self.script.replace(old, new)

    def sync(self, dry_run=False):
        subprocess.run(
            [
                "bash",
                "-c",
                'set -euo pipefail\n'
                'run() { if [ "$TEST_DRY_RUN" = 0 ]; then "$@"; fi; }\n'
                + self.script,
            ],
            env={**os.environ, "TEST_DRY_RUN": "1" if dry_run else "0"},
            check=True,
        )

    def test_gui_changes_survive_repeated_switch(self):
        self.sync()
        for name in FILES:
            self.assertEqual((self.target / name).read_text(), "original\n")
            (self.target / name).write_text("GUI\n")
        self.sync()
        self.sync()
        for name in FILES:
            self.assertEqual((self.target / name).read_text(), "GUI\n")

    def test_dotfiles_change_wins_only_for_changed_file(self):
        self.sync()
        for name in FILES:
            (self.target / name).write_text("GUI\n")
        (self.source / FILES[0]).write_text("dotfiles\n")
        self.sync()
        self.assertEqual((self.target / FILES[0]).read_text(), "dotfiles\n")
        self.assertEqual((self.target / FILES[1]).read_text(), "GUI\n")
        (self.target / FILES[0]).write_text("new GUI\n")
        self.sync()
        self.assertEqual((self.target / FILES[0]).read_text(), "new GUI\n")

    def test_existing_settings_survive_first_adoption(self):
        for name in FILES:
            (self.target / name).write_text("existing GUI\n")
        self.sync()
        for name in FILES:
            self.assertEqual((self.target / name).read_text(), "existing GUI\n")
        (self.source / FILES[0]).write_text("updated\n")
        self.sync()
        self.assertEqual((self.target / FILES[0]).read_text(), "updated\n")

    def test_missing_destination_is_restored(self):
        self.sync()
        (self.target / FILES[0]).unlink()
        self.sync()
        self.assertEqual((self.target / FILES[0]).read_text(), "original\n")

    def test_dry_run_does_not_write_settings_or_state(self):
        self.sync(dry_run=True)
        self.assertEqual(list(self.target.iterdir()), [])
        self.assertFalse((self.root / "state").exists())


if __name__ == "__main__":
    unittest.main()
