---
name: post-slack
description: 記事公開後に Slack で社内展開する。/post コマンドからサブエージェントとして呼び出される。
user-invokable: true
---

# Slack 社内展開

記事の公開後、Slack の #input チャンネルに記事情報を投稿する。

## 手順

1. 記事ディレクトリ `$ARGUMENTS` の `track.md` を Read で読み込む
2. `$ARGUMENTS/strategy.md` から記事タイトルとコアメッセージを取得
3. `track.md` の投稿記録テーブルから各媒体の公開URLを収集する
4. **URL検証（必須）**: 収集したURLが以下の条件を全て満たすか確認する。1つでも満たさない場合はエラーとして中断し、URLの修正を促す:
   - 全媒体のURLが記載されている（空欄がない）
   - `editor.note.com` や `/edit/` を含む編集URLではなく、公開URLである
   - `/dashboard` や `/wp-admin/` を含む管理画面URLではなく、公開URLである
   - `?p=` のようなパラメータ付きの仮URLではない（WordPressのパーマリンクが確定していること）
5. Slack MCP で #input チャンネル (C08ACUZ7Z1U) にメッセージ投稿:
   ```
   mcp__slack__conversations_add_message
     channel_id: C08ACUZ7Z1U
     content_type: text/markdown
   ```

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

6. 結果を返す:

```
Slack: OK
  チャンネル: #input
  メッセージ送信完了
```
