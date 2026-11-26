---
type: guide
description: "制作・公開・分析の実行契約"
tags:
  - kafstyler/operation
---

# 制作・公開・分析

| 用途 | 公式入口 |
| --- | --- |
| 共通UI | [KAFKA2306/design](https://github.com/KAFKA2306/design) の採用版と利用先の設定 |
| 画像ワークフロー | [ComfyUI](https://docs.comfy.org/) · [Workflow JSON](https://github.com/Comfy-Org/docs/blob/main/specs/workflow_json.mdx) · [公式テンプレート](https://github.com/Comfy-Org/workflow_templates) |
| 3D生成 | [Tripo API](https://developers.tripo3d.ai/en/docs/introduction) と案件が選ぶモデル |
| 3D処理・レンダリング | [Blender CLI](https://docs.blender.org/manual/en/dev/advanced/command_line/) · [Unity MCP](https://github.com/CoplayDev/unity-mcp) |
| VRChat制作 | [Worlds・UnityMCP-VRC](https://github.com/swax/UnityMCP-VRC) · [Avatars・unity-agent](https://github.com/lighfu/unity-agent) |
| 文書・記事公開 | [Zenn CLI](https://zenn.dev/zenn/articles/zenn-cli-guide) と公開先の公式契約 |
| 金融データ | [MSCI指数方法論](https://www.msci.com/indexes/index-resources/index-methodology) · [S&P指数方法論](https://www.spglobal.com/spdji/en/methodology/article/sp-us-indices-methodology/) と各データ提供元の採用版 |

製品固有のworkflow、Unityプロジェクト、公開先、データ契約、取引方針は対象案件の正本に置く。ここへ個別設定や成果を転記しない。

## 制作・公開・情報収集の具体操作

| 操作 | 定義済みの入口 |
| --- | --- |
| UIの構造と部品 | [Journey](https://github.com/KAFKA2306/design/blob/main/registry/ui/product/journey.ts) · [Decision](https://github.com/KAFKA2306/design/blob/main/registry/ui/product/decision.tsx) · [Content Schema](https://github.com/KAFKA2306/design/blob/main/artifacts/content.schema.json) · [Tokens](https://github.com/KAFKA2306/design/blob/main/tokens/foundation.tokens.json) · [Frontend Skill](https://github.com/KAFKA2306/design/blob/main/skills/frontend-design/SKILL.md)。利用先のdesign.config.jsonで採用版を指定 |
| 画面の生成 | [DemoLab](https://github.com/google-gemini/demolab#installation)、公式Skillを利用 |
| ComfyUIの選定・生成 | [案件共通のworkflow選定](https://github.com/KAFKA2306/comfyui-workflows-factory/blob/main/docs/knowledge/best-workflows.md) → [公式テンプレート](https://github.com/Comfy-Org/workflow_templates) → [Workflow JSON](https://github.com/Comfy-Org/docs/blob/main/specs/workflow_json.mdx)。採用ノード・モデル・seed・入力・出力は案件workflowに固定 |
| 3D生成 | [Tripo Studio](https://www.tripo3d.ai/product-doc) · [Tripo API](https://developers.tripo3d.ai/en/docs/introduction) · [ComfyUI nodes](https://developers.tripo3d.ai/en/docs/comfyui-nodes)。画像からの復元、形状、トポロジー、動作の要求でモデルを選択 |
| 3D編集・自動化 | `blender -b FILE.blend --python SCRIPT.py` / [Blender CLI](https://docs.blender.org/manual/en/latest/advanced/command_line/)。Unityは既存プロジェクトのMCPまたは公式バッチ実行 |
| VRChat | [Worlds MCP](https://github.com/swax/UnityMCP-VRC) · [Modular Avatar Skill](https://github.com/lighfu/unity-agent/blob/master/Editor/Skills/modular-avatar.md) · [Avatar Build Skill](https://github.com/lighfu/unity-agent/blob/master/Editor/Skills/avatar-build.md)。既存Unity環境・SDK・公開権限を利用 |
| 文書・記事 | `npx zenn new:article` / `npx zenn preview`（[Zenn CLI](https://zenn.dev/zenn/articles/zenn-cli-guide)）。[日本語編集](https://imoz.jp/humanizer.ja.txt) · [imozuru](https://github.com/MaryCache/imozuru) · [yomiyasu](https://github.com/nanaism/yomiyasu)：didactizationで用途に合う既存資材のみ使用 |
| 図・可視化 | [Mermaid](https://mermaid.js.org/intro/) · [Graphviz](https://graphviz.org/documentation/)。必要なときだけ成果物に含める |
| 画像・動画・音声 | `magick INPUT OUTPUT`（[ImageMagick](https://imagemagick.org/script/command-line-processing.php)）、`ffmpeg -i INPUT OUTPUT`（[FFmpeg](https://ffmpeg.org/ffmpeg.html)）。出力形式・コーデックは案件で指定 |
| 市場・企業・金融 | 指数は既存のMSCI/S&P方法論、企業は対象の開示・一次データ、信用構造は[BIS](https://www.bis.org/)・[ECB](https://www.ecb.europa.eu/)の公式公開資料。時点依存の数値・データIDを共通台帳に固定しない |
| 公開検索・GEO/AEO | [公開情報運用指針](https://zenn.dev/kafka2306/articles/6dd453d941b99f)。取得先と原文を分け、案件で必要な出典・データを保持する |

## 制作APIの入出力

繰り返す操作はmiseで固定する。ComfyUIの投入は `mise run comfy-submit WORKFLOW.json`、履歴は `mise run comfy-history PROMPT_ID`、成果取得は `mise run comfy-output FILENAME SUBFOLDER TYPE DESTINATION`（ルート直下のSUBFOLDERは空文字）、Tripoの既存タスク照会は `mise run tripo-task TASK_ID`。秘密情報と接続先は利用環境から渡す。生成・ダウンロードは明示的な呼び出しに限る。

GUIで保存したワークフローとAPI用の実行グラフを区別する。外部有料APIを呼ぶ操作は、対象案件で認可されたアカウント・費用・モデル・入力だけに限定する。

| 操作 | 実行契約 |
| --- | --- |
| ComfyUIローカル実行 | API形式のグラフJSONを `POST /prompt` の `prompt` に渡す。返却された `prompt_id` で `GET /history/{prompt_id}` を取得し、出力のfilename/subfolder/typeで `GET /view` を呼ぶ。[公式ルート](https://github.com/Comfy-Org/docs/blob/main/ja/development/comfyui-server/comms_routes.mdx) · [公式例](https://github.com/Comfy-Org/docs/blob/main/ja/development/comfyui-server/api-examples.mdx) |
| Tripo v3 | `POST /v3/files` で素材を登録、`POST /v3/generation/image-to-model` または `/v3/generation/multiview-to-model` で生成し、`GET /v3/tasks/{task_id}` で状態・成果URLを取得する。基点は `https://openapi.tripo3d.ai`、Bearer認証。HTTP成功とAPIの `code=0` を区別し、`status=success` の成果URLだけを利用する。[v3公式契約](https://developers.tripo3d.ai/en/docs/introduction) · [ライフサイクル](https://developers.tripo3d.ai/ja/docs/task-lifecycle) |
| Tripo後処理 | 同じv3契約の `POST /v3/models/texture`、`/v3/models/convert`、`/v3/mesh/decimate`、`/v3/animations/rig`、`/v3/animations/retarget` を要件に応じて使う。対象のモデル・タスクIDを明示し、旧v2契約と混ぜない |

実行は認可済みの `COMFY_URL` とAPI用グラフを指定して `mise run comfy-submit WORKFLOW` → `mise run comfy-history PROMPT_ID` → `mise run comfy-output FILENAME SUBFOLDER TYPE DESTINATION`。既存Tripoタスクの取得は `mise run tripo-task TASK_ID`（`TRIPO_API_KEY` は秘密管理から注入）。有料生成・後処理は認可済みの入力と費用で公式APIを直接利用する。

契約を採用する案件では、実際に使用するモデル・ノード・API版・入力JSON・出力先を案件の正本に固定する。共通台帳は個別の生成設定を保持しない。
