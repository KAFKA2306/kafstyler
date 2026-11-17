#!/bin/sh

case "$1" in
  start)
    cat <<'EOF'
今回の依頼にKafstylerを適用する。作業前に Skill で kafstyler:charter を呼び、普段の利用経路、合格条件、品質を上げる指標を決める。同じ依頼で実行済みなら結果を使う。依頼に合うスキルを実行し、成果物は提出前に kafstyler:benchmark、人向けの文書は kafstyler:humanizer で確かめる。短い会話は必要な確認をその場で行う。判明した不合格は許可範囲で直し、同じ条件で再評価する。
EOF
    ;;
  review)
    # Claude Code が送る Stop 入力の真偽値を読み、同じターンでの再起動を防ぐ。
    if grep -qE '(^|[,{])[[:space:]]*"stop_hook_active"[[:space:]]*:[[:space:]]*false[[:space:]]*[,}]'; then
      cat <<'EOF'
{"hookSpecificOutput":{"hookEventName":"Stop","additionalContext":"Kafstylerの提出前確認。ユーザーが依頼した範囲と中断指示を守る。短い会話は回答を見直して終える。成果物は実物と合格条件を照合し、証拠が足りなければ Skill で kafstyler:benchmark を呼び、普段の入口から確認する。人向けの文書は kafstyler:humanizer で読者の用事、根拠、手順を確かめる。実施済みで同じ版の検証は使い、欠陥を直した箇所は同じ入力で再評価する。変更前や現行案と比べて観測できた改善を示し、合否と未確認事項を区別する。Kafstylerの手順に再現できる漏れがあれば kafstyler:charter の改善手順を使ってから元の依頼に戻る。根拠のある未達を解消できる間は作業を続け、制約で止まる場合は未達の項目と再開条件を示す。"}}
EOF
    fi
    ;;
esac
