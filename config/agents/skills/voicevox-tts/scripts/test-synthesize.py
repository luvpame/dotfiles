import runpy
import subprocess
import sys
import tempfile
import unittest
from concurrent.futures import ThreadPoolExecutor
from pathlib import Path


SCRIPT = Path(__file__).with_name("synthesize.py")
save_wav = runpy.run_path(str(SCRIPT))["save_wav"]


class SynthesizeTest(unittest.TestCase):
    def test_existing_audio_survives_a_second_save(self):
        with tempfile.TemporaryDirectory() as directory:
            output = Path(directory) / "speech.wav"
            save_wav(output, b"original audio")
            with self.assertRaises(FileExistsError):
                save_wav(output, b"replacement audio")
            self.assertEqual(output.read_bytes(), b"original audio")
            self.assertEqual(list(Path(directory).iterdir()), [output])

    def test_concurrent_saves_publish_one_complete_result(self):
        with tempfile.TemporaryDirectory() as directory:
            output = Path(directory) / "speech.wav"
            recordings = [b"first recording" * 1024, b"second recording" * 1024]
            with ThreadPoolExecutor(max_workers=2) as executor:
                futures = [executor.submit(save_wav, output, wav) for wav in recordings]
                errors = [future.exception() for future in futures]
            self.assertEqual(sum(error is None for error in errors), 1)
            self.assertEqual(
                sum(isinstance(error, FileExistsError) for error in errors), 1
            )
            self.assertIn(output.read_bytes(), recordings)
            self.assertEqual(list(Path(directory).iterdir()), [output])

    def test_invalid_input_fails_before_loading_the_engine(self):
        for arguments in (
            [" "],
            ["こんにちは", "--speed", "0"],
            ["こんにちは", "--speed", "nan"],
        ):
            with self.subTest(arguments=arguments):
                result = subprocess.run(
                    [sys.executable, str(SCRIPT), *arguments],
                    capture_output=True,
                    text=True,
                )
                self.assertEqual(result.returncode, 2)
                self.assertIn("error:", result.stderr)
                self.assertNotIn("Traceback", result.stderr)

    def test_cli_preserves_an_existing_output(self):
        with tempfile.TemporaryDirectory() as directory:
            output = Path(directory) / "speech.wav"
            output.write_bytes(b"original audio")
            result = subprocess.run(
                [sys.executable, str(SCRIPT), "こんにちは", "--output", str(output)],
                capture_output=True,
                text=True,
            )
            self.assertEqual(result.returncode, 2)
            self.assertIn("上書きしません", result.stderr)
            self.assertEqual(output.read_bytes(), b"original audio")


if __name__ == "__main__":
    unittest.main()
