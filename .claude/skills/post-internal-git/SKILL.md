---
name: post-internal-git
description: 社内Git（classlab-inc/document/Knowledge）に記事を投稿する。/post コマンドからサブエージェントとして呼び出される。
context: fork
user-invocable: true
---

# 社内Git 投稿

`$ARGUMENTS` で指定された記事ディレクトリの `platforms/internal-git.md` を classlab-inc/document リポジトリに投稿する。

## 手順

1. 記事ディレクトリ `$ARGUMENTS` の `platforms/internal-git.md` を Read で読み込む
2. `$ARGUMENTS/strategy.md` から記事タイトル・slug を取得
3. `.mcp.json` から `github-internal` の PAT を Read で取得
4. Bash で GitHub API を使って投稿:
   ```bash
   curl -X PUT "https://api.github.com/repos/classlab-inc/document/contents/Knowledge/{slug}.md" \
     -H "Authorization: Bearer {PAT}" \
     -H "Content-Type: application/json" \
     -d '{"message": "post: {タイトル}", "content": "{base64encoded}", "branch": "master"}'
   ```
   - 既存ファイルがある場合は先にSHAを取得してから更新
5. 結果を返す:

```
社内Git: OK
  URL: https://github.com/classlab-inc/document/blob/master/Knowledge/{slug}.md
```
