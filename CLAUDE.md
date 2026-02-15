# CLAUDE.md - プロジェクト規約

## プロジェクト概要

AI時代のエンジニアスキルセットに関するナレッジを、複数媒体に継続的に投稿するためのプロジェクト。

## 投稿対象媒体とツール

| 媒体 | ツール |
|------|--------|
| note | scripts/post-note.py (API) + note-cli |
| Qiita | qiita-cli |
| Zenn | zenn-cli |
| WordPress | wordpress-mcp |
| 社内Git | GitHub MCP (github-internal: classlab-inc/document/Knowledge) |
| 社内展開 | Slack MCP |

## ワークフロー（8 Phase）

```
INPUT(人間) → EXPLORE(共同) → STRATEGY(共同) → DRAFT(AI) → REVIEW(人間) → CONVERT(AI) → POST(AI/CLI/MCP) → TRACK(共同)
```

- Phase 7: POST は各CLI/MCPで下書き投稿 → 人間が確認 → 公開承認 → 公開。公開後Slackで社内展開
- Phase 8: TRACK は反響を収集・分析し、次の記事にフィードバックする

## ルール管理（.ai/）

2つのドメインに分離して管理する。各作業開始時に対応するルールを読み込む。

```
.ai/
├── dev/                    ← プロジェクト開発ルール
│   ├── structure.md           ディレクトリ構造・命名規則
│   ├── commands.md            カスタムコマンド設計方針
│   └── documentation.md       設計資料の作成ルール
└── content/                ← 記事投稿ルール
    ├── brainstorm/            Phase 2: EXPLORE 時に参照
    ├── strategy/              Phase 3: STRATEGY 時に参照
    ├── writing/               Phase 4: DRAFT 時に参照
    ├── review/                Phase 5: REVIEW 時に参照
    ├── posting/               Phase 6-7: CONVERT・POST 時に参照
    └── track/                 Phase 8: TRACK 時に参照
```

ルールの追加は `/add-rule` コマンドで行う。

## カスタムコマンド

| コマンド | Phase | 用途 |
|----------|-------|------|
| `/new-article` | 1: INPUT | 記事ディレクトリ作成・テンプレート配置 |
| `/explore` | 2: EXPLORE | テーマ深掘り・ペルソナ定義・競合調査 |
| `/strategy` | 3: STRATEGY | explore.mdから戦略を策定 |
| `/draft` | 4: DRAFT | strategy.mdに従いmaster.md執筆 |
| `/review` | 5: REVIEW | レビュー・修正ループ |
| `/convert` | 6: CONVERT | master.mdを5媒体に変換 |
| `/post` | 7: POST | 下書き投稿→確認→公開→Slack展開 |
| `/track` | 8: TRACK | 反響データ収集・分析・改善抽出 |
| `/add-rule` | - | ルール追加・違反チェック・改善 |

## Skills（サブエージェント実行）

`/post` コマンドから Task ツールで並列呼び出しされる投稿スキル。

| Skill | 用途 | 実行方式 |
|-------|------|---------|
| `post-wordpress` | WordPress REST API で投稿 | context: fork |
| `post-qiita` | qiita-cli で投稿 | context: fork |
| `post-zenn` | zenn-cli + git push で投稿 | context: fork |
| `post-note` | note.com API で投稿 | context: fork |
| `post-internal-git` | GitHub API で classlab-inc/document に投稿 | context: fork |
| `post-slack` | Slack MCP で社内展開 | context: fork |
| `post-test` | 全媒体テスト投稿（接続確認） | context: fork |

## ディレクトリ構造

```
.ai/                                ← AIルール管理（dev/ + content/）
.claude/commands/                   ← カスタムコマンド（ワークフロー）
.claude/skills/                    ← スキル（サブエージェント実行）
scripts/                            ← 投稿用スクリプト
articles/                           ← zenn-cli用（/post時にコピー）
public/                             ← qiita-cli用（/post時にコピー）
tests/                              ← テストスクリプト
docs/design/                     ← 設計ドキュメント
posts/
├── README.md                       ← 投稿ガイド
├── {NNN}-{slug}/
│   ├── strategy.md                 ← 記事戦略（確定事項）
│   ├── explore.md                  ← 探索記録（対話の過程）
│   ├── master.md                   ← 原本（媒体非依存）
│   ├── track.md                    ← 反響記録・振り返り
│   ├── images.md                   ← 画像URL一覧（WPがマスター）
│   └── platforms/
│       ├── note.md
│       ├── qiita.md
│       ├── zenn.md
│       ├── wordpress.md
│       └── internal-git.md
```

## コミュニケーションルール

- 設計資料・成果物は `docs/design/` にMarkdownで出力する
- 図解が必要な箇所にはMermaidを使用する
- 資料は完成形として出力し、確認事項や質問を資料内に含めない
- 確認・質問・フィードバック依頼はチャットで行う

## 整合性の維持

- ファイルの追加・変更・削除を行った場合、関連する資料も必ず確認し更新する
- 影響範囲の例:
  - ルール変更 → CLAUDE.md, 01-system-design.md, .ai/README.md
  - ディレクトリ構造変更 → CLAUDE.md, 01-system-design.md, .ai/dev/structure.md
  - コマンド追加・変更 → CLAUDE.md, .ai/dev/commands.md
  - ワークフロー変更 → CLAUDE.md, 01-system-design.md, posts/README.md
  - 設計書の確定 → `.ai/` の該当カテゴリにルール・テンプレート・手順を反映
- 更新漏れが疑われる場合は、作業完了前に関連ファイルを走査して確認する

## 開発方針: テスト駆動開発（TDD）

構築・変更作業はテスト駆動で進める。

1. **テストを先に書く** - 期待する結果を `tests/` にシェルスクリプトで定義する
2. **テストが失敗することを確認** - RED状態
3. **実装する** - テストを通す最小限の実装
4. **テストが成功することを確認** - GREEN状態
5. **リファクタリング** - 必要に応じて改善

### テストの配置

```
tests/
├── run-all.sh              ← 全テスト実行
├── test-structure.sh       ← ディレクトリ構造テスト
├── test-commands.sh        ← コマンドファイル整合性テスト
├── test-tools.sh           ← CLI/MCPツール存在確認テスト
├── test-new-article.sh     ← /new-article 動作テスト
└── test-note-api.sh        ← note API投稿スクリプトテスト
```

### テストの実行

```bash
bash tests/run-all.sh       # 全テスト
bash tests/test-xxx.sh      # 個別テスト
```

## 記事作成の原則

- 各記事にstrategy.md（戦略）を必ず作成してから執筆に入る
- master.md（原本）を先に作成し、各媒体版はそこから変換する
- 探索過程はexplore.mdに記録し、後から振り返れるようにする
- 投稿後はtrack.mdに反響を記録し、次回の戦略に活用する
