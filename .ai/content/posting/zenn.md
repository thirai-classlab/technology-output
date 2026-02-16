# Zenn 投稿ルール

## フォーマット対応状況

| 要素 | 対応 | 記法 |
|------|------|------|
| 見出し | H1-H6 | H2から始めることを推奨 |
| 太字 | 対応 | `**text**` |
| 斜体 | 対応 | `*text*` |
| 取り消し線 | 対応 | `~~text~~` |
| 下線 | 非対応 | HTMLタグもサニタイズされる |
| テーブル | 対応 | GFM形式（配置指定可、`<br>`でセル内改行） |
| コードブロック | 対応 | Shiki 208言語、ファイル名表示可 |
| Diff表示 | 対応 | `diff javascript`（スペース区切り） |
| Mermaid | 対応 | 2,000字/ブロック、Chain数10以下 |
| 数式（KaTeX） | 対応 | インライン: `$式$`、ブロック: `$$`で囲む |
| 脚注 | 対応 | `[^1]` / `[^1]: 内容` |
| 折りたたみ | 対応 | `:::details タイトル` |
| メッセージブロック | 対応 | `:::message` / `:::message alert` |
| 画像幅指定 | 対応 | `![alt](url =250x)` |
| 画像キャプション | 対応 | 画像直後の行にイタリック `*caption*` |
| 埋め込み | 対応 | `@[service](URL)` 形式 |
| 目次 | 自動生成 | 見出しから自動表示 |

## 独自記法

### メッセージブロック

master.md の注意書き・補足を以下に変換する:

```markdown
:::message
これは情報メッセージです。
:::

:::message alert
これは警告メッセージです。
:::
```

2種類のみ（通常 / alert）。

### 折りたたみ（アコーディオン）

```markdown
:::details タイトル
折りたたまれる内容
:::
```

ネストする場合はコロンを増やす:

```markdown
:::details 外側
::::details 内側
内容
::::
:::
```

### コードブロック（ファイル名 + Diff）

```markdown
```javascript:index.js
console.log("hello");
```

```diff javascript
+const added = true;
-const removed = false;
```
```

### 画像幅指定

```markdown
![alt text](https://example.com/image.png =250x)
```

`=` の前にスペースが必要。`px` は付けない。

### 画像キャプション

```markdown
![](https://example.com/image.png)
*これがキャプションになる*
```

### 埋め込み

```markdown
@[card](URL)
@[tweet](URL)
@[gist](URL)
@[youtube](URL)
@[codepen](URL)
@[codesandbox](URL)
@[stackblitz](URL)
@[figma](URL)
@[speakerdeck](URL)
```

URL単独行でもリンクカード表示になる。

### 数式

```markdown
インライン: $a^2 + b^2 = c^2$
ブロック:
$$
e^{i\pi} + 1 = 0
$$
```

注意: `$` の前後にスペースを入れると認識されない。

## frontmatter（必須）

```yaml
---
title: "記事タイトル"
emoji: "適切な絵文字"
type: "tech"
topics: ["トピック1", "トピック2"]
published: true
---
```

- `type`: "tech"（技術記事）or "idea"（アイデア記事）
- `topics`: 最大5つ
- `published`: false で下書き、true で公開

## 構成

- 冒頭に概要
- 技術的に正確・具体的な内容
- 末尾に参考リンク

## トーン

- 技術記事調（ですます体）

## 推奨

- 文字数: 3,000〜8,000字（深い解説は長めでもOK）
- HTMLタグは `<br>` 以外サニタイズされるため使用不可
- 画像: 3MB/ファイル上限、WordPressのURLを参照

## 投稿手段

- zenn-cli（https://zenn.dev/zenn/articles/install-zenn-cli）
- `npx zenn preview` でローカルプレビュー → 確認 → git push で公開
- 下書き確認時は `published: false` でpush、公開時に `published: true` に変更
