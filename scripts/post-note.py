#!/usr/bin/env python3
"""
note.com API投稿スクリプト

note.comの非公式APIを利用して記事を下書き投稿・公開する。
MarkdownをHTMLに変換してAPIに送信する。

Usage:
  python3 scripts/post-note.py draft --title "タイトル" --file path/to/note.md
  python3 scripts/post-note.py publish --note-id NOTE_ID
  python3 scripts/post-note.py check-auth
"""

import argparse
import json
import os
import re
import sys
from pathlib import Path

import requests
from markdown_it import MarkdownIt

BASE_URL = "https://note.com/api"


def load_cookies() -> dict:
    """NOTE_COOKIES 環境変数または settings.local.json からCookieを取得する。"""
    cookie_str = os.environ.get("NOTE_COOKIES", "")

    if not cookie_str:
        settings_path = Path(__file__).resolve().parent.parent / ".claude" / "settings.local.json"
        if settings_path.exists():
            import json
            settings = json.loads(settings_path.read_text(encoding="utf-8"))
            cookie_str = settings.get("env", {}).get("NOTE_COOKIES", "")

    if not cookie_str:
        print("エラー: NOTE_COOKIES が未設定です。", file=sys.stderr)
        print("", file=sys.stderr)
        print("設定手順:", file=sys.stderr)
        print("  1. ブラウザで note.com にログイン", file=sys.stderr)
        print("  2. DevTools > Application > Cookies > note.com", file=sys.stderr)
        print("  3. _note_session_v5 の値をコピー", file=sys.stderr)
        print('  4. .claude/settings.local.json の env に追加:', file=sys.stderr)
        print('     "NOTE_COOKIES": "_note_session_v5=<値>"', file=sys.stderr)
        sys.exit(1)

    cookies = {}
    for part in cookie_str.split(";"):
        part = part.strip()
        if "=" in part:
            key, val = part.split("=", 1)
            cookies[key.strip()] = val.strip()
    return cookies


def create_session(cookies: dict) -> requests.Session:
    """認証済みのrequestsセッションを作成する。"""
    session = requests.Session()
    for name, value in cookies.items():
        session.cookies.set(name, value, domain=".note.com")
    session.headers.update({
        "User-Agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) "
                      "AppleWebKit/537.36 (KHTML, like Gecko) "
                      "Chrome/131.0.0.0 Safari/537.36",
        "Content-Type": "application/json",
        "X-Requested-With": "XMLHttpRequest",
        "Accept": "application/json",
        "Origin": "https://note.com",
        "Referer": "https://note.com/",
    })
    return session


def md_to_html(markdown_text: str) -> str:
    """MarkdownをHTMLに変換する。"""
    md = MarkdownIt().enable("table")
    return md.render(markdown_text)


def strip_title_from_body(markdown_text: str) -> str:
    """本文の先頭にあるH1タイトル行を除去する（タイトルは別途送信するため）。"""
    lines = markdown_text.split("\n")
    start = 0
    # 先頭の空行をスキップ
    while start < len(lines) and lines[start].strip() == "":
        start += 1
    # H1行を除去
    if start < len(lines) and lines[start].startswith("# "):
        start += 1
        # H1直後の空行も除去
        while start < len(lines) and lines[start].strip() == "":
            start += 1
    return "\n".join(lines[start:])


def check_auth(session: requests.Session) -> bool:
    """Cookie認証が有効かチェックする。"""
    resp = session.get(f"{BASE_URL}/v3/notice_counts")
    if resp.status_code == 200:
        print("認証OK: note.com にログイン済みです。")
        return True
    else:
        print(f"認証エラー: ステータス {resp.status_code}", file=sys.stderr)
        print("Cookieの期限が切れている可能性があります。再取得してください。", file=sys.stderr)
        return False


