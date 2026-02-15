# WordPress ショートコード & HTMLスタイル リファレンス

Engineer Blog テーマ（engineer-blog）で使用可能なショートコードとHTMLスタイルの一覧。
`/convert` で master.md → wordpress.md に変換する際、この仕様に従ってリッチなコンテンツを生成する。

---

## 注意事項

- ショートコードはブロックレベル（単独行）で記述する。`<!-- wp:paragraph -->` の中に入れない
- ショートコード名を本文中にコード表示したい場合は `&#91;note&#93;` のようにHTMLエンティティでエスケープする
- インラインショートコード（`[badge]`, `[marker]`）は `<!-- wp:paragraph -->` 内の `<p>` タグの中で使用可能

---

## ショートコード一覧

### 1. 注釈ボックス（Callout）

4種類のカラーバリエーション。補足情報や注意事項の強調に使用。

```
[note]補足情報のテキスト[/note]
[warning]注意事項のテキスト[/warning]
[tip]ヒントのテキスト[/tip]
[info]一般情報のテキスト[/info]
```

| 属性 | 必須 | 説明 |
|------|------|------|
| `title` | - | ヘッダーラベルを上書き（デフォルト: Note/Warning/Tip/Info） |

**カラー**: note=青, warning=黄, tip=緑, info=紫

**使いどころ**: 読者に特に注意してほしい箇所、補足説明、ベストプラクティス

### 2. 引用ボックス（Quote）

出典付きの引用。左ボーダー + 大きなクォート記号のデザイン。

```
[quote author="著者名" source="出典名" url="https://example.com"]引用テキスト[/quote]
```

| 属性 | 必須 | 説明 |
|------|------|------|
| `author` | - | 著者名 |
| `source` | - | 出典名（urlがあればリンク化） |
| `url` | - | 出典URL |

### 3. タイムライン

年表・経歴・プロジェクト進行の表現。垂直ライン + マーカーのデザイン。

```
[timeline]
[timeline_item date="2024年1月" title="フェーズ1"]説明テキスト[/timeline_item]
[timeline_item date="2024年4月" title="フェーズ2"]説明テキスト[/timeline_item]
[/timeline]
```

| 属性 | 必須 | 説明 |
|------|------|------|
| `date` | - | 日付バッジのテキスト |
| `title` | - | 項目タイトル（h4） |
| `icon` | - | マーカー内のアイコン文字 |

### 4. ステップガイド

手順説明。番号付き丸アイコン + カード形式。CSSカウンターで自動採番。

```
[steps]
[step title="ステップ1のタイトル"]説明テキスト[/step]
[step title="ステップ2のタイトル"]説明テキスト[/step]
[step title="ステップ3のタイトル"]説明テキスト[/step]
[/steps]
```

| 属性 | 必須 | 説明 |
|------|------|------|
| `title` | - | ステップタイトル（h4） |

### 5. リンクカード

外部リンクのリッチプレビュー。タイトル・説明・ドメイン表示。

```
[link_card url="https://example.com" title="サイト名" description="説明文" image="https://example.com/og.jpg"]
```

| 属性 | 必須 | 説明 |
|------|------|------|
| `url` | **必須** | リンク先URL |
| `title` | - | タイトル（省略時はURL表示） |
| `description` | - | 説明文（2行まで表示） |
| `image` | - | サムネイル画像URL |

### 6. Amazonリンク

Amazon商品カード。オレンジのアクセントカラー。

```
[amazon asin="4297127830" title="書籍タイトル" price="¥2,640" image="https://..." tag="affiliate-tag"]
```

| 属性 | 必須 | 説明 |
|------|------|------|
| `asin` | △ | Amazon ASIN（titleと併用推奨） |
| `title` | △ | 商品タイトル |
| `image` | - | 商品画像URL |
| `price` | - | 価格表示 |
| `tag` | - | アフィリエイトタグ |

### 7. バッジ（インライン）

インラインのラベルバッジ。`<p>` タグ内で使用。

```
[badge color="primary"]NEW[/badge]
[badge color="accent"]推奨[/badge]
[badge color="warning"]β版[/badge]
[badge color="danger"]非推奨[/badge]
```

| 属性 | 必須 | 説明 |
|------|------|------|
| `color` | - | primary(青) / accent(緑) / warning(黄) / danger(赤)。デフォルト: primary |

### 8. マーカー / ハイライト（インライン）

テキストにグラデーションの下線マーカー。`<p>` タグ内で使用。

```
[marker color="yellow"]強調テキスト[/marker]
[marker color="blue"]青マーカー[/marker]
[marker color="pink"]ピンクマーカー[/marker]
[marker color="green"]緑マーカー[/marker]
```

| 属性 | 必須 | 説明 |
|------|------|------|
| `color` | - | yellow / blue / pink / green。デフォルト: yellow |

### 9. アコーディオン

折りたたみコンテンツ。FAQ形式に最適。`<details>/<summary>` ベース。

```
[accordion]
[accordion_item title="質問1"]回答テキスト[/accordion_item]
[accordion_item title="質問2"]回答テキスト[/accordion_item]
[accordion_item title="質問3" open="true"]初期展開状態の回答[/accordion_item]
[/accordion]
```

| 属性 | 必須 | 説明 |
|------|------|------|
| `title` | - | ヘッダーテキスト |
| `open` | - | `"true"` で初期展開 |

### 10. カラムレイアウト

2〜4段組みのグリッドレイアウト。レスポンシブ対応（モバイルは1カラム）。

