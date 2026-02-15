# 投稿テストルール

## 概要

全媒体への接続・認証を確認するためのテスト投稿ルール。

## テスト記事仕様

```
タイトル: 【テスト】投稿テスト記事（削除予定）
本文: 投稿システムの動作確認用テスト記事です。テスト完了後に削除します。
```

## 各媒体のテスト手順

| 媒体 | テスト方法 | 下書き状態 |
|------|-----------|-----------|
| WordPress | REST API で `status: draft` 投稿 | 下書き |
| Qiita | `public/test-draft.md` 作成 → `npx qiita publish` | `private: true` |
| Zenn | `articles/test-draft-{YYYYMMDD}.md` 作成 → git push | `published: false` |
| note | `scripts/post-note.py draft` で投稿 | 下書き |
| 社内Git | GitHub API で `Knowledge/test-draft.md` 作成 | 直接コミット |

## 実行方式

- Task ツールで5媒体を並列実行する
- 各媒体の結果（OK/NG + URL）を集約して報告する

## 結果出力フォーマット

```
| 媒体 | ステータス | URL |
|------|-----------|-----|
| WordPress | OK / NG | {url} |
| Qiita | OK / NG | {url} |
| Zenn | OK / NG | {url} |
| note | OK / NG | {url} |
| 社内Git | OK / NG | {url} |
```

## テスト後の削除

人間の確認後、全テスト記事を削除する:

| 媒体 | 削除方法 |
|------|---------|
| WordPress | REST API で `DELETE /wp-json/wp/v2/posts/{id}?force=true` |
| Qiita | `curl -X DELETE` で API 削除 |
| Zenn | ファイル削除 + git push |
| note | ダッシュボードから手動削除 |
| 社内Git | GitHub API で `DELETE` |
