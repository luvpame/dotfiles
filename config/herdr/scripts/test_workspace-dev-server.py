import json
import os
import subprocess
import tempfile
import unittest
from pathlib import Path


UPDATER = Path(__file__).with_name("workspace-dev-server.py")


class WorkspaceDevServerTest(unittest.TestCase):
    def setUp(self):
        self.temporary_directory = tempfile.TemporaryDirectory()
        self.directory = Path(self.temporary_directory.name)
        self.bin = self.directory / "bin"
        self.herdr_log = self.directory / "herdr.log"
        self.command_log = self.directory / "command.log"
        self.bin.mkdir()
        self.write_fake_herdr()

    def tearDown(self):
        self.temporary_directory.cleanup()

    def write_fake_herdr(self):
        herdr = self.bin / "herdr"
        herdr.write_text(
            "#!/bin/sh\n"
            "if [ \"$1 $2\" = \"workspace list\" ]; then\n"
            "  printf '%s\\n' \"$HERDR_WORKSPACES\"\n"
            "elif [ \"$1 $2\" = \"pane list\" ]; then\n"
            "  case \"$4\" in\n"
            "    w1) printf '%s\\n' \"$HERDR_PANES_W1\" ;;\n"
            "    w2) printf '%s\\n' \"$HERDR_PANES_W2\" ;;\n"
            "  esac\n"
            "elif [ \"$1 $2\" = \"pane process-info\" ]; then\n"
            "  case \"$4\" in\n"
            "    w1:p1) printf '%s\\n' \"$HERDR_PROCESS_P1\" ;;\n"
            "    w1:p2) printf '%s\\n' \"$HERDR_PROCESS_P2\" ;;\n"
            "    w2:p1) printf '%s\\n' \"$HERDR_PROCESS_P3\" ;;\n"
            "  esac\n"
            "else\n"
            "  printf '%s\\n' \"$*\" >> \"$HERDR_LOG\"\n"
            "fi\n"
        )
        herdr.chmod(0o755)

        ps = self.bin / "ps"
        ps.write_text(
            "#!/bin/sh\n"
            "printf '%s\\n' ps >> \"$COMMAND_LOG\"\n"
            "printf '%s\\n' \"$HERDR_PS\"\n"
            "if [ \"${HERDR_PS_EXIT:-0}\" -ne 0 ]; then exit \"$HERDR_PS_EXIT\"; fi\n"
        )
        ps.chmod(0o755)

        lsof = self.bin / "lsof"
        lsof.write_text(
            "#!/bin/sh\n"
            "printf '%s\\n' lsof >> \"$COMMAND_LOG\"\n"
            "printf '%s\\n' \"$HERDR_LSOF\"\n"
            "if [ -n \"${HERDR_LSOF_STDERR:-}\" ]; then printf '%s\\n' \"$HERDR_LSOF_STDERR\" >&2; fi\n"
            "if [ \"${HERDR_LSOF_EXIT:-0}\" -ne 0 ]; then exit \"$HERDR_LSOF_EXIT\"; fi\n"
        )
        lsof.chmod(0o755)

    @staticmethod
    def process_info(shell_pid, *pids):
        return {
            "result": {
                "process_info": {
                    "shell_pid": shell_pid,
                    "foreground_processes": [
                        {"pid": pid, "name": f"process-{pid}"} for pid in pids
                    ],
                }
            }
        }

    def run_updater(
        self,
        process_infos,
        *,
        process_tree,
        listening="",
        lsof_exit=0,
        lsof_stderr="",
        ps_exit=0,
    ):
        workspaces = {
            "result": {
                "workspaces": [
                    {"workspace_id": "w1"},
                    {"workspace_id": "w2"},
                ]
            }
        }
        panes = {
            "result": {
                "panes": [
                    {"pane_id": "w1:p1"},
                    {"pane_id": "w1:p2"},
                ]
            }
        }
        other_panes = {"result": {"panes": [{"pane_id": "w2:p1"}]}}
        env = {
            **os.environ,
            "PATH": f"{self.bin}{os.pathsep}{os.environ['PATH']}",
            "HERDR_LOG": str(self.herdr_log),
            "HERDR_WORKSPACES": json.dumps(workspaces),
            "HERDR_PANES_W1": json.dumps(panes),
            "HERDR_PANES_W2": json.dumps(other_panes),
            "HERDR_PROCESS_P1": json.dumps(process_infos["w1:p1"]),
            "HERDR_PROCESS_P2": json.dumps(process_infos["w1:p2"]),
            "HERDR_PROCESS_P3": json.dumps(process_infos["w2:p1"]),
            "HERDR_PS": process_tree,
            "HERDR_PS_EXIT": str(ps_exit),
            "HERDR_LSOF": listening,
            "HERDR_LSOF_EXIT": str(lsof_exit),
            "COMMAND_LOG": str(self.command_log),
        }
        if lsof_stderr:
            env["HERDR_LSOF_STDERR"] = lsof_stderr
        subprocess.run([UPDATER], env=env, check=True)

    def test_reports_icon_for_listening_child_only(self):
        self.run_updater(
            {
                "w1:p1": self.process_info(100, 101),
                "w1:p2": {
                    "result": {
                        "process_info": {
                            "shell_pid": 110,
                            "foreground_processes": [{"pid": 111, "name": "vite"}],
                        }
                    }
                },
                "w2:p1": {
                    "result": {
                        "process_info": {
                            "shell_pid": 200,
                            "foreground_processes": [{"pid": 201, "name": "vite"}],
                        }
                    }
                },
            },
            process_tree="100 1\n101 100\n102 101\n110 1\n111 110\n200 1\n201 200",
            listening="p102",
        )

        self.assertEqual(
            self.herdr_log.read_text().splitlines(),
            [
                "workspace report-metadata w1 --source dev-server "
                "--token dev_server= --ttl-ms 30000",
                "workspace report-metadata w2 --source dev-server "
                "--token dev_server= --ttl-ms 30000",
            ],
        )
        self.assertEqual(self.command_log.read_text().splitlines(), ["ps", "lsof"])

    def test_reports_icon_for_arbitrary_listening_process(self):
        self.run_updater(
            {
                "w1:p1": {
                    "result": {
                        "process_info": {
                            "shell_pid": 100,
                            "foreground_processes": [
                                {"pid": 101, "name": "my-private-daemon"}
                            ],
                        }
                    }
                },
                "w1:p2": self.process_info(110),
                "w2:p1": self.process_info(200),
            },
            process_tree="100 1\n101 100\n110 1\n200 1",
            listening="p101",
        )

        self.assertIn("--token dev_server=", self.herdr_log.read_text())

    def test_accepts_lsof_no_match_exit_status(self):
        self.run_updater(
            {
                "w1:p1": self.process_info(100, 101),
                "w1:p2": self.process_info(110),
                "w2:p1": self.process_info(200),
            },
            process_tree="100 1\n101 100\n110 1\n200 1",
            lsof_exit=1,
        )

        self.assertIn("--token dev_server= --ttl-ms 30000", self.herdr_log.read_text())

    def test_keeps_existing_metadata_when_process_scan_fails(self):
        self.run_updater(
            {
                "w1:p1": self.process_info(100, 101),
                "w1:p2": self.process_info(110),
                "w2:p1": self.process_info(200),
            },
            process_tree="100 1\n101 100\n110 1\n200 1",
            listening="p101",
            lsof_exit=1,
            lsof_stderr="lsof: permission denied",
        )

        self.assertFalse(self.herdr_log.exists())

        self.command_log.unlink()
        self.run_updater(
            {
                "w1:p1": self.process_info(100, 101),
                "w1:p2": self.process_info(110),
                "w2:p1": self.process_info(200),
            },
            process_tree="100 1\n101 100\n110 1\n200 1",
            listening="p101",
            ps_exit=1,
        )

        self.assertFalse(self.herdr_log.exists())


if __name__ == "__main__":
    unittest.main()
