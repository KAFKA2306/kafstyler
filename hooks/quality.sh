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

json_string() {
  local value=$1
  value=${value//\\/\\\\}
  value=${value//\"/\\\"}
  value=${value//$'\n'/\\n}
  value=${value//$'\r'/\\r}
  value=${value//$'\t'/\\t}
  value=${value//$'\b'/\\b}
  value=${value//$'\f'/\\f}
  printf '"%s"' "$value"
}

case "$1" in
  session|subagent)
    policy_path="$plugin_root/AGENTS.md"
    policy=$(cat "$policy_path") || exit 1
    location="規約の場所は $policy_path。相対リンクはこのファイルを基準にたどる。全文が届いていなければ、このファイルを読む。"

    if [ "$1" = session ]; then
      printf '%s\n%s\n\n%s\n' \
        'このセッションにKafstylerの作業規約を適用する。Kafstyler本体の保守規約は本体を変更するときに適用する。' \
        "$location" "$policy"
    else
      routes=$(skill_routes) || exit 1
      context=$(printf '%s\n%s\n\n%s\n\n%s' \
        '委譲された作業にKafstylerの作業規約を適用する。親から受け取った合格条件を使い、確認した結果と見つけた漏れを親に返す。' \
        "$routes" "$location" "$policy")
      printf '{"hookSpecificOutput":{"hookEventName":"SubagentStart","additionalContext":%s}}\n' "$(json_string "$context")"
    fi
    ;;
  start)
    printf '使用中のKafstylerの場所は %s。\n' "$plugin_root"
    skill_routes || exit 1
    cat <<'PROMPT'
成果を届ける依頼では、着手前に kafstyler:charter で利用経路と合格条件を決める。各スキルの手順を実行し、成果や観測結果を元の作業に反映する。同じ対象・版・入力・合格条件で必要な証拠がそろっていれば再利用する。実行中のスキルは再び呼ばない。
コミットは毎回、同梱の AGENTS.md の「ブランチとコミット」に従う。コミットだけの依頼や GitHub API で作成する場合も、作成直前に同じ手順を適用する。
Kafstyler本体を変更する場合は、着手前の main のコミットを記録し、その版の AGENTS.md と該当スキルを使う。「Kafstyler本体の変更」に従って、作業前の版と変更案を同じ合格条件で比べる。
PROMPT
    if checkout=$(kafstyler_checkout); then
      printf '%s\n' '本体を保守するときは、ルートで python3 hooks/check.py --markdown-inventory を実行し、全Markdownに全スキルを使う。見つけた漏れを直し、文書とスキルの組ごとの結果を記録する。子や個々のスキルは全件確認を起動し直さない。'
    fi
    ;;
  review)
    # Stop が続行したターンでは、もう一度再開させない。
    if grep -qE '(^|[,{])[[:space:]]*"stop_hook_active"[[:space:]]*:[[:space:]]*false[[:space:]]*([,}]|$)'; then
      routes=$(skill_routes) || exit 1
      context=$(cat <<PROMPT
Kafstylerの提出前確認。ユーザーの依頼範囲と中断指示を守る。短いやりとりは回答を見直して終える。利用者への報告は同梱の AGENTS.md の「出力と成果物」に従う。着手時と途中で必須になったスキルごとに、対象の版、実行結果、根拠を照合する。指定された段階を過ぎて漏れを見つけたらそのスキルを実行し、影響する設計、変更、検証をやり直す。未実行、実行失敗、合否を左右する未確認が残る工程は完了扱いにしない。許可範囲で不足を解消し、残る場合は止まった操作と理由、再開条件を示す。Kafstylerの手順に再現できる漏れがあれば kafstyler:charter の改善手順を使う。
Kafstyler本体を変更した場合は、変更案に対して着手前の版の検査と python3 hooks/check.py を実行する。変更案を読み込んだセッションで影響する操作を試し、確認した版と結果を作業記録に残す。

$routes
PROMPT
)
      if checkout=$(kafstyler_checkout); then
        if ! result=$(cd "$checkout" && python3 "$plugin_root/hooks/check.py" --markdown-only 2>&1); then
          result=$(printf '%s\n%s' "$result" '本体の保守作業では、不足するスキルを現行版に適用して記録を直し、検証をやり直す。未確認が残る場合は完了扱いにしない。')
        fi
        context=$(printf '%s\n\n%s\n%s' "$context" '本体のMarkdown適用記録の照合結果' "$result")
      fi
      if [ "$host" = codex ]; then
        printf '{"decision":"block","reason":%s}\n' "$(json_string "$context")"
      else
        printf '{"hookSpecificOutput":{"hookEventName":"Stop","additionalContext":%s}}\n' "$(json_string "$context")"
      fi
    else
      printf '{}\n'
    fi
    ;;
esac
