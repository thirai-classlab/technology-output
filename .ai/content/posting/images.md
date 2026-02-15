# 画像URL管理ルール

## マスターストレージ

- WordPressのメディアライブラリを画像の唯一の保管場所（Single Source of Truth）とする
- 全媒体の記事からWordPress上の画像URLを参照する

## アップロードフロー

1. 画像ファイルを用意する（作成 or スクリーンショット or 素材）
2. MCPでWordPressのメディアライブラリにアップロードする
3. アップロード後のURLを記録する
4. 各媒体の記事でそのURLを使用する

## URL管理

- 各記事ディレクトリに `images.md` を作成し、画像URLを一覧管理する
- フォーマット:

```markdown
# 画像一覧

| # | ファイル名 | 用途 | WordPress URL |
|---|-----------|------|---------------|
| 1 | overview-flow.png | 全体フロー図 | https://example.com/wp-content/uploads/2026/02/overview-flow.png |
| 2 | skill-matrix.png | スキルマトリクス | https://example.com/wp-content/uploads/2026/02/skill-matrix.png |
```

## 記事内での参照

各媒体の記事では以下の形式で参照する:

```markdown
![全体フロー図](https://example.com/wp-content/uploads/2026/02/overview-flow.png)
```

## 命名規則

- ファイル名: `{記事slug}-{内容}.{拡張子}`
- 例: `ai-skillset-overview-flow.png`
- 英字小文字・ハイフン区切り
- 記事slugを接頭辞にして他の記事の画像と区別する

## 注意事項

- 画像の差し替えはWordPress上で同じURLに上書きアップロードする
- 画像を削除する場合は全媒体から参照が消えていることを確認してから行う
- 社内Gitで外部URL参照が不可の場合は、リポジトリ内にもコピーを配置する
