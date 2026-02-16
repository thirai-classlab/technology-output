#!/bin/bash
# テスト: グローバルCLIコマンドの存在・構造チェック

PASS=0
FAIL=0
GLOBAL_CMD_DIR="$HOME/.claude/commands"
PROJECT_ROOT="$(cd "$(dirname "$0")/.." && pwd)"

assert_file_exists() {
    if [ -f "$1" ]; then
        echo "  PASS: $2"
        PASS=$((PASS + 1))
    else
        echo "  FAIL: $2 ($1 が存在しません)"
        FAIL=$((FAIL + 1))
    fi
}

assert_file_contains() {
    if grep -q "$2" "$1" 2>/dev/null; then
        echo "  PASS: $3"
        PASS=$((PASS + 1))
    else
        echo "  FAIL: $3 ($1 に '$2' が含まれていません)"
        FAIL=$((FAIL + 1))
    fi
}

assert_file_not_exists() {
    if [ ! -f "$1" ]; then
        echo "  PASS: $2"
        PASS=$((PASS + 1))
    else
        echo "  FAIL: $2 ($1 が存在しています)"
        FAIL=$((FAIL + 1))
    fi
}

echo "=== グローバルCLIコマンド テスト ==="
echo ""

echo "[1] output- プレフィックス付きコマンドファイルの存在"
assert_file_exists "$GLOBAL_CMD_DIR/output-idea.md" "/output-idea コマンド"
assert_file_exists "$GLOBAL_CMD_DIR/output-draft-from-dev.md" "/output-draft-from-dev コマンド"

echo ""
echo "[2] 旧コマンドファイルが存在しないこと"
assert_file_not_exists "$GLOBAL_CMD_DIR/idea.md" "旧 /idea が削除されている"
assert_file_not_exists "$GLOBAL_CMD_DIR/draft-from-dev.md" "旧 /draft-from-dev が削除されている"

echo ""
echo "[3] ideas.md の存在"
assert_file_exists "$PROJECT_ROOT/ideas.md" "ideas.md ネタ帳"

echo ""
echo "[4] /output-idea コマンドの構造"
assert_file_contains "$GLOBAL_CMD_DIR/output-idea.md" "IDEAS_FILE" "/output-idea に IDEAS_FILE 定数がある"
assert_file_contains "$GLOBAL_CMD_DIR/output-idea.md" "IDEA-{NNN}" "/output-idea に IDEA フォーマットがある"
assert_file_contains "$GLOBAL_CMD_DIR/output-idea.md" "対象媒体" "/output-idea に媒体選択がある"
assert_file_contains "$GLOBAL_CMD_DIR/output-idea.md" "優先度" "/output-idea に優先度がある"
assert_file_contains "$GLOBAL_CMD_DIR/output-idea.md" "鮮度" "/output-idea に鮮度がある"

echo ""
echo "[5] /output-draft-from-dev コマンドの構造"
assert_file_contains "$GLOBAL_CMD_DIR/output-draft-from-dev.md" "Phase 1" "Phase 1 プロジェクト分析がある"
assert_file_contains "$GLOBAL_CMD_DIR/output-draft-from-dev.md" "Phase 2" "Phase 2 記事内容ヒアリングがある"
assert_file_contains "$GLOBAL_CMD_DIR/output-draft-from-dev.md" "Phase 3" "Phase 3 ディレクトリ作成がある"
assert_file_contains "$GLOBAL_CMD_DIR/output-draft-from-dev.md" "Phase 4" "Phase 4 連携・案内がある"
assert_file_contains "$GLOBAL_CMD_DIR/output-draft-from-dev.md" "git log" "git log 分析がある"
assert_file_contains "$GLOBAL_CMD_DIR/output-draft-from-dev.md" "CLAUDE.md" "CLAUDE.md 読み込みがある"
assert_file_contains "$GLOBAL_CMD_DIR/output-draft-from-dev.md" "docs/" "docs/ 設計資料の読み込みがある"
assert_file_contains "$GLOBAL_CMD_DIR/output-draft-from-dev.md" "追加で読むべきファイル" "追加ファイルのヒアリングがある"
assert_file_contains "$GLOBAL_CMD_DIR/output-draft-from-dev.md" "伝えたいポイント" "記事内容のヒアリングがある"
assert_file_contains "$GLOBAL_CMD_DIR/output-draft-from-dev.md" "切り口" "記事の方向性ヒアリングがある"
assert_file_contains "$GLOBAL_CMD_DIR/output-draft-from-dev.md" "draft-notes.md" "draft-notes 出力がある"
assert_file_contains "$GLOBAL_CMD_DIR/output-draft-from-dev.md" "IDEAS_FILE" "IDEAS_FILE 連携がある"
assert_file_contains "$GLOBAL_CMD_DIR/output-draft-from-dev.md" "/explore" "次ステップ案内がある"

echo ""
echo "=== 結果: PASS=$PASS, FAIL=$FAIL ==="
[ "$FAIL" -eq 0 ] && exit 0 || exit 1