```
[columns count="2"]
[column]左カラムの内容[/column]
[column]右カラムの内容[/column]
[/columns]
```

| 属性 | 必須 | 説明 |
|------|------|------|
| `count` | - | カラム数 2〜4。デフォルト: 2 |

### 11. 比較テーブル

A vs B の比較表示。ヘッダーに「VS」表記。

```
[comparison title_a="React" title_b="Vue"]
<table>
<tr><td>学習コスト</td><td>中</td><td>低</td></tr>
<tr><td>エコシステム</td><td>大</td><td>中</td></tr>
</table>
[/comparison]
```

| 属性 | 必須 | 説明 |
|------|------|------|
| `title_a` | - | 左側タイトル。デフォルト: A |
| `title_b` | - | 右側タイトル。デフォルト: B |

---

## HTMLスタイル（entry-content 内）

ショートコード以外にも、以下のHTML要素がテーマCSSでスタイリング済み。

### 見出し

```html
<h2>グラデーション左ボーダー付き見出し</h2>
<h3>緑の左ボーダー付き小見出し</h3>
<h4>太字のサブ見出し</h4>
```

- `<h2>`: 紫→青グラデーションの左ボーダー、大きめフォント
- `<h3>`: 緑の左ボーダー
- `<h4>`: ボーダーなし、太字

### コードブロック

```html
<pre class="language-javascript" data-lang="JavaScript"><code>
const hello = "world";
</code></pre>
```

- ダーク背景 + 角丸 + シャドウ
- `data-lang` 属性でラベルバッジを表示（右上にグラデーション背景）
- 対応言語ラベル例: `JavaScript`, `TypeScript`, `Python`, `PHP`, `Shell`, `HTML`, `CSS`

### インラインコード

```html
<code>inline code</code>
```

- 紫テキスト + グラデーション背景（薄紫）

### テーブル

```html
<table>
  <thead><tr><th>ヘッダー1</th><th>ヘッダー2</th></tr></thead>
  <tbody>
    <tr><td>データ1</td><td>データ2</td></tr>
  </tbody>
</table>
```

- 角丸 + シャドウ + ヘッダーグラデーション背景
- ホバー時に行ハイライト

### 引用

```html
<blockquote>
  <p>引用テキスト</p>
</blockquote>
```

- グラデーション左ボーダー + 薄い背景色 + イタリック体
- ※出典付きの場合は `[quote]` ショートコードを推奨

### リスト

```html
<ul><li>箇条書き項目</li></ul>
<ol><li>番号付き項目</li></ol>
```

- 適切な余白とインデント

### 画像

```html
<img src="..." alt="説明" />
<!-- or Gutenberg block -->
<!-- wp:image -->
<figure class="wp-block-image"><img src="..." alt="説明" /></figure>
<!-- /wp:image -->
```

- 角丸（8px）+ 中央寄せ

### Mermaid 図

```html
<div class="mermaid">
graph TD
  A --> B
</div>
```

- 薄い背景 + ボーダー + 角丸 + 中央寄せ

---

## Gutenbergブロック記法

WordPress投稿ではGutenbergブロックコメントでコンテンツを構造化する。

```html
<!-- wp:paragraph -->
<p>段落テキスト</p>
<!-- /wp:paragraph -->

<!-- wp:heading -->
<h2>見出し</h2>
<!-- /wp:heading -->

<!-- wp:heading {"level":3} -->
<h3>小見出し</h3>
<!-- /wp:heading -->

<!-- wp:code -->
<pre class="wp-block-code"><code>コード</code></pre>
<!-- /wp:code -->

<!-- wp:image -->
<figure class="wp-block-image"><img src="..." alt="" /></figure>
<!-- /wp:image -->

<!-- wp:list -->
<ul><li>項目</li></ul>
<!-- /wp:list -->

<!-- wp:table -->
<figure class="wp-block-table"><table>...</table></figure>
<!-- /wp:table -->
```

ショートコードはブロックの外（トップレベル）に直接記述する:

```
<!-- wp:heading -->
<h2>セクション見出し</h2>
<!-- /wp:heading -->

[note]ショートコードはブロックの外に置く[/note]
```

---

## 変換時の推奨マッピング

master.md のMarkdown記法から WordPress 用への変換ガイドライン:

| master.md の記法 | WordPress 変換先 |
|-----------------|-----------------|
| `> 引用` | `[quote]` ショートコード（出典あり）または `<blockquote>`（出典なし） |
| `> **Note**: ...` / `> ⚠️ ...` | `[note]` / `[warning]` ショートコード |
| `> 💡 ...` / `> ℹ️ ...` | `[tip]` / `[info]` ショートコード |
| `==ハイライト==` | `[marker]テキスト[/marker]` |
| 手順（1. 2. 3.）+ 説明 | `[steps]` + `[step]` ショートコード |
| 年表・時系列データ | `[timeline]` + `[timeline_item]` ショートコード |
| FAQ形式 | `[accordion]` + `[accordion_item]` ショートコード |
| 外部リンク（参考記事） | `[link_card]` ショートコード |
| Amazon書籍紹介 | `[amazon]` ショートコード |
| 比較表 | `[comparison]` ショートコード |
| 2〜4列レイアウト | `[columns]` + `[column]` ショートコード |
| `**太字キーワード**` | そのまま `<strong>` または `[badge]` |
| コードブロック ````lang` | `<pre class="language-lang" data-lang="Lang"><code>...</code></pre>` |
| Mermaid ````mermaid` | `<div class="mermaid">...</div>` |
