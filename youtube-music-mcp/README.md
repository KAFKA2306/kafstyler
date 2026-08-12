# YouTube Music MCP

Local MCP server for playlist workflows using the official **YouTube Data API v3**.

This is intentionally a thin adapter rather than a dependency on an unofficial YouTube Music API. YouTube states that playlists are shown in both YouTube Music and YouTube; playlists created in the main YouTube app only surface music videos in YouTube Music.

## Exposed tools

- `search_music` — search music-topic YouTube videos
- `list_my_playlists` — list playlists owned by the authenticated account
- `list_playlist_items` — inspect playlist contents
- `create_playlist` — create a playlist; defaults to `private`
- `add_video_to_playlist` — add a verified video ID to a playlist

No delete tool is exposed.

## Security boundary

- OAuth client JSON and refresh/access tokens are never committed to GitHub.
- Local credentials live under `%LOCALAPPDATA%\OpenAI\YouTubeMusicMCP` on Windows.
- The OAuth scope is `https://www.googleapis.com/auth/youtube`, which Google documents as permission to manage the authenticated YouTube account.
- Playlist creation defaults to `private`.
- The ChatGPT ↔ Codex bridge only exposes this MCP when a queue task explicitly contains `"mcp":["youtube_music"]`; normal bridge tasks remain isolated with `--ignore-user-config`.

## One-time Google Cloud setup

1. Create or select a Google Cloud project.
2. Enable **YouTube Data API v3** for the project.
3. Configure the Google Auth / OAuth consent screen for the account that owns the YouTube Music library.
4. Create an OAuth client with application type **Desktop app**.
5. Download the client JSON to the Windows machine. Do not add it to this repository.

Google's installed-app OAuth flow uses a browser authorization step and a loopback redirect on the local machine. `auth.py` implements that installed-app flow.

## Install on Windows

Prerequisites:

```powershell
uv --version
codex --version
gh auth status
```

Clone/update the private repository and run:

```powershell
$dst = Join-Path $env:TEMP 'basic_prompts-ytm-mcp'
Remove-Item $dst -Recurse -Force -ErrorAction SilentlyContinue
gh repo clone KAFKA2306/basic_prompts $dst
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "$dst\youtube-music-mcp\install.ps1" `
  -ClientSecret "C:\path\to\client_secret.json"
```

The installer:

1. installs the adapter into `%LOCALAPPDATA%\OpenAI\YouTubeMusicMCP`;
2. creates an isolated `uv` environment;
3. registers `youtube_music` with normal interactive Codex via `codex mcp add`;
4. opens the Google OAuth authorization flow when `-ClientSecret` is supplied;
5. saves the resulting token locally and runs `codex mcp list`.

If installation is done before the client JSON is available, omit `-ClientSecret`, then authorize later with:

```powershell
$root = Join-Path $env:LOCALAPPDATA 'OpenAI\YouTubeMusicMCP'
& "$root\.venv\Scripts\python.exe" "$root\auth.py" "C:\path\to\client_secret.json"
```

## Codex verification

```powershell
codex mcp list
```

The server name must appear as `youtube_music`. In interactive Codex or the ChatGPT desktop app on the same Codex host, `/mcp` can show configured MCP servers.

## Bridge queue usage

Normal task:

```json
{"cwd":"D:\\repo","prompt":"Do the repository task"}
```

YouTube Music-enabled task:

```json
{
  "cwd":"D:\\repo",
  "mcp":["youtube_music"],
  "prompt":"Create a private playlist named KAFKA // DEEP WORK and return its YouTube Music URL. Search and verify each track before adding it."
}
```

The bridge keeps `--ignore-user-config`; the local YouTube Music MCP command is injected only for an explicitly opted-in queue task.

## Upstream documentation

- YouTube Data API v3 playlists: https://developers.google.com/youtube/v3/docs/playlists/insert
- YouTube Data API v3 playlist items: https://developers.google.com/youtube/v3/docs/playlistItems/insert
- Google OAuth 2.0 for desktop apps: https://developers.google.com/identity/protocols/oauth2/native-app
- YouTube API OAuth scopes: https://developers.google.com/identity/protocols/oauth2/scopes#youtube
- YouTube Music playlist help: https://support.google.com/youtubemusic/answer/7205933
- OpenAI Codex MCP: https://learn.chatgpt.com/docs/extend/mcp?surface=cli
- OpenAI Codex config overrides: https://learn.chatgpt.com/docs/config-file/config-advanced
