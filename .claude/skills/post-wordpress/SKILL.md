---
name: post-wordpress
description: WordPress に記事を下書き投稿または公開する。/post コマンドからサブエージェントとして呼び出される。
user-invokable: true
---

# WordPress 投稿

`$ARGUMENTS` で指定された記事ディレクトリの `platforms/wordpress.md` を WordPress に投稿する。

## WordPress 環境

- サイト: `https://takuma-h.sandboxes.jp/`
- テーマ: `engineer-blog` v1.0.0（独自テーマ）
- API: WordPress REST API (`/wp-json/wp/v2/posts`)
- MCP: `wordpress-production`（MCP Adapter + SSH）
- テーマ全機能リファレンス: `docs/design/wp-shortcode-reference.md`

## 手順

1. 記事ディレクトリ `$ARGUMENTS` の `platforms/wordpress.md` を Read で読み込む
2. `$ARGUMENTS/strategy.md` から記事タイトル・カテゴリ・タグ情報を取得する
3. `$ARGUMENTS/images.md` から画像URLを確認する
4. 投稿コンテンツを確認する:
   - Gutenberg ブロックコメント（`<!-- wp:paragraph -->` 等）で構造化されていること
   - ショートコード（`[note]`, `[steps]`, `[timeline]` 等）がブロックの外に配置されていること
   - コードブロックが `<pre class="language-xxx" data-lang="Xxx">` 形式であること
   - Mermaid 図が `<pre class="mermaid">` で囲まれていること
5. WordPress REST API で下書き投稿:
   - `curl -X POST "https://takuma-h.sandboxes.jp/wp-json/wp/v2/posts"`
   - 認証: `.mcp.json` の wordpress env を参照
   - `status: draft`
   - SEOコメントから title/description を抽出
   - カテゴリ・タグを設定
6. 投稿結果を以下の形式で返す:

```
WordPress: OK
  ID: {post_id}
  編集URL: https://takuma-h.sandboxes.jp/wp-admin/post.php?post={post_id}&action=edit
  プレビューURL: https://takuma-h.sandboxes.jp/?p={post_id}&preview=true
```

## `--publish` が $ARGUMENTS に含まれる場合

- `$ARGUMENTS/track.md` から下書きIDを取得
- WordPress REST API で status を `publish` に更新

## テーマ対応ショートコード（engineer-blog）

投稿コンテンツで使用可能なショートコード一覧。変換ルールの詳細は `docs/design/wp-shortcode-reference.md` を参照。

### ブロック型ショートコード

| ショートコード | 用途 |
|--------------|------|
| `[note]...[/note]` | 注釈ボックス（青） |
| `[warning]...[/warning]` | 警告ボックス（黄） |
| `[tip]...[/tip]` | ヒントボックス（緑） |
| `[info]...[/info]` | 情報ボックス（紫） |
| `[quote author="" source="" url=""]...[/quote]` | 出典付き引用 |
| `[timeline]...[/timeline]` | タイムライン |
| `[steps]...[/steps]` | ステップガイド |
| `[link_card url="" title="" description=""]` | リンクカード |
| `[amazon asin="" title="" price="" image=""]` | Amazonリンク |
| `[accordion]...[/accordion]` | 折りたたみ |
| `[columns count="2"]...[/columns]` | カラムレイアウト |
| `[comparison title_a="" title_b=""]...[/comparison]` | 比較テーブル |

### インライン型ショートコード（`<p>` タグ内で使用）

| ショートコード | 用途 |
|--------------|------|
| `[badge color="primary"]...[/badge]` | バッジ（primary/accent/warning/danger） |
| `[marker color="yellow"]...[/marker]` | マーカー（yellow/blue/pink/green） |

### 注意事項

- ブロック型ショートコードは `<!-- wp:paragraph -->` の外（トップレベル）に配置する
- インライン型ショートコードは `<p>` タグ内で使用可能
- ショートコード名を本文中にコード表示する場合は `&#91;note&#93;` とエスケープする

## コードブロック（Prism.js 12言語対応）

`<pre class="language-xxx" data-lang="Xxx"><code>...</code></pre>` 形式で記述。
対応言語: JavaScript, TypeScript, Python, PHP, Bash, Go, Rust, SQL, JSON, YAML, Diff, Markdown

## Mermaid.js 図解（4種類）

`<pre class="mermaid">...</div>` で囲むと自動レンダリング。
対応: フローチャート、シーケンス図、ガントチャート、クラス図

## テーマ自動機能

以下は記事投稿時に自動適用される（変換・投稿時の対応不要）:
- 目次（TOC）: H2/H3 から自動生成
- 読了時間: 日本語600文字/分で自動計算
- 閲覧数・いいね: 自動カウント + サイドバーランキング
- シェアボタン: X / Facebook / はてブ / URLコピー
- 著者プロフィール・関連記事・クロスプラットフォームCTA
- OGP/SEO メタタグ・GA4 イベント
- リーディングプログレスバー・パンくずリスト
