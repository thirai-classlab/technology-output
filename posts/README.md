# 投稿管理ガイド

## ワークフロー

記事はClaude Codeコマンドで管理する。各フェーズを順に実行する。

```
/new-article → /explore → /strategy → /draft → /review → /convert → /post → /track
```

## 記事ディレクトリ構造

```
posts/{NNN}-{slug}/
├── strategy.md          ← 記事戦略（確定事項）
├── explore.md           ← 探索記録（対話の過程）
├── master.md            ← 原本（媒体非依存）
├── track.md             ← 反響記録・振り返り
├── images.md            ← 画像URL一覧（WPがマスター）
└── platforms/
    ├── note.md
    ├── qiita.md
    ├── zenn.md
    ├── wordpress.md
    └── internal-git.md
```

## 投稿対象媒体

| 媒体 | ツール | Mermaid | 特徴 |
|------|--------|---------|------|
| note | note-cli | 非対応→テキスト変換 | ナラティブ、エッセイ調 |
| Qiita | qiita-cli | 対応 | 技術特化、GFM Markdown |
| Zenn | zenn-cli | 対応 | 技術特化、frontmatter必須 |
| WordPress | wordpress-mcp | WP側で対応 | SEO重視、画像マスター |
| 社内Git | GitHub MCP | 対応 | 完全版、PR運用 |

## 画像管理

- 画像はまずWordPressにアップロードし、そのURLを全媒体から参照する
- 各記事の `images.md` にURL一覧を管理する

## 投稿フロー

1. `/convert` で各媒体版を生成
2. `/post` で下書き投稿
3. 各媒体上で下書きを確認
4. 承認後、公開処理を実行
5. 公開後、Slack MCPで社内展開
6. `/track` で反響を収集・分析
