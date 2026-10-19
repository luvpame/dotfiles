#!/usr/bin/env python3
import contextlib
import importlib.util
import io
import sys
import tempfile
import unittest
from pathlib import Path
from unittest import mock


spec = importlib.util.spec_from_file_location("generate", Path(__file__).with_name("generate.py"))
generate = importlib.util.module_from_spec(spec)
spec.loader.exec_module(generate)


class GenerateTest(unittest.TestCase):
    def setUp(self):
        directory = tempfile.TemporaryDirectory()
        self.addCleanup(directory.cleanup)
        self.root = Path(directory.name)
        self.target = self.root / "plugin/SKILL.md"
        self.target.parent.mkdir()
        self.target.write_text("old\n")
        here = mock.patch.multiple(generate, HERE=self.root, ROOT=self.root)
        here.start()
        self.addCleanup(here.stop)
        build = mock.patch.object(generate, "generate", side_effect=self.build)
        self.build_mock = build.start()
        self.addCleanup(build.stop)

    def build(self, work):
        bundle = work / "bundle"
        bundle.mkdir()
        (bundle / "SKILL.md").write_text("new\n")
        return bundle

    def run_mode(self, *args):
        with mock.patch.object(sys, "argv", ["generate.py", *args]):
            with contextlib.redirect_stdout(io.StringIO()):
                return generate.main()

    def test_check_reports_stale_files_without_overwriting(self):
        self.assertEqual(self.run_mode("--check"), 1)
        self.assertEqual(self.target.read_text(), "old\n")

    def test_dry_run_does_not_overwrite(self):
        self.assertEqual(self.run_mode("--dry-run"), 0)
        self.assertEqual(self.target.read_text(), "old\n")

    def test_regeneration_removes_obsolete_files_and_ignores_runtime_cache(self):
        (self.target.parent / "obsolete.md").write_text("old\n")
        self.assertEqual(self.run_mode(), 0)
        self.assertEqual(self.target.read_text(), "new\n")
        self.assertFalse((self.target.parent / "obsolete.md").exists())
        cache = self.target.parent / "__pycache__"
        cache.mkdir()
        (cache / "module.pyc").write_bytes(b"runtime cache")
        self.assertEqual(self.run_mode("--check"), 0)

    def test_failed_generation_preserves_existing_bundle(self):
        self.build_mock.side_effect = ValueError("upstream changed")
        with self.assertRaises(ValueError):
            self.run_mode()
        self.assertEqual(self.target.read_text(), "old\n")


if __name__ == "__main__":
    unittest.main()
