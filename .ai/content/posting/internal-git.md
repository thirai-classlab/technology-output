# 社内Git 投稿ルール

## リポジトリ情報

- Org: `classlab-inc`
- リポジトリ: `classlab-inc/document`
- 投稿先: `Knowledge/` ディレクトリ
- ブランチ: `master`
- MCP設定名: `github-internal`（.mcp.json）

## フォーマット

- 標準Markdown（GFM）
- Mermaid対応（GitHub がレンダリング）
- テーブル・コードブロック制約なし

## 構成

- master.md をベースに社内向け補足を追加
- 社内ツール・プロセスへの言及OK
- 外部公開不可の情報を含めてよい

## トーン

- フラットな技術文書調

## 投稿手段

- GitHub API（`.mcp.json` の `github-internal` PATで認証）
- `PUT /repos/classlab-inc/document/contents/Knowledge/{slug}.md`
- masterブランチに直接コミット（社内リポジトリのため）
