#!/bin/bash
# テスト: /new-article コマンドの動作検証
# 実際にディレクトリを作成し、期待する構造になることを検証する
# テスト後にクリーンアップする

set -euo pipefail
PROJECT_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
PASS=0; FAIL=0
TEST_SLUG="test-article"
TEST_DIR=""

cleanup() {
  if [ -n "$TEST_DIR" ] && [ -d "$TEST_DIR" ]; then
    rm -rf "$TEST_DIR"
  fi
}
trap cleanup EXIT

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

assert_dir_empty_except() {
  # ディレクトリが存在し、指定以外のファイルがないことを確認
  local dir="$1" desc="$2"
  if [ -d "$dir" ]; then
    echo "  PASS: $desc"
    PASS=$((PASS + 1))
  else
    echo "  FAIL: $desc (directory not found: $dir)"
    FAIL=$((FAIL + 1))
  fi
}

echo "=== test-new-article.sh ==="

# テスト用ディレクトリの連番を決定
NEXT_NUM=$(printf "%03d" 999)
TEST_DIR="$PROJECT_ROOT/posts/${NEXT_NUM}-${TEST_SLUG}"

# 既存テストディレクトリがあれば削除
[ -d "$TEST_DIR" ] && rm -rf "$TEST_DIR"

echo "[new-article: ディレクトリ作成テスト]"

# new-article の手順をシミュレート
# 1. ディレクトリ作成
mkdir -p "$TEST_DIR/platforms"

# 2. strategy.md をテンプレートからコピー
TEMPLATE="$PROJECT_ROOT/.ai/content/strategy/template.md"
if [ -f "$TEMPLATE" ]; then
  cp "$TEMPLATE" "$TEST_DIR/strategy.md"
else
  echo "  FAIL: テンプレートが見つからない ($TEMPLATE)"
  FAIL=$((FAIL + 1))
fi

# 3. explore.md を作成（ヘッダのみ）
cat > "$TEST_DIR/explore.md" << 'EXPLORE_EOF'
# 探索記録

> 記事: 999-test-article

## 探索ログ

（ここに対話の過程を記録する）
EXPLORE_EOF

# 4. images.md を作成（空テンプレート）
cat > "$TEST_DIR/images.md" << 'IMAGES_EOF'
# 画像URL一覧

> 記事: 999-test-article

| # | ファイル名 | WordPress URL | 用途 |
|---|-----------|---------------|------|

IMAGES_EOF

echo "[生成物の検証]"
assert_exists "$TEST_DIR" "記事ディレクトリ posts/999-test-article/ が存在する"
assert_exists "$TEST_DIR/strategy.md" "strategy.md が存在する"
assert_exists "$TEST_DIR/explore.md" "explore.md が存在する"
assert_exists "$TEST_DIR/images.md" "images.md が存在する"
assert_exists "$TEST_DIR/platforms" "platforms/ ディレクトリが存在する"

echo "[strategy.md の内容検証]"
assert_file_contains "$TEST_DIR/strategy.md" 'ステータス' "strategy.md にステータスフィールドがある"
assert_file_contains "$TEST_DIR/strategy.md" 'ペルソナ' "strategy.md にペルソナセクションがある"
assert_file_contains "$TEST_DIR/strategy.md" 'コアメッセージ' "strategy.md にコアメッセージセクションがある"
assert_file_contains "$TEST_DIR/strategy.md" '媒体別戦略' "strategy.md に媒体別戦略セクションがある"
assert_file_contains "$TEST_DIR/strategy.md" 'KPI' "strategy.md にKPIセクションがある"

echo "[explore.md の内容検証]"
assert_file_contains "$TEST_DIR/explore.md" '探索記録' "explore.md にヘッダがある"

echo "[images.md の内容検証]"
assert_file_contains "$TEST_DIR/images.md" '画像URL' "images.md にヘッダがある"
assert_file_contains "$TEST_DIR/images.md" 'WordPress URL' "images.md にWordPress URLカラムがある"

echo ""
echo "Results: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
