#!/bin/bash
# テスト: ディレクトリ構造が設計通りであること
# タスク#1: 旧ディレクトリ構造のクリーンアップ検証

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

assert_not_exists() {
  if [ ! -e "$1" ]; then
    echo "  PASS: $2"
    PASS=$((PASS + 1))
  else
    echo "  FAIL: $2 (should not exist: $1)"
    FAIL=$((FAIL + 1))
  fi
}

echo "=== test-structure.sh ==="

echo "[旧ディレクトリが存在しないこと]"
assert_not_exists "$PROJECT_ROOT/posts/note" "posts/note/ が削除されている"
assert_not_exists "$PROJECT_ROOT/posts/qiita" "posts/qiita/ が削除されている"
assert_not_exists "$PROJECT_ROOT/posts/zenn" "posts/zenn/ が削除されている"
assert_not_exists "$PROJECT_ROOT/posts/wordpress" "posts/wordpress/ が削除されている"
assert_not_exists "$PROJECT_ROOT/posts/internal-git" "posts/internal-git/ が削除されている"

echo "[必須ディレクトリが存在すること]"
assert_exists "$PROJECT_ROOT/posts" "posts/ が存在する"
assert_exists "$PROJECT_ROOT/posts/README.md" "posts/README.md が存在する"
assert_exists "$PROJECT_ROOT/.ai/dev" ".ai/dev/ が存在する"
assert_exists "$PROJECT_ROOT/.ai/content" ".ai/content/ が存在する"
assert_exists "$PROJECT_ROOT/.claude/commands" ".claude/commands/ が存在する"
assert_exists "$PROJECT_ROOT/docs/design" "docs/design/ が存在する"

echo "[.ai/dev/ ルールファイル]"
assert_exists "$PROJECT_ROOT/.ai/dev/structure.md" "structure.md"
assert_exists "$PROJECT_ROOT/.ai/dev/commands.md" "commands.md"
assert_exists "$PROJECT_ROOT/.ai/dev/documentation.md" "documentation.md"

echo "[.ai/content/ ルールファイル]"
assert_exists "$PROJECT_ROOT/.ai/content/brainstorm/explore.md" "brainstorm/explore.md"
assert_exists "$PROJECT_ROOT/.ai/content/strategy/strategy.md" "strategy/strategy.md"
assert_exists "$PROJECT_ROOT/.ai/content/strategy/template.md" "strategy/template.md"
assert_exists "$PROJECT_ROOT/.ai/content/writing/draft.md" "writing/draft.md"
assert_exists "$PROJECT_ROOT/.ai/content/review/review.md" "review/review.md"
assert_exists "$PROJECT_ROOT/.ai/content/posting/common.md" "posting/common.md"
assert_exists "$PROJECT_ROOT/.ai/content/posting/images.md" "posting/images.md"
assert_exists "$PROJECT_ROOT/.ai/content/posting/note.md" "posting/note.md"
assert_exists "$PROJECT_ROOT/.ai/content/posting/qiita.md" "posting/qiita.md"
assert_exists "$PROJECT_ROOT/.ai/content/posting/zenn.md" "posting/zenn.md"
assert_exists "$PROJECT_ROOT/.ai/content/posting/wordpress.md" "posting/wordpress.md"
assert_exists "$PROJECT_ROOT/.ai/content/posting/internal-git.md" "posting/internal-git.md"
assert_exists "$PROJECT_ROOT/.ai/content/posting/slack.md" "posting/slack.md"
assert_exists "$PROJECT_ROOT/.ai/content/posting/test.md" "posting/test.md"
assert_exists "$PROJECT_ROOT/.ai/content/track/track.md" "track/track.md"

echo "[scripts/ ディレクトリ]"
assert_exists "$PROJECT_ROOT/scripts" "scripts/ が存在する"
assert_exists "$PROJECT_ROOT/scripts/post-note.py" "scripts/post-note.py"

echo ""
echo "Results: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
