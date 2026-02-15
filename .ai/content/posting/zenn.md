# Zenn 投稿ルール

## フォーマット

- frontmatter（YAML）必須:
  ```yaml
  ---
  title: "記事タイトル"
  emoji: "適切な絵文字"
  type: "tech"
  topics: ["トピック1", "トピック2"]
  published: true
  ---
  ```
- GFM Markdown対応
- Mermaid対応
- Zenn独自記法: メッセージボックス（:::message）等を活用

## 構成

- 冒頭に概要
- 技術的に正確・具体的な内容
- 末尾に参考リンク

## トーン

- 技術記事調（ですます体）

## 投稿手段

- zenn-cli（https://zenn.dev/zenn/articles/install-zenn-cli）
- `npx zenn preview` でローカルプレビュー → 確認 → git push で公開
- 下書き確認時は `published: false` でpush、公開時に `published: true` に変更
