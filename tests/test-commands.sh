#!/bin/bash
# テスト: コマンドファイルの整合性
# 全9コマンドが存在し、必要なセクションを含んでいること

set -euo pipefail
PROJECT_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
CMD_DIR="$PROJECT_ROOT/.claude/commands"
PASS=0; FAIL=0

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

assert_exists() {
  if [ -f "$1" ]; then
    echo "  PASS: $2"
    PASS=$((PASS + 1))
  else
    echo "  FAIL: $2 (not found: $1)"
    FAIL=$((FAIL + 1))
  fi
}

echo "=== test-commands.sh ==="

echo "[全9コマンドファイルの存在]"
COMMANDS=("new-article" "explore" "strategy" "draft" "review" "convert" "post" "track" "add-rule")
for cmd in "${COMMANDS[@]}"; do
  assert_exists "$CMD_DIR/$cmd.md" "/.$cmd コマンドファイル"
done

echo "[各コマンドの必須セクション]"
# new-article: 引数セクションと手順
assert_file_contains "$CMD_DIR/new-article.md" '\$ARGUMENTS' "new-article: 引数定義あり"
assert_file_contains "$CMD_DIR/new-article.md" '手順' "new-article: 手順セクションあり"
assert_file_contains "$CMD_DIR/new-article.md" 'structure.md' "new-article: structure.mdルール参照あり"

# explore: ルール参照
assert_file_contains "$CMD_DIR/explore.md" 'brainstorm/explore.md' "explore: brainstormルール参照あり"
assert_file_contains "$CMD_DIR/explore.md" 'サブエージェント\|並列' "explore: サブエージェント/並列処理の記載あり"

# strategy: テンプレート参照
assert_file_contains "$CMD_DIR/strategy.md" 'template.md' "strategy: テンプレート参照あり"

# draft: writing/draft.mdルール参照
assert_file_contains "$CMD_DIR/draft.md" 'writing/draft.md' "draft: writingルール参照あり"

# review: review.mdルール参照
assert_file_contains "$CMD_DIR/review.md" 'review/review.md' "review: reviewルール参照あり"

# convert: posting/common.mdルール参照 + 5媒体
assert_file_contains "$CMD_DIR/convert.md" 'posting/common.md' "convert: commonルール参照あり"
assert_file_contains "$CMD_DIR/convert.md" 'note.md' "convert: note変換の記載あり"
assert_file_contains "$CMD_DIR/convert.md" 'qiita.md' "convert: qiita変換の記載あり"

# post: CLI/MCPツール記載
assert_file_contains "$CMD_DIR/post.md" 'wordpress-mcp\|note-cli\|qiita-cli\|zenn-cli\|GitHub MCP' "post: 投稿ツールの記載あり"
assert_file_contains "$CMD_DIR/post.md" 'Slack' "post: Slack展開の記載あり"

# track: track/track.mdルール参照
assert_file_contains "$CMD_DIR/track.md" 'track/track.md' "track: trackルール参照あり"

# add-rule: 7ステップ
assert_file_contains "$CMD_DIR/add-rule.md" 'Step 1' "add-rule: Step 1あり"
assert_file_contains "$CMD_DIR/add-rule.md" 'Step 7' "add-rule: Step 7あり"

echo ""
echo "Results: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
