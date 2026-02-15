# カスタムコマンドの設計方針

## 配置

- `.claude/commands/` にMarkdownファイルとして配置する
- ファイル名がコマンド名になる（例: `add-rule.md` → `/add-rule`）

## 設計原則

- 1コマンド1責務
- 引数は `$ARGUMENTS` で受け取る
- 対話が必要な場合はチャットでヒアリングする
- 破壊的操作は必ずユーザー承認を得る

## コマンド一覧

| コマンド | Phase | 用途 | サブエージェント活用 |
|----------|-------|------|---------------------|
| `/new-article` | 1: INPUT | 記事ディレクトリ作成・テンプレート配置 | なし |
| `/explore` | 2: EXPLORE | テーマ深掘り・ペルソナ定義・競合調査 | Web検索を並列実行 |
| `/strategy` | 3: STRATEGY | explore.mdから戦略を策定 | track.md参照で学び反映 |
| `/draft` | 4: DRAFT | strategy.mdに従いmaster.md執筆 | セクション並列執筆 |
| `/review` | 5: REVIEW | レビュー・修正ループ | strategy整合性チェック |
| `/convert` | 6: CONVERT | master.mdを5媒体に変換 | 5媒体を並列変換 |
| `/post` | 7: POST | 下書き投稿→確認→公開→Slack展開 | 各CLI/MCPで並列投稿 |
| `/track` | 8: TRACK | 反響データ収集・分析・改善抽出 | 各媒体から並列収集 |
| `/add-rule` | - | ルール追加・違反チェック・改善 | 違反走査 |
