#!/usr/bin/env bash
# Deterministic, model-free Vault maintenance. Requires upstream CLI tools.
set -euo pipefail
umask 077

if (( $# > 0 )) && { (( $# != 1 )) || [[ "$1" != --apply ]]; }; then
  echo 'Usage: OBSIDIAN_VAULT_PATH=/path/to/vault [KAFSTYLER_INGEST_SOURCE=source:path] vault-maintenance.sh [--apply]' >&2
  exit 2
fi
: "${OBSIDIAN_VAULT_PATH:?Set OBSIDIAN_VAULT_PATH to the canonical Vault root}"
[[ -d "$OBSIDIAN_VAULT_PATH" ]] || { echo "Vault directory does not exist" >&2; exit 2; }
vault="$(cd "$OBSIDIAN_VAULT_PATH" && pwd -P)"
command -v vault-lint >/dev/null || { echo "Install upstream Knowledge Compiler (vault-lint)" >&2; exit 2; }

command -v flock >/dev/null || { echo "flock is required for non-overlapping runs" >&2; exit 2; }
cache_root="${XDG_CACHE_HOME:-$HOME/.cache}/kafstyler"
command -v sha256sum >/dev/null || { echo "sha256sum is required for cache isolation" >&2; exit 2; }
vault_key="$(printf '%s' "$vault" | sha256sum)"
cache="$cache_root/${vault_key%% *}"
mkdir -p "$cache"
exec 9>"$cache/vault-maintenance.lock"
flock -n 9 || { echo "Another Vault maintenance run is active" >&2; exit 75; }

git_root=''
case "${KAFSTYLER_VAULT_MODE:-git}" in
  git)
    git_root="$(git -C "$vault" rev-parse --show-toplevel)"
    [[ "$git_root" == "$vault" ]] || { echo "Vault is inside another Git repository" >&2; exit 2; }
    git_branch="$(git -C "$vault" branch --show-current)"
    [[ "$git_branch" == main ]] || { echo "Vault Git branch must be main" >&2; exit 2; }
    git_status="$(git -C "$vault" status --porcelain=v1 -uall)"
    [[ -z "$git_status" ]] || { echo "Vault has pre-existing uncommitted changes" >&2; exit 2; }
    ;;
  plain)
    dir="$vault"
    while :; do
      [[ ! -e "$dir/.git" && ! -L "$dir/.git" ]] || { echo "Git metadata found: $dir/.git; use Git mode" >&2; exit 2; }
      [[ "$dir" == / ]] && break
      dir="$(dirname "$dir")"
    done
    ;;
  *) echo "KAFSTYLER_VAULT_MODE must be git or plain" >&2; exit 2 ;;
esac

if [[ -n "${KAFSTYLER_INGEST_SOURCE:-}" ]]; then
  case "$KAFSTYLER_INGEST_SOURCE" in
    "$vault"|"$vault"/*|"$cache_root"|"$cache_root"/*)
      echo 'Ingest source must not point into the Vault or its cache' >&2; exit 2 ;;
  esac
  command -v rclone >/dev/null || { echo "Install rclone to ingest external sources" >&2; exit 2; }
  command -v vault-extract >/dev/null || { echo "Install upstream Knowledge Compiler (vault-extract)" >&2; exit 2; }
  source_key="$(printf '%s' "$KAFSTYLER_INGEST_SOURCE" | sha256sum)"
  inbox="$cache/${source_key%% *}/inbox"
  mkdir -p "$inbox"
  rclone sync "$KAFSTYLER_INGEST_SOURCE" "$inbox" --exclude ".git/**" --exclude ".obsidian/**"
  file_list="$(mktemp "$cache/inputs.XXXXXXXX")"
  trap 'rm -f -- "$file_list"' EXIT
  find "$inbox" -type f -print0 > "$file_list"
  declare -A source_stems=()
  while IFS= read -r -d "" file; do
    case "${file,,}" in
      *.pdf|*.pptx|*.docx|*.xlsx|*.xls|*.csv|*.html|*.htm|*.mhtml|*.md|*.txt)
        name="${file##*/}"
        stem="${name%.*}"
        stem="${stem,,}"
        stem="${stem#copy of }"
        if [[ -n "${source_stems[$stem]+set}" && "${source_stems[$stem]}" != "$file" ]]; then
          echo "Two inputs would write the same raw document: ${source_stems[$stem]} and $file" >&2
          exit 2
        fi
        source_stems[$stem]="$file" ;;
    esac
  done < "$file_list"
  while IFS= read -r -d "" file; do
    case "${file,,}" in
      *.pdf|*.pptx|*.docx|*.xlsx|*.xls|*.csv|*.html|*.htm|*.mhtml|*.md|*.txt)
        vault-extract "$file" --vault "$vault" ;;
    esac
  done < "$file_list"
fi

vault-lint "$vault" --fix

if [[ -n "$git_root" ]]; then
  git -C "$vault" add -A
  if git -C "$vault" diff --cached --quiet; then
    :
  else
    code=$?
    [[ "$code" == 1 ]] || exit "$code"
    git -C "$vault" commit -m 'chore(vault): ingest and repair documents'
  fi
  git_status="$(git -C "$vault" status --porcelain=v1 -uall)"
  [[ -z "$git_status" ]] || { echo "Vault Git changes remain uncommitted" >&2; exit 1; }
fi
