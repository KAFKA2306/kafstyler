# Direct MCP upgrade path

This directory is documentation-only.

For the current ChatGPT Plus environment, use `../codex-chatgpt-bridge/`.

When the ChatGPT workspace supports custom MCP developer mode, the preferred direct architecture is:

```text
ChatGPT custom MCP app
  ↕ OpenAI Secure MCP Tunnel
openai/tunnel-client
  ↕ stdio
codex mcp-server
```

Upstream sources:

- OpenAI Codex MCP server: https://developers.openai.com/codex/mcp-server
- OpenAI Secure MCP Tunnel: https://developers.openai.com/api/docs/guides/secure-mcp-tunnels
- OSS tunnel client: https://github.com/openai/tunnel-client
- OSS Codex: https://github.com/openai/codex

Do not use an unverified local bootstrap from this directory. Follow the current upstream onboarding flow (`tunnel-client help quickstart`, `tunnel-client runtimes connect`, and `tunnel-client runtimes status`) when upgrading to the direct MCP path.
