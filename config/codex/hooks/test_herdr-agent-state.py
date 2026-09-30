import json
import os
import socket
import subprocess
import tempfile
import unittest
from pathlib import Path


SCRIPT = Path(__file__).resolve().parent.parent / "herdr-agent-state.sh"


class HerdrAgentStateTest(unittest.TestCase):
    def test_session_start_reports_session(self):
        with tempfile.TemporaryDirectory() as directory:
            socket_path = str(Path(directory) / "herdr.sock")
            with socket.socket(socket.AF_UNIX, socket.SOCK_STREAM) as server:
                server.bind(socket_path)
                server.listen(1)
                server.settimeout(2)
                result = subprocess.run(
                    ["bash", str(SCRIPT), "session"],
                    input=json.dumps({
                        "hook_event_name": "SessionStart",
                        "session_id": "test-session",
                        "transcript_path": "/tmp/test-rollout.jsonl",
                    }),
                    text=True,
                    capture_output=True,
                    timeout=3,
                    env={
                        **os.environ,
                        "HERDR_ENV": "1",
                        "HERDR_SOCKET_PATH": socket_path,
                        "HERDR_PANE_ID": "w1:p1",
                        "CODEX_THREAD_ID": "test-session",
                    },
                )
                self.assertEqual(result.returncode, 0, result.stderr)
                connection, _ = server.accept()
                with connection:
                    connection.settimeout(2)
                    request = json.loads(connection.recv(4096))
                self.assertEqual(request["method"], "pane.report_agent_session")
                self.assertEqual(request["params"]["agent"], "codex")
                self.assertEqual(request["params"]["pane_id"], "w1:p1")
                self.assertEqual(request["params"]["agent_session_id"], "test-session")


if __name__ == "__main__":
    unittest.main()
