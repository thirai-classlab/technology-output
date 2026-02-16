---
name: post-qiita
description: Qiita に記事を下書き投稿または公開する。/post コマンドからサブエージェントとして呼び出される。
user-invokable: true
---

# Qiita 投稿

`$ARGUMENTS` で指定された記事ディレクトリの `platforms/qiita.md` を Qiita に投稿する。

## 手順

1. 記事ディレクトリ `$ARGUMENTS` の `platforms/qiita.md` を Read で読み込む
2. `$ARGUMENTS/strategy.md` からタグ情報を取得（最大5つ）
3. 記事内容を `public/{slug}.md` に qiita-cli フォーマットで書き出す:
   ```yaml
   ---
   title: {タイトル}
   tags:
     - {tag1}
     - {tag2}
   private: true
   updated_at: ''
   id: null
   organization_url_name: null
   slide: false
   ignorePublish: false
   ---
   ```
4. Bash で `npx qiita publish {slug}` を実行
5. 投稿後、`public/{slug}.md` の frontmatter から `id` を取得
6. 結果を返す:

```
Qiita: OK
  ID: {article_id}
  URL: https://qiita.com/takuma-h/private/{article_id}
```

## `--publish` が $ARGUMENTS に含まれる場合

- `public/{slug}.md` の `private: false` に変更
- `npx qiita publish {slug}` で再投稿
