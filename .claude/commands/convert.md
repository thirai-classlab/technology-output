# 媒体変換

master.md を各媒体向けに最適化・変換する。

## 引数

`$ARGUMENTS` = 記事番号 or slug or ディレクトリパス。未指定の場合は最新の記事ディレクトリを使用する。

## 前提

- master.md がレビュー済みであること

## 手順

1. 記事ディレクトリを解決する
2. 以下のルール・リファレンスを読み込む:
   - `.ai/content/posting/common.md`（共通ルール・互換マトリクス・4段階最適化プロセス）
   - strategy.md の「媒体別戦略」セクション（各媒体の狙い・ペルソナ調整・構成変更点）
3. 投稿対象の媒体を特定する
4. 画像があれば wordpress-mcp で WordPress にアップロードし、images.md にURL記録する
5. 各媒体のルールを読み込む（`.ai/content/posting/{媒体名}.md`）
6. WordPress変換時は `docs/design/wp-shortcode-reference.md` を必ず読み込み、ショートコード・HTMLスタイルの仕様に従って変換する
7. サブエージェントで各媒体への4段階最適化を並列実行する:
   - **Step 1: 構成最適化** — 媒体別戦略の構成変更点に従い、セクション追加/削除/順序変更
   - **Step 2: コンテンツ最適化** — トーン・技術深度・文体を媒体の読者層に合わせて調整
   - **Step 3: フォーマット最適化** — 互換マトリクスに従い、非対応要素を代替表現に変換。独自記法を活用
   - **Step 4: エンゲージメント最適化** — CTA・frontmatter・タグ・SEOメタ・社内補足等を追加
   - 各媒体のルール:
     - note: `.ai/content/posting/note.md` に従い変換
     - Qiita: `.ai/content/posting/qiita.md` に従い変換
     - Zenn: `.ai/content/posting/zenn.md` に従い変換
     - WordPress: `.ai/content/posting/wordpress.md` + `docs/design/wp-shortcode-reference.md` に従い変換
     - 社内Git: `.ai/content/posting/internal-git.md` に従い変換
8. `platforms/` 配下に各媒体版を出力する
