# 新規記事作成

新しい記事ディレクトリを作成し、テンプレートを配置する。

## 引数

`$ARGUMENTS` = 記事のslug（例: `ai-skillset`）。未指定の場合はチャットで確認する。

## 手順

1. `.ai/dev/structure.md` を読み込み、命名規則を確認する
2. `posts/` 配下の既存ディレクトリから次の連番を取得する
3. `posts/{NNN}-{slug}/` ディレクトリを作成する
4. 以下のファイルを配置する:
   - `strategy.md`: `.ai/content/strategy/template.md` をコピー
   - `explore.md`: 空ファイル（ヘッダのみ）
   - `images.md`: 空の画像一覧テンプレート
   - `platforms/`: 空ディレクトリを作成
5. 作成したディレクトリパスを報告する
