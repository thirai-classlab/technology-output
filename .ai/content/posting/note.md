# note 投稿ルール

## フォーマット

- Mermaid非対応 → テキスト図解またはインデント付きリストに変換
- カジュアルで読みやすいエッセイ調のトーン
- 見出し・太字・リスト・コードブロック使用可
- 画像はWordPressにアップロード済みのURLを参照

## 構成

- 冒頭にリード文（この記事で得られること）
- 本文はストーリー性を意識
- 末尾にまとめとCTA

## 推奨

- 文字数: 5,000〜15,000字
- 目次は任意

## 投稿手段

- **API投稿**（`scripts/post-note.py`）で投稿
- note.comの非公式APIを利用（Cookie認証）
- Markdown → HTML変換はPython（markdown-it-py）で実行
- note-cli（https://github.com/JY8752/note-cli）はローカルでの記事管理・OGP画像生成に使用
- Cookieの有効期限が切れた場合はブラウザから再取得が必要

## API投稿の手順

1. `platforms/note.md` を読み込み
2. Markdown → HTML に変換
3. note.com API でタイトル + HTML本文を送信（下書き保存）
4. 保存後のIDとURLを取得して返す

## Cookie設定

1. ブラウザで note.com にログイン
2. DevTools > Application > Cookies > note.com
3. `_note_session_v5` の値をコピー
4. `.env` に追加: `NOTE_COOKIES="_note_session_v5=<値>"`
