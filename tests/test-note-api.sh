#!/bin/bash
# テスト: note.com API投稿スクリプトの前提条件確認

set -euo pipefail
PROJECT_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
PASS=0; FAIL=0

assert_exists() {
  if [ -e "$1" ]; then
    echo "  PASS: $2"
    PASS=$((PASS + 1))
  else
    echo "  FAIL: $2 (not found: $1)"
    FAIL=$((FAIL + 1))
  fi
}

echo "=== test-note-api.sh ==="

echo "[スクリプトファイル]"
assert_exists "$PROJECT_ROOT/scripts/post-note.py" "scripts/post-note.py が存在する"

echo "[Python依存パッケージ]"
if python3 -c "import requests" 2>/dev/null; then
  echo "  PASS: requests が利用可能"
  PASS=$((PASS + 1))
else
  echo "  FAIL: requests がインストールされていない"
  FAIL=$((FAIL + 1))
fi

if python3 -c "from markdown_it import MarkdownIt; MarkdownIt().enable('table')" 2>/dev/null; then
  echo "  PASS: markdown-it-py（table対応）が利用可能"
  PASS=$((PASS + 1))
else
  echo "  FAIL: markdown-it-py がインストールされていない"
  FAIL=$((FAIL + 1))
fi

echo "[スクリプト構文チェック]"
if [ -f "$PROJECT_ROOT/scripts/post-note.py" ]; then
  if python3 -c "import py_compile; py_compile.compile('$PROJECT_ROOT/scripts/post-note.py', doraise=True)" 2>/dev/null; then
    echo "  PASS: post-note.py の構文エラーなし"
    PASS=$((PASS + 1))
  else
    echo "  FAIL: post-note.py に構文エラーあり"
    FAIL=$((FAIL + 1))
  fi
else
  echo "  SKIP: post-note.py が未作成のため構文チェックスキップ"
  FAIL=$((FAIL + 1))
fi

echo "[Cookie設定]"
if [ -n "${NOTE_COOKIES:-}" ]; then
  echo "  PASS: NOTE_COOKIES 環境変数が設定されている"
  PASS=$((PASS + 1))
elif [ -f "$PROJECT_ROOT/.env" ] && grep -q "NOTE_COOKIES" "$PROJECT_ROOT/.env" 2>/dev/null; then
  echo "  PASS: .env に NOTE_COOKIES が設定されている"
  PASS=$((PASS + 1))
else
  echo "  FAIL: NOTE_COOKIES が未設定（環境変数または .env に設定してください）"
  FAIL=$((FAIL + 1))
fi

echo ""
echo "Results: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
