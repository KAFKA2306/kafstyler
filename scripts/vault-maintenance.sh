#!/usr/bin/env bash
# Deterministic, model-free Vault maintenance. Requires upstream CLI tools.
set -euo pipefail
umask 077

mode="${1:---check}"
if (( $# > 1 )) || [[ "$mode" != --check && "$mode" != --apply ]]; then
  echo 'Usage: OBSIDIAN_VAULT_PATH=/path/to/vault [KAFSTYLER_INGEST_SOURCE=source:path] vault-maintenance.sh [--check|--apply]' >&2
  exit 2
fi
: "${OBSIDIAN_VAULT_PATH:?Set OBSIDIAN_VAULT_PATH to the canonical Vault root}"
[[ -d "$OBSIDIAN_VAULT_PATH" ]] || { echo "Vault directory does not exist" >&2; exit 2; }
vault="$(cd "$OBSIDIAN_VAULT_PATH" && pwd -P)"
command -v vault-lint >/dev/null || { echo "Install upstream Knowledge Compiler (vault-lint)" >&2; exit 2; }

if [[ "$mode" == --check ]]; then
  exec vault-lint "$vault" --json
fi

command -v flock >/dev/null || { echo "flock is required for non-overlapping runs" >&2; exit 2; }
cache="${XDG_CACHE_HOME:-$HOME/.cache}/kafstyler"
mkdir -p "$cache"
exec 9>"$cache/vault-maintenance.lock"
flock -n 9 || { echo "Another Vault maintenance run is active" >&2; exit 75; }

git_root=''
if git -C "$vault" rev-parse --show-toplevel >/dev/null 2>&1; then
  git_root="$(git -C "$vault" rev-parse --show-toplevel)"
  [[ "$git_root" == "$vault" ]] || { echo "Vault is inside another Git repository" >&2; exit 2; }
  [[ "$(git -C "$vault" branch --show-current)" == main ]] || { echo "Vault Git branch must be main" >&2; exit 2; }
  [[ -z "$(git -C "$vault" status --porcelain=v1 -uall)" ]] || { echo "Vault has pre-existing uncommitted changes" >&2; exit 2; }
fi

if [[ -n "${KAFSTYLER_INGEST_SOURCE:-}" ]]; then
  case "$KAFSTYLER_INGEST_SOURCE" in
    "$vault"|"$vault"/*|"$cache"|"$cache"/*)
      echo 'Ingest source must not point into the Vault or its cache' >&2; exit 2 ;;
  esac
  command -v rclone >/dev/null || { echo "Install rclone to ingest external sources" >&2; exit 2; }
  command -v vault-extract >/dev/null || { echo "Install upstream Knowledge Compiler (vault-extract)" >&2; exit 2; }
  mkdir -p "$cache/inbox"
  rclone copy "$KAFSTYLER_INGEST_SOURCE" "$cache/inbox" --exclude ".git/**" --exclude ".obsidian/**"
  while IFS= read -r -d "" file; do
    case "${file,,}" in
      *.pdf|*.pptx|*.docx|*.xlsx|*.xls|*.csv|*.html|*.htm|*.mhtml|*.md|*.txt)
        vault-extract "$file" --vault "$vault" ;;
    esac
  done < <(find "$cache/inbox" -type f -print0)
fi

vault-lint "$vault" --fix
vault-lint "$vault" --json

if [[ -n "$git_root" ]]; then
  git -C "$vault" add -A
  if ! git -C "$vault" diff --cached --quiet; then
    git -C "$vault" commit -m 'chore(vault): ingest and lint verified changes'
  fi
  [[ -z "$(git -C "$vault" status --porcelain=v1 -uall)" ]] || { echo "Vault Git changes remain uncommitted" >&2; exit 1; }
fi
