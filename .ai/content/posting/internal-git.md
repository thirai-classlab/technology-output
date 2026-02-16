# 社内Git 投稿ルール

## リポジトリ情報

- Org: `classlab-inc`
- リポジトリ: `classlab-inc/document`
- 投稿先: `Knowledge/` ディレクトリ
- ブランチ: `master`
- MCP設定名: `github-internal`（.mcp.json）

## フォーマット対応状況

| 要素 | 対応 | 記法 |
|------|------|------|
| 見出し | H1-H6 | 自動アンカーリンク付き |
| 太字 / 斜体 / 取り消し線 | 対応 | GFM標準 |
| テーブル | 対応 | GFM形式（配置指定可） |
| コードブロック | 対応 | Linguist（数百言語） |
| Mermaid | 対応 | コードブロック `mermaid` 指定 |
| 数式（MathJax） | 対応 | インライン: `$式$`、ブロック: `$$` or ` ```math ` |
| 脚注 | 対応 | `[^1]` / `[^1]: 内容`（Wikiでは非対応） |
| 折りたたみ | 対応 | `<details><summary>` |
| Alerts | 対応 | `> [!NOTE]`, `> [!TIP]`, `> [!IMPORTANT]`, `> [!WARNING]`, `> [!CAUTION]` |
| チェックリスト | 対応 | `- [x]` / `- [ ]` |
| 絵文字 | 対応 | `:emoji_code:` |
| 画像 | 対応 | 10MB上限 |
| TOC | 自動 | ファイル左上のTOCボタン |

## 独自記法

### GitHub Alerts（注釈ブロック）

master.md の注意書き・補足を以下に変換する:

```markdown
> [!NOTE]
> 補足情報。読み飛ばしても問題ないが知っておくと有用。

> [!TIP]
> より効果的に作業するためのアドバイス。

> [!IMPORTANT]
> 成功するために必要な重要情報。

> [!WARNING]
> 潜在的なリスクがあり注意が必要。

> [!CAUTION]
> 行動の負の結果について注意喚起。
```

5種類（NOTE/TIP/IMPORTANT/WARNING/CAUTION）。

### 折りたたみ

```markdown
<details>
<summary>詳細を見る</summary>

折りたたまれた内容（Markdown記法使用可）

</details>
```

`<summary>` と本文の間に**空行が必要**。

### 脚注

```markdown
参照テキスト[^1]

[^1]: 脚注の内容
```

### 数式

```markdown
インライン: $E = mc^2$
ブロック:
$$
\sum_{i=1}^{n} x_i
$$
```

## 構成

- master.md をベースに社内向け補足を追加
- 社内ツール・プロセスへの言及OK
- 外部公開不可の情報を含めてよい
- 社内プロジェクト名・ツール名を具体的に記載

## トーン

- フラットな技術文書調（である体OK）

## 推奨

- 文字数制限なし（ただしレンダリングは512KBまで）
- 画像: WordPressにアップロード済みのURLを参照

## 投稿手段

- GitHub API（`.mcp.json` の `github-internal` PATで認証）
- `PUT /repos/classlab-inc/document/contents/Knowledge/{slug}.md`
- masterブランチに直接コミット（社内リポジトリのため）
