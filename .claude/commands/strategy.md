# 戦略策定

explore.md の結論をもとに strategy.md を完成させる。

## 引数

`$ARGUMENTS` = 記事番号 or slug or ディレクトリパス。未指定の場合は最新の記事ディレクトリを使用する。

## 前提

- explore.md が作成済みであること

## 手順

1. 記事ディレクトリを解決する
2. 以下のルール・リファレンスを読み込む:
   - `.ai/content/strategy/strategy.md`（策定ルール）
   - `.ai/content/strategy/template.md`（テンプレート）
   - `.ai/content/strategy/platform-strategy-guide.md`（媒体別特性ガイド）
3. explore.md を読み込み、結論を整理する
4. 対話形式で **共通戦略** の各項目を確定する:
   - 目的（ビジネス目的 + コンテンツ目的）
   - ペルソナ
   - コアメッセージ
   - 差別化
   - 構成案
   - タイミング
   - KPI
   - 前回の学び（track.md があれば参照）
5. 投稿先媒体を選択する（5媒体から選択）
6. 対話形式で **媒体別戦略** を確定する:
   - 選択した各媒体について、platform-strategy-guide.md の特性を踏まえて:
     - この媒体での狙い
     - ペルソナ調整（共通ペルソナとの差分）
     - 媒体固有の項目（note: トーン・CTA、Qiita: タグ戦略・技術深度、等）
     - 構成の変更点
     - 目標文字数
   - 媒体間の差別化ポイントを明確にする
7. strategy.md を保存し、ステータスを「確定」にする
