# basic_prompts

Private repository for reusable work instructions, ChatGPT memory, and the existing local execution bridge.

- [MISSION.md](MISSION.md) covers how to update the skills, how the first inventory was counted, and which official references to use.
- [AGENTS.md](AGENTS.md) defines repository work and verification.
- [prompt-boundary.json](prompt-boundary.json) maps repository ownership. Register general prompt artifacts in `KAFKA2306/prompt-vault`. Keep raw knowledge and corrections with `KAFKA2306/graphiti`.

## Skills

Claude Code supports these single-file skills in `.claude/commands/`. Run the command named below or open its procedure.

- [`/canonical-ledger`](.claude/commands/canonical-ledger.md)
- [`/star-schema`](.claude/commands/star-schema.md)
- [`/metadata-design`](.claude/commands/metadata-design.md)
- [`/devils-advocate`](.claude/commands/devils-advocate.md)
- [`/outcome-design`](.claude/commands/outcome-design.md)
- [`/humanize`](.claude/commands/humanize.md)
- [`/brief`](.claude/commands/brief.md)
- [`/simplify-workflow`](.claude/commands/simplify-workflow.md)

## Existing entry points

- [MEMORY.md](MEMORY.md) holds durable memory. Use [CHATGPT_MEMORY_PROMPT.md](CHATGPT_MEMORY_PROMPT.md) for explicit memory review and synchronization.
- [ChatGPT–Codex bridge](codex-chatgpt-bridge/README.md) covers the existing Windows installation, controller protocol, and status.
