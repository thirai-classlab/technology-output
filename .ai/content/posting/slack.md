# Slack 社内展開ルール

## 概要

全媒体の公開完了後、Slack で社内に記事情報を展開する。

## 投稿先

| 項目 | 値 |
|------|---|
| チャンネル | #input |
| チャンネルID | C08ACUZ7Z1U |
| ツール | Slack MCP (`mcp__slack__conversations_add_message`) |
| フォーマット | text/markdown |

## タイミング

- 全媒体の公開が完了し、track.md に全公開URLが記録された後に実行する
- バックグラウンドエージェントが実行中の場合は全エージェントの完了を待つ

## URL検証（必須）

Slack投稿前に以下を全て確認する。1つでも不合格の場合はエラーとして中断する:

- 全媒体のURLが記載されている（空欄がない）
- `editor.note.com` や `/edit/` を含む編集URLではなく、公開URLである
- `/dashboard` や `/wp-admin/` を含む管理画面URLではなく、公開URLである
- `?p=` のようなパラメータ付きの仮URLではない（WordPressのパーマリンクが確定していること）

## メッセージテンプレート

```markdown
## 新しい記事を公開しました

**{記事タイトル}**

{コアメッセージ}

### 各媒体リンク
- note: {url}
- Qiita: {url}
- Zenn: {url}
- WordPress: {url}
- 社内Git: {url}

フィードバックお待ちしています！
```

## データソース

- 記事タイトル・コアメッセージ: `strategy.md` から取得
- 各媒体URL: `track.md` の投稿記録テーブルから取得
