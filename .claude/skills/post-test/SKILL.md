---
name: post-test
description: 全媒体にテスト記事を下書き投稿し、接続・認証の動作確認を行う。
user-invokable: true
---

# 投稿テスト

全媒体にテスト記事を下書き投稿し、接続・認証を確認する。

## テスト記事

```
タイトル: 【テスト】投稿テスト記事（削除予定）
本文: 投稿システムの動作確認用テスト記事です。テスト完了後に削除します。
```

## 手順

以下を **Task ツールで並列実行** する:

### Qiita
1. `public/test-draft.md` を作成（private: true）
2. `npx qiita publish test-draft`
3. IDとURLを記録

### Zenn
1. `articles/test-draft-{YYYYMMDD}.md` を作成（published: false）
2. git add → commit → push
3. ダッシュボードURLを記録

### WordPress
1. REST API で status: draft として投稿
2. IDとURLを記録

### note
1. テスト用Markdownファイルを一時作成し `python3 scripts/post-note.py draft --title "【テスト】投稿テスト記事（削除予定）" --file {テストファイル}` で投稿
2. IDとURLを記録

### 社内Git
1. GitHub API で `classlab-inc/document/Knowledge/test-draft.md` を作成
2. URLを記録

## 結果出力

```
| 媒体 | ステータス | URL |
|------|-----------|-----|
| Qiita | OK / NG | {url} |
| Zenn | OK / NG | {url} |
| WordPress | OK / NG | {url} |
| note | OK / NG | {url} |
| 社内Git | OK / NG | {url} |
```

## テスト後の削除

人間の確認後、全テスト記事を削除:
- Qiita: `curl -X DELETE "https://qiita.com/api/v2/items/{id}" -H "Authorization: Bearer {token}"`
- Zenn: ファイル削除 + git push
- WordPress: `curl -X DELETE "{url}/wp-json/wp/v2/posts/{id}?force=true"`
- note: ダッシュボードから手動削除
- 社内Git: `curl -X DELETE` でファイル削除
