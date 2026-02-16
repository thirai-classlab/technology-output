---
name: post-zenn
description: Zenn に記事を下書き投稿または公開する。/post コマンドからサブエージェントとして呼び出される。
user-invokable: true
---

# Zenn 投稿

`$ARGUMENTS` で指定された記事ディレクトリの `platforms/zenn.md` を Zenn に投稿する。

## 手順

1. 記事ディレクトリ `$ARGUMENTS` の `platforms/zenn.md` を Read で読み込む
2. `$ARGUMENTS/strategy.md` からトピック・タイトル・emoji 情報を取得
3. 記事内容を `articles/{slug}.md` に zenn-cli フォーマットで書き出す:
   ```yaml
   ---
   title: "{タイトル}"
   emoji: "{emoji}"
   type: "tech"
   topics: ["{topic1}", "{topic2}"]
   published: false
   ---
   ```
   - slugは12〜50文字、a-z0-9 とハイフンのみ
4. Bash で以下を実行:
   ```
   git add articles/{slug}.md && git commit -m "post: {タイトル}（Zenn下書き）" && git push
   ```
5. 結果を返す:

```
Zenn: OK
  ファイル: articles/{slug}.md
  確認URL: https://zenn.dev/dashboard
  published: false
```

## `--publish` が $ARGUMENTS に含まれる場合

- `articles/{slug}.md` の `published: true` に変更
- git commit + push で自動デプロイ
