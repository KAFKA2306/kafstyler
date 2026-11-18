#!/usr/bin/env bash

host=${2:-claude}
if [ "$host" = codex ]; then
  plugin_root=$PLUGIN_ROOT
  skill_call="Codexでは次の各スキルの SKILL.md を $plugin_root/skills/ 以下から読み、手順を実行する。"
else
  plugin_root=$CLAUDE_PLUGIN_ROOT
  skill_call='Claude Codeでは次のスキルを Skill ツールで呼び、対象と作業範囲を渡す。'
fi

skill_routes() {
  printf '%s\n' \
    '着手前と新しい工程が判明した時点で、依頼と必要な工程を各スキルの適用条件に照らす。明示指定されたスキルと該当するスキルは、依頼と権限の範囲ですべて必須とし、指定された段階で実行する。挨拶など、成果物の作成・調査・検証を伴わない短いやりとりは、その場で目的と答えを確かめる。' \
    "$skill_call"
  awk '
    FNR == 1 {
      count = split(FILENAME, parts, "/")
      name = parts[count - 1]
      frontmatter = ($0 == "---")
      next
    }
    frontmatter && /^---$/ { frontmatter = 0 }
    frontmatter && /^description: "[^"]+"$/ {
      sub(/^description: "/, "")
      sub(/"$/, "")
      printf "- kafstyler:%s — %s\n", name, $0
    }
  ' "$plugin_root"/skills/*/SKILL.md
}

kafstyler_checkout() {
  local checkout
  checkout=$(git rev-parse --show-toplevel 2>/dev/null) || return
  [ -f "$checkout/.agents/plugins/marketplace.json" ] &&
    grep -qE '"name"[[:space:]]*:[[:space:]]*"kafstyler"' "$checkout/.codex-plugin/plugin.json" 2>/dev/null &&
    printf '%s\n' "$checkout"
}

case "$1" in
  session)
    policy_path="$plugin_root/AGENTS.md"
    policy=$(cat "$policy_path") || exit 1
    printf '%s\n%s\n\n%s\n' \
      'このセッションにKafstylerの作業規約を適用する。Kafstyler本体の保守規約は本体を変更するときに適用する。' \
      "規約の場所は $policy_path。相対リンクはこのファイルを基準にたどる。全文が届いていなければ、このファイルを読む。" \
      "$policy"
    ;;
  start)
    printf '使用中のKafstylerの場所は %s。\n' "$plugin_root"
    skill_routes || exit 1
    cat <<'PROMPT'
成果を届ける依頼では、着手前に kafstyler:charter で利用経路と合格条件を決める。各スキルの手順を実行し、成果や観測結果を元の作業に反映する。同じ対象・版・入力・合格条件で必要な証拠がそろっていれば再利用する。実行中のスキルは再び呼ばない。
成果を届ける依頼では、同梱の AGENTS.md の「作業台帳」に従い、着手時に今回の作業を必ず登録する。既存の正本を使い、未作成なら許可された保存先に作る。
コミットは毎回、同梱の AGENTS.md の「ブランチとコミット」に従う。コミットだけの依頼や GitHub API で作成する場合も、作成直前に同じ手順を適用する。
Kafstyler本体を変更する場合は、着手前の main のコミットを記録し、その版の AGENTS.md と該当スキルを使う。「Kafstyler本体の変更」に従って、作業前の版と変更案を同じ合格条件で比べる。
PROMPT
    if checkout=$(kafstyler_checkout); then
      printf '%s\n' '本体を保守するときは、ルートで python3 hooks/check.py --markdown-inventory を実行し、全Markdownに全スキルを使う。見つけた漏れを直し、文書とスキルの組ごとの結果を記録する。子や個々のスキルは全件確認を起動し直さない。'
    fi
    ;;
esac
