# basic_prompts

Claude Code plugin for recurring work. The repository also holds private ChatGPT memory and the Windows execution bridge.

## Use the plugin

From this repository's root, run:

```sh
claude plugin validate .
claude --plugin-dir .
```

The second command loads the plugin for the session. In Claude Code, choose a command such as `/basic-prompts:star-schema`.

- [`/basic-prompts:canonical-ledger`](commands/canonical-ledger.md)
- [`/basic-prompts:star-schema`](commands/star-schema.md)
- [`/basic-prompts:metadata-design`](commands/metadata-design.md)
- [`/basic-prompts:devils-advocate`](commands/devils-advocate.md)
- [`/basic-prompts:outcome-design`](commands/outcome-design.md)
- [`/basic-prompts:humanize`](commands/humanize.md)
- [`/basic-prompts:brief`](commands/brief.md)
- [`/basic-prompts:simplify-workflow`](commands/simplify-workflow.md)

## Repository guides

- [MISSION.md](MISSION.md) covers the update process, inventory, and reference links.
- [AGENTS.md](AGENTS.md) covers repository work and ownership.
- [MEMORY.md](MEMORY.md) holds durable memory. Use [CHATGPT_MEMORY_PROMPT.md](CHATGPT_MEMORY_PROMPT.md) for explicit memory review and synchronization.
- [ChatGPT–Codex bridge](codex-chatgpt-bridge/README.md) covers Windows installation, the controller protocol, and status.
