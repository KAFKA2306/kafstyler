#!/usr/bin/env bash

host=${2:-claude}
if [ "$host" = codex ]; then
  plugin_root=$PLUGIN_ROOT
else
  plugin_root=$CLAUDE_PLUGIN_ROOT
fi

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
      # SubagentStart の追加指示は JSON で渡す。
      context=$(printf '%s\n%s\n\n%s' \
        '委譲された作業にKafstylerの作業規約を適用する。親から受け取った合格条件を使い、確認した結果と見つけた漏れを親に返す。' \
        "$location" "$policy")
      context=${context//\\/\\\\}
      context=${context//\"/\\\"}
      context=${context//$'\n'/\\n}
      context=${context//$'\r'/\\r}
      context=${context//$'\t'/\\t}
      printf '{"hookSpecificOutput":{"hookEventName":"SubagentStart","additionalContext":"%s"}}\n' "$context"
    fi
    ;;
  start)
    if [ "$host" = codex ]; then
      printf '以下で指定するKafstylerのスキルは %s/skills/ にある。対象の SKILL.md を読み、その手順を今回の依頼で実行する。\n' "$plugin_root"
    else
      printf '%s\n' 'KafstylerのスキルはClaude Codeの Skill ツールで呼び出す。'
    fi
    cat <<'EOF'
今回の依頼にKafstylerを適用する。作業前に kafstyler:charter を使い、普段の利用経路、合格条件、品質を上げる指標を決める。同じ依頼で実行済みなら結果を使う。依頼に合うスキルを実行し、成果物は提出前に kafstyler:benchmark、人向けの文書は kafstyler:humanizer で確かめる。短い会話は必要な確認をその場で行う。判明した不合格は許可範囲で直し、同じ条件で再評価する。
EOF
    ;;
  review)
    # Stop が続行したターンでは、もう一度再開させない。
    if grep -qE '(^|[,{])[[:space:]]*"stop_hook_active"[[:space:]]*:[[:space:]]*false[[:space:]]*[,}]'; then
      context='Kafstylerの提出前確認。ユーザーが依頼した範囲と中断指示を守る。短い会話は回答を見直して終える。成果物は実物と合格条件を照合し、証拠が足りなければ kafstyler:benchmark を使い、普段の入口から確認する。人向けの文書は kafstyler:humanizer で読者の用事、根拠、手順を確かめる。実施済みで同じ版の検証は使い、欠陥を直した箇所は同じ入力で再評価する。変更前や現行案と比べて観測できた改善を示し、合否と未確認事項を区別する。Kafstylerの手順に再現できる漏れがあれば kafstyler:charter の改善手順を使ってから元の依頼に戻る。根拠のある未達を解消できる間は作業を続け、制約で止まる場合は未達の項目と再開条件を示す。'
      if [ "$host" = codex ]; then
        printf '{"decision":"block","reason":"%s"}\n' "$context"
      else
        printf '{"hookSpecificOutput":{"hookEventName":"Stop","additionalContext":"%s"}}\n' "$context"
      fi
    else
      printf '{}\n'
    fi
    ;;
esac
