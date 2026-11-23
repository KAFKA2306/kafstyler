"""Verify Orca's read-only Kafstyler gate against actual Git checkout states."""

from pathlib import Path
import importlib.util
import json
import subprocess
import tempfile
import unittest
from contextlib import redirect_stdout
from io import StringIO


FILE = Path(__file__).resolve().parents[1] / "scripts" / "orca-preflight.py"
spec = importlib.util.spec_from_file_location("orca_preflight", FILE)
module = importlib.util.module_from_spec(spec)
spec.loader.exec_module(module)


def cmd(repo: Path, *args: str) -> None:
    subprocess.run(["git", "-C", str(repo), *args], capture_output=True, check=True)


class PreflightTests(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory()
        self.addCleanup(self.temp.cleanup)
        self.repo = Path(self.temp.name)
        cmd(self.repo, "init", "-q", "-b", "main")
        cmd(self.repo, "-c", "user.email=runner@example.test", "-c", "user.name=Test", "commit", "-q", "--allow-empty", "-m", "Initial")

    def run_gate(self):
        output = StringIO()
        with redirect_stdout(output):
            rc = module.main(["--repo", str(self.repo)])
        return rc, json.loads(output.getvalue())

    def test_clean_main_is_ready(self):
        rc, data = self.run_gate()
        self.assertEqual((rc, data["status"]), (0, "ready"))
        self.assertTrue(data["clean"])
        self.assertEqual(data["worktree_count"], 1)

    def test_untracked_changes_are_blocked_without_mutating(self):
        path = self.repo / "untracked.txt"
        path.write_text("do not delete")
        rc, data = self.run_gate()
        self.assertEqual((rc, data["status"]), (2, "blocked"))
        self.assertEqual(path.read_text(), "do not delete")

    def test_extra_branch_is_blocked(self):
        cmd(self.repo, "branch", "experimental")
        rc, data = self.run_gate()
        self.assertEqual((rc, data["status"]), (2, "blocked"))
        self.assertEqual(data["local_branches"], ["experimental", "main"])

    def test_missing_git_checkout_is_error_not_noop(self):
        self.repo = self.repo / "missing"
        rc, data = self.run_gate()
        self.assertEqual((rc, data["status"]), (1, "error"))


if __name__ == "__main__":
    unittest.main()
