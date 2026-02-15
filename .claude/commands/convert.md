# 媒体変換

master.md を各媒体向けにフォーマット変換する。

## 引数

`$ARGUMENTS` = 記事番号 or slug or ディレクトリパス。未指定の場合は最新の記事ディレクトリを使用する。

## 前提

- master.md がレビュー済みであること

## 手順

1. 記事ディレクトリを解決する
2. `.ai/content/posting/common.md` を読み込み、変換マトリクス・共通ルールを確認する
3. strategy.md の「媒体戦略」セクションを読み、投稿対象の媒体を特定する
4. 画像があれば wordpress-mcp で WordPress にアップロードし、images.md にURL記録する
5. 各媒体のルールを読み込む（`.ai/content/posting/{媒体名}.md`）
6. WordPress変換時は `docs/design/wp-shortcode-reference.md` を必ず読み込み、ショートコード・HTMLスタイルの仕様に従って変換する
7. サブエージェントで各媒体への変換を並列実行する:
   - note: `.ai/content/posting/note.md` に従い変換
   - Qiita: `.ai/content/posting/qiita.md` に従い変換
   - Zenn: `.ai/content/posting/zenn.md` に従い変換
   - WordPress: `.ai/content/posting/wordpress.md` + `docs/design/wp-shortcode-reference.md` に従い変換
   - 社内Git: `.ai/content/posting/internal-git.md` に従い変換
8. `platforms/` 配下に各媒体版を出力する
