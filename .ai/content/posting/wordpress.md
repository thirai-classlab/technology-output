# WordPress 投稿ルール

## 変換の前提

- master.md → wordpress.md への変換時、必ず `docs/design/wp-shortcode-reference.md` を読み込む
- ショートコードとHTMLスタイルの仕様はすべて上記リファレンスに記載されている
- リファレンスの「変換時の推奨マッピング」表に従って Markdown → WordPress 形式に変換する

## フォーマット

- Gutenbergブロックコメント付きHTML + ショートコード
- Mermaid対応（`<div class="mermaid">` で囲む）
- SEOメタ情報を記事冒頭にコメントで記載:
  ```
  <!-- SEO
  title: SEOタイトル（60字以内）
  description: メタディスクリプション（120字以内）
  category: カテゴリ
  tags: タグ1, タグ2
  -->
  ```

## ショートコード使用ルール

- ブロックレベルのショートコードは `<!-- wp:paragraph -->` の外に単独行で記述する
- インラインショートコード（`[badge]`, `[marker]`）は `<p>` タグ内で使用可能
- 本文中にショートコード名をコード表示する場合は `&#91;note&#93;` でエスケープする
- 注意・補足 → `[note]` / `[warning]` / `[tip]` / `[info]`
- 手順説明 → `[steps]` + `[step]`
- FAQ → `[accordion]` + `[accordion_item]`
- 外部参考リンク → `[link_card]`
- 書籍紹介 → `[amazon]`
- 強調キーワード → `[marker]` または `[badge]`
- 時系列 → `[timeline]` + `[timeline_item]`
- 比較 → `[comparison]` + テーブル
- レイアウト分割 → `[columns]` + `[column]`
- 出典付き引用 → `[quote]`

## コードブロック

- `<pre class="language-xxx" data-lang="Label"><code>...</code></pre>` 形式
- `data-lang` 属性で右上にラベルバッジを表示（JavaScript, Python, PHP, Shell 等）

## 画像

- WordPressのメディアライブラリが画像のマスターストレージ
- MCPでアップロードし、他の全媒体からもこのURLを参照する

## 構成

- H2/H3で明確な階層構造（SEO考慮）
- 冒頭にリード文
- 目次は自動生成（テーマ機能）
- 末尾にCTAと関連記事リンク（テーマ機能）

## トーン

- 丁寧なですます体
- 検索意図を意識した見出し

## 投稿手段

- WordPress REST API（ブラウザ認証 or wp.apiFetch）
- 下書き投稿 → 確認 → 公開の流れ
- 公開後、Slack MCPで社内に展開
