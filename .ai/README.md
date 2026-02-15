# .ai/ - プロジェクトルール管理

AIが参照するルール集。2つのドメインに分離して管理する。

## ドメイン

```
.ai/
├── dev/                ← プロジェクト開発ルール（この仕組み自体の構築・改善）
└── content/            ← 記事投稿ルール（コンテンツのワークフロー）
```

### dev/（開発ルール）

プロジェクトの構造・コマンド・設定・自動化など、仕組み自体の開発に関するルール。

| ファイル | 内容 |
|----------|------|
| structure.md | ディレクトリ構造・命名規則 |
| commands.md | カスタムコマンドの設計方針 |
| documentation.md | 設計資料の作成ルール |

### content/（記事投稿ルール）

記事のライフサイクル各Phaseで参照するルール。

| サブカテゴリ | 参照タイミング | 主なファイル |
|-------------|----------------|-------------|
| brainstorm/ | Phase 2: EXPLORE | explore.md |
| strategy/ | Phase 3: STRATEGY | strategy.md |
| writing/ | Phase 4: DRAFT | draft.md |
| review/ | Phase 5: REVIEW | review.md |
| posting/ | Phase 6-7: CONVERT・POST | common.md, {媒体名}.md |
| track/ | Phase 8: TRACK | track.md |

## ルールの追加

`/add-rule` コマンドを使用する。ドメイン（dev / content）とカテゴリを指定して追加する。
