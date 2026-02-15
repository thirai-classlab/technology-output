# 記事執筆

strategy.md の構成案に従い master.md を執筆する。

## 引数

`$ARGUMENTS` = 記事番号 or slug or ディレクトリパス。未指定の場合は最新の記事ディレクトリを使用する。

## 前提

- strategy.md がステータス「確定」であること

## 手順

1. 記事ディレクトリを解決する
2. `.ai/content/writing/draft.md` を読み込み、執筆ルールを確認する
3. strategy.md と explore.md を読み込む
4. strategy.md の構成案に従い master.md を執筆する
   - 大きな記事の場合、サブエージェントでセクションを並列執筆する
5. セルフチェックを実施する:
   - コアメッセージとの一致
   - ペルソナにとっての理解しやすさ
   - 具体例・図解の充実度
6. master.md を保存する
