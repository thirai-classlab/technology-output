---
name: post-wordpress
description: WordPress に記事を下書き投稿または公開する。/post コマンドからサブエージェントとして呼び出される。
context: fork
user-invocable: true
---

# WordPress 投稿

`$ARGUMENTS` で指定された記事ディレクトリの `platforms/wordpress.md` を WordPress に投稿する。

## 手順

1. 記事ディレクトリ `$ARGUMENTS` の `platforms/wordpress.md` を Read で読み込む
2. `$ARGUMENTS/strategy.md` から記事タイトル・カテゴリを取得する
3. `$ARGUMENTS/images.md` から画像URLを確認する
4. WordPress REST API で下書き投稿:
   - `curl -X POST "https://takuma-h.sandboxes.jp/wp-json/wp/v2/posts"`
   - 認証: `.mcp.json` の wordpress env を参照
   - `status: draft`
   - SEOコメントからtitle/descriptionを抽出
5. 投稿結果を以下の形式で返す:

```
WordPress: OK
  ID: {post_id}
  編集URL: https://takuma-h.sandboxes.jp/wp-admin/post.php?post={post_id}&action=edit
```

## `--publish` が $ARGUMENTS に含まれる場合

- `$ARGUMENTS/track.md` から下書きIDを取得
- WordPress REST API で status を `publish` に更新
