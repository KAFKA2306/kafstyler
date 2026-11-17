# Kafstyler

Claude Code plugin for recurring work. The repository also holds private ChatGPT memory and the Windows execution bridge.

## Use the plugin

From this repository's root, run:

```sh
claude plugin validate .
claude --plugin-dir .
```

The second command loads the plugin for the session. In Claude Code, choose a command such as `/kafstyler:star-schema`.

- [`/kafstyler:canonical-ledger`](commands/canonical-ledger.md)
- [`/kafstyler:star-schema`](commands/star-schema.md)
- [`/kafstyler:metadata-design`](commands/metadata-design.md)
- [`/kafstyler:devils-advocate`](commands/devils-advocate.md)
- [`/kafstyler:outcome-design`](commands/outcome-design.md)
- [`/kafstyler:humanize`](commands/humanize.md)
- [`/kafstyler:brief`](commands/brief.md)
- [`/kafstyler:simplify-workflow`](commands/simplify-workflow.md)

## Repository guides

- [MISSION.md](MISSION.md) covers the update process, inventory, and reference links.
- [AGENTS.md](AGENTS.md) covers repository work and ownership.
- [MEMORY.md](MEMORY.md) holds durable memory. Use [CHATGPT_MEMORY_PROMPT.md](CHATGPT_MEMORY_PROMPT.md) for explicit memory review and synchronization.
- [ChatGPT–Codex bridge](codex-chatgpt-bridge/README.md) covers Windows installation, the controller protocol, and status.