def create_draft(session: requests.Session, title: str, html_body: str) -> dict:
    """記事を下書き作成する。"""
    payload = {
        "note_type": 0,
        "name": title,
        "body": html_body,
    }
    resp = session.post(f"{BASE_URL}/v1/text_notes", json=payload)

    if resp.status_code == 401 or resp.status_code == 403:
        print("認証エラー: Cookieの期限が切れています。再取得してください。", file=sys.stderr)
        sys.exit(1)
    if resp.status_code == 429:
        print("レート制限: 数分待ってから再試行してください。", file=sys.stderr)
        sys.exit(1)
    if not resp.ok:
        print(f"APIエラー: {resp.status_code} {resp.text}", file=sys.stderr)
        sys.exit(1)

    return resp.json()


def save_draft(session: requests.Session, note_id: str) -> dict:
    """記事を下書き保存する。"""
    resp = session.post(f"{BASE_URL}/v1/text_notes/draft_save?id={note_id}")

    if not resp.ok:
        print(f"下書き保存エラー: {resp.status_code} {resp.text}", file=sys.stderr)
        sys.exit(1)

    return resp.json()


def publish_note(session: requests.Session, note_id: str) -> dict:
    """下書き記事を公開する。"""
    payload = {
        "status": "published",
    }
    resp = session.put(f"{BASE_URL}/v1/text_notes/{note_id}", json=payload)

    if resp.status_code == 401 or resp.status_code == 403:
        print("認証エラー: Cookieの期限が切れています。再取得してください。", file=sys.stderr)
        sys.exit(1)
    if not resp.ok:
        print(f"公開エラー: {resp.status_code} {resp.text}", file=sys.stderr)
        sys.exit(1)

    return resp.json()


def cmd_draft(args, session):
    """draftサブコマンド: 記事を下書き投稿する。"""
    file_path = Path(args.file)
    if not file_path.exists():
        print(f"エラー: ファイルが見つかりません: {file_path}", file=sys.stderr)
        sys.exit(1)

    md_content = file_path.read_text(encoding="utf-8")
    body_md = strip_title_from_body(md_content)
    html_body = md_to_html(body_md)

    result = create_draft(session, args.title, html_body)

    data = result.get("data", result)
    note_id = data.get("id", "")
    note_key = data.get("key", "")

    if note_id:
        save_draft(session, str(note_id))

    # 結果出力
    print(f"note: OK")
    print(f"  ID: {note_id}")
    if note_key:
        print(f"  編集URL: https://note.com/notes/{note_key}/edit")
    print(f"  ステータス: 下書き保存済み")


def cmd_publish(args, session):
    """publishサブコマンド: 記事を公開する。"""
    result = publish_note(session, args.note_id)

    data = result.get("data", result)
    note_key = data.get("key", "")
    user = data.get("user", {})
    username = user.get("urlname", "")

    public_url = ""
    if username and note_key:
        public_url = f"https://note.com/{username}/n/{note_key}"

    print(f"note: OK")
    if public_url:
        print(f"  公開URL: {public_url}")
    print(f"  ステータス: 公開済み")


def cmd_check_auth(args, session):
    """check-authサブコマンド: 認証チェック。"""
    if not check_auth(session):
        sys.exit(1)


def main():
    parser = argparse.ArgumentParser(description="note.com API投稿スクリプト")
    subparsers = parser.add_subparsers(dest="command")

    # draft
    draft_parser = subparsers.add_parser("draft", help="記事を下書き投稿する")
    draft_parser.add_argument("--title", required=True, help="記事タイトル")
    draft_parser.add_argument("--file", required=True, help="Markdownファイルパス")

    # publish
    pub_parser = subparsers.add_parser("publish", help="記事を公開する")
    pub_parser.add_argument("--note-id", required=True, help="note記事ID")

    # check-auth
    subparsers.add_parser("check-auth", help="Cookie認証をチェックする")

    args = parser.parse_args()

    if not args.command:
        parser.print_help()
        sys.exit(1)

    cookies = load_cookies()
    session = create_session(cookies)

    if args.command == "draft":
        cmd_draft(args, session)
    elif args.command == "publish":
        cmd_publish(args, session)
    elif args.command == "check-auth":
        cmd_check_auth(args, session)


if __name__ == "__main__":
    main()
