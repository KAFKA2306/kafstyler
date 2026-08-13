from pathlib import Path
import unittest


ROOT = Path(__file__).resolve().parents[1]
DAEMON = ROOT / "codex-chatgpt-bridge" / "bridge-daemon.ps1"
README = ROOT / "codex-chatgpt-bridge" / "README.md"


class BridgeExecutionContractTest(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.daemon = DAEMON.read_text(encoding="utf-8")
        cls.readme = README.read_text(encoding="utf-8")

    def test_controller_protocol_is_execution_only_and_fail_closed(self):
        for required in (
            "mode = 'execute_only'",
            "Unsupported mode '$mode'. v2 only accepts execute_only.",
            "cwd and prompt are required",
            "all permission-like flags default to `false`",
        ):
            haystack = self.daemon if required.startswith(("mode", "Unsupported")) else self.readme
            self.assertIn(required, haystack)

    def test_worker_prompt_forbids_diagnosis_scope_broadening_and_unapproved_writes(self):
        for required in (
            "Do not diagnose, redesign, recommend, refactor, broaden scope, or choose the next step.",
            "If additional judgment is required, stop and return only the facts gathered so far.",
            "Do not modify files outside the permitted roots.",
            "Do not commit, push, use shell network access, save Unity state, or trigger reimport unless the policy explicitly allows it.",
            "Do not clean, reset, discard, or overwrite pre-existing dirty working-tree changes.",
            "ChatGPT is the controller and decides that.",
        ):
            self.assertIn(required, self.daemon)

    def test_permissions_are_explicit_opt_in(self):
        for field in (
            "allow_commit",
            "allow_push",
            "allow_network",
            "allow_unity_save",
            "allow_reimport",
        ):
            self.assertIn(f"{field} = (Test-BoolProperty $Spec '{field}')", self.daemon)
        self.assertIn("allow_push=true requires allow_network=true.", self.daemon)
        self.assertIn("allowed_paths entry escapes cwd", self.daemon)
        self.assertIn("allowed_paths entries must be existing directories", self.daemon)

    def test_read_only_tasks_must_leave_git_unchanged(self):
        self.assertIn("$policy['require_git_unchanged']", self.daemon)
        self.assertIn("pre-existing dirty worktrees are never cleaned or reset", self.readme)
        self.assertIn("Any change makes the task fail", self.readme)

    def test_controller_remains_completion_authority(self):
        self.assertIn("ChatGPT verifies evidence and decides the next step", self.readme)
        self.assertIn("It is **not** an automatic claim that the higher-level problem is solved", self.readme)
        self.assertIn("Raw reasoning is not copied to GitHub", self.readme)


if __name__ == "__main__":
    unittest.main()
