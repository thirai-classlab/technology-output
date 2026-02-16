---
name: post-note
description: note.com に API で記事を下書き投稿または公開する。/post コマンドからサブエージェントとして呼び出される。
user-invokable: true
---

# note 投稿（API）

`$ARGUMENTS` で指定された記事ディレクトリの `platforms/note.md` を note.com に API で投稿する。

## 手順

1. 記事ディレクトリ `$ARGUMENTS` の `platforms/note.md` を Read で読み込む
2. `$ARGUMENTS/strategy.md` から記事タイトルを取得
3. Bash で Python スクリプトを実行:
   ```bash
   python3 scripts/post-note.py draft \
     --title "記事タイトル" \
     --file "$ARGUMENTS/platforms/note.md"
   ```
4. スクリプト出力からID・URLを取得
5. 結果を返す:

```
note: OK
  ID: {note_id}
  編集URL: https://note.com/notes/{note_key}/edit
  ステータス: 下書き保存済み
```

## `--publish` が $ARGUMENTS に含まれる場合

1. `$ARGUMENTS` からディレクトリパスとオプションを分離
2. 記事ディレクトリの `track.md` から note の ID を取得
3. Bash で公開コマンドを実行:
   ```bash
   python3 scripts/post-note.py publish --note-id {note_id}
   ```
4. 公開URLを返す:

```
note: OK
  公開URL: https://note.com/{username}/n/{note_key}
  ステータス: 公開済み
```

## エラー時の対応

- `認証エラー` → Cookieの期限切れ。ユーザーにブラウザからCookieを再取得するよう案内する
- `レート制限` → 数分待ってリトライ
- `APIエラー` → エラーメッセージを確認し、ユーザーに報告する
