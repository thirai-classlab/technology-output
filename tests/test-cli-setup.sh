#!/bin/bash
# テスト: Zenn/Qiita CLI用プロジェクト構成
# タスク#6: 各CLIが要求するディレクトリ・設定ファイルの存在確認

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

assert_file_contains() {
  local file="$1" pattern="$2" desc="$3"
  if grep -q "$pattern" "$file" 2>/dev/null; then
    echo "  PASS: $desc"
    PASS=$((PASS + 1))
  else
    echo "  FAIL: $desc ($file に '$pattern' が見つからない)"
    FAIL=$((FAIL + 1))
  fi
}

echo "=== test-cli-setup.sh ==="

echo "[Zenn CLI構成]"
assert_exists "$PROJECT_ROOT/articles" "articles/ ディレクトリが存在する（zenn-cli用）"
assert_exists "$PROJECT_ROOT/articles/.keep" "articles/.keep が存在する"

echo "[Qiita CLI構成]"
assert_exists "$PROJECT_ROOT/public" "public/ ディレクトリが存在する（qiita-cli用）"

echo "[.gitignore]"
assert_exists "$PROJECT_ROOT/.gitignore" ".gitignore が存在する"
assert_file_contains "$PROJECT_ROOT/.gitignore" "node_modules" ".gitignore に node_modules が含まれる"

echo "[package.json]"
assert_exists "$PROJECT_ROOT/package.json" "package.json が存在する"
assert_file_contains "$PROJECT_ROOT/package.json" "qiita" "package.json に qiita-cli が含まれる"
assert_file_contains "$PROJECT_ROOT/package.json" "zenn-cli" "package.json に zenn-cli が含まれる"

echo ""
echo "Results: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
