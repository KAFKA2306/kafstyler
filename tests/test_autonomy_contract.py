import importlib.util
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
MODULE_PATH = ROOT / "tools" / "autonomy_contract.py"
POLICY_PATH = ROOT / "policies" / "autonomy_contract.json"
SPEC = importlib.util.spec_from_file_location("autonomy_contract", MODULE_PATH)
module = importlib.util.module_from_spec(SPEC)
assert SPEC.loader is not None
SPEC.loader.exec_module(module)


class AutonomyContractTest(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.policy = module.load_policy(POLICY_PATH)

    def test_expected_profiles_exist(self):
        self.assertTrue({"general", "repo", "research_data", "investment", "image"} <= set(self.policy["profiles"]))

    def test_new_repo_run_is_incomplete_and_points_to_first_gate(self):
        run = module.make_run(self.policy, "repo", "Resolve issue #196")
        report = module.audit_run(self.policy, run)
        self.assertFalse(report["complete"])
        self.assertEqual(report["next_gate"], "inspect_current_state")

    def test_done_without_required_evidence_does_not_pass(self):
        run = module.make_run(self.policy, "general", "Example")
        run["gates"]["inspect"]["status"] = "done"
        report = module.audit_run(self.policy, run)
        self.assertEqual(report["missing"][0]["reason"], "missing evidence")

    def test_all_required_gates_with_evidence_pass(self):
        run = module.make_run(self.policy, "research_data", "Build canonical dataset")
        for gate in self.policy["profiles"]["research_data"]["gates"]:
            run["gates"][gate["id"]] = {"status": "done", "evidence": ["verified"]}
        report = module.audit_run(self.policy, run)
        self.assertTrue(report["complete"])
        self.assertIsNone(report["next_gate"])

    def test_prompt_contains_global_and_profile_rules(self):
        rendered = module.render_prompt(self.policy, "image", "Generate a simple illustration")
        self.assertIn("no_unnecessary_confirmation", rendered)
        self.assertIn("visual_review", rendered)
        self.assertIn("Generate a simple illustration", rendered)


if __name__ == "__main__":
    unittest.main()
