# 投稿

各媒体に下書き投稿 → 確認 → 公開 → Slack展開を実行する。

## 引数

`$ARGUMENTS` = 記事番号 or slug or ディレクトリパス。未指定の場合は最新の記事ディレクトリを使用する。

## ルール読み込み

- `.ai/content/posting/common.md` を読み込む

## 前提

- platforms/ に変換済みファイルが揃っていること

## 手順

### 1. 記事ディレクトリ解決 + 投稿前チェック

- $ARGUMENTS → `posts/{NNN}-{slug}/` を解決
- strategy.md の「媒体戦略」セクションで投稿対象の媒体リストを取得
- platforms/ の対象ファイルが全て存在するか確認
- images.md のURLが有効か確認

### 2. 投稿先の確認

strategy.md の媒体戦略テーブルから投稿対象（Yes の媒体）を抽出し、人間に確認する:

```
投稿対象媒体:
- [ ] WordPress (platforms/wordpress.md)
- [ ] Qiita (platforms/qiita.md)
- [ ] Zenn (platforms/zenn.md)
- [ ] note (platforms/note.md)
- [ ] 社内Git (platforms/internal-git.md)

この媒体に下書き投稿します。よろしいですか？
```

### 3. 下書き投稿（Skill をサブエージェントで並列実行）

人間が承認した媒体に対して、対応する Skill を **Task ツールで並列実行** する:

| 媒体 | Skill | 説明 |
|------|-------|------|
| WordPress | `post-wordpress` | REST API で下書き投稿 |
| Qiita | `post-qiita` | qiita-cli で限定公開投稿 |
| Zenn | `post-zenn` | published: false で git push |
| note | `post-note` | Claude in Chrome でブラウザ自動操作 |
| 社内Git | `post-internal-git` | GitHub API で classlab-inc/document に投稿 |

**実行方法**: Task ツールで各 Skill の SKILL.md の内容をプロンプトとして渡し、記事ディレクトリパスを $ARGUMENTS として指定する。承認された媒体のみ実行する。

```
例: WordPress と Qiita が対象の場合
→ Task(post-wordpress, "posts/001-ai-skillset") と Task(post-qiita, "posts/001-ai-skillset") を並列実行
```

### 4. 結果報告 + 人間確認

各サブエージェントの結果を集約して一覧表示:

```
## 下書き投稿完了

| 媒体 | ステータス | URL |
|------|-----------|-----|
| WordPress | OK | {edit_url} |
| Qiita | OK | {url} |
| ... | ... | ... |

各媒体で内容を確認してください。
問題なければ「公開」と伝えてください。
修正が必要な場合は /convert に戻ります。
```

### 5. 公開（人間の承認後）

各 Skill を `{記事ディレクトリ} --publish` 引数で再度並列実行

### 6. 投稿後処理

**重要: 手順6は全媒体の公開が完了し、公開URLが全て確定してから実行すること。バックグラウンドエージェントが実行中の場合は、全エージェントの完了を待ってからこの手順に進む。**

1. track.md に投稿記録（媒体・日付・**確定した公開URL**・ステータス）を記録する
   - 公開URLは各公開エージェントの結果から取得する（下書きURLや編集URLではなく、公開後のURLを使うこと）
   - 全媒体のURLが揃ったことを確認してから次に進む
2. strategy.md のステータスを「投稿済み」に更新
3. クロスリンクを各記事末尾に追記
4. `post-slack` Skill でSlack社内展開を実行（track.md の公開URLを参照するため、必ず手順1の後に実行する）

## テスト

接続テストを行う場合は `post-test` Skill を実行する。
