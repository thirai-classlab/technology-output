# 戦略策定

explore.md の結論をもとに strategy.md を完成させる。

## 引数

`$ARGUMENTS` = 記事番号 or slug or ディレクトリパス。未指定の場合は最新の記事ディレクトリを使用する。

## 前提

- explore.md が作成済みであること

## 手順

1. 記事ディレクトリを解決する
2. `.ai/content/strategy/strategy.md` と `.ai/content/strategy/template.md` を読み込む
3. explore.md を読み込み、結論を整理する
4. 対話形式で strategy.md の各項目を確定する:
   - 目的（ビジネス目的 + コンテンツ目的）
   - ペルソナ
   - コアメッセージ
   - 差別化
   - 構成案
   - 媒体戦略
   - タイミング
   - KPI
   - 前回の学び（track.md があれば参照）
5. strategy.md を保存し、ステータスを「確定」にする
