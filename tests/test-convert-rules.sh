#!/bin/bash
# テスト: 媒体別最適フォーマット変換ルールのチェック
# 施策②: 媒体別最適フォーマット変換ルール拡張

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

assert_contains() {
  if grep -q "$1" "$2" 2>/dev/null; then
    echo "  PASS: $3"
    PASS=$((PASS + 1))
  else
    echo "  FAIL: $3 (pattern '$1' not found in $2)"
    FAIL=$((FAIL + 1))
  fi
}

echo "=== test-convert-rules.sh ==="

# --- common.md: 4段階最適化プロセス ---
echo "[common.md: 4段階最適化プロセス]"
COMMON="$PROJECT_ROOT/.ai/content/posting/common.md"
assert_exists "$COMMON" "common.md が存在する"
assert_contains "構成最適化" "$COMMON" "Step 1: 構成最適化がある"
assert_contains "コンテンツ最適化" "$COMMON" "Step 2: コンテンツ最適化がある"
assert_contains "フォーマット最適化" "$COMMON" "Step 3: フォーマット最適化がある"
assert_contains "エンゲージメント最適化" "$COMMON" "Step 4: エンゲージメント最適化がある"
assert_contains "媒体別戦略" "$COMMON" "strategy.md の媒体別戦略への参照がある"

# --- common.md: フォーマット互換マトリクス ---
echo "[common.md: フォーマット互換マトリクス]"
assert_contains "見出し" "$COMMON" "見出しレベルの互換情報がある"
assert_contains "テーブル" "$COMMON" "テーブル対応の互換情報がある"
assert_contains "Mermaid" "$COMMON" "Mermaid対応の互換情報がある"
assert_contains "数式" "$COMMON" "数式対応の互換情報がある"
assert_contains "折りたたみ" "$COMMON" "折りたたみ対応の互換情報がある"
assert_contains "脚注" "$COMMON" "脚注対応の互換情報がある"

# --- note.md: Mermaid対応更新 + フォーマット詳細 ---
echo "[note.md: フォーマット詳細]"
NOTE="$PROJECT_ROOT/.ai/content/posting/note.md"
assert_contains "H2.*H3\|H2/H3\|H2, H3\|H2とH3" "$NOTE" "見出しレベル制約（H2/H3のみ）がある"
assert_contains "テーブル" "$NOTE" "テーブル制約の記載がある"
assert_contains "Mermaid" "$NOTE" "Mermaid対応情報がある"
assert_contains "KaTeX\|数式" "$NOTE" "数式対応情報がある"
assert_contains "埋め込み" "$NOTE" "埋め込み対応情報がある"

# --- qiita.md: 独自記法・詳細 ---
echo "[qiita.md: フォーマット詳細]"
QIITA="$PROJECT_ROOT/.ai/content/posting/qiita.md"
assert_contains ":::note" "$QIITA" "Note記法（:::note）がある"
assert_contains "diff" "$QIITA" "Diff記法の記載がある"
assert_contains "ファイル名" "$QIITA" "ファイル名表示の記載がある"
assert_contains "脚注" "$QIITA" "脚注の記載がある"
assert_contains "折りたたみ\|details" "$QIITA" "折りたたみの記載がある"

# --- zenn.md: 独自記法・詳細 ---
echo "[zenn.md: フォーマット詳細]"
ZENN="$PROJECT_ROOT/.ai/content/posting/zenn.md"
assert_contains ":::message" "$ZENN" "メッセージブロック記法がある"
assert_contains ":::details" "$ZENN" "折りたたみ記法がある"
assert_contains "ファイル名" "$ZENN" "ファイル名表示の記載がある"
assert_contains "KaTeX\|数式" "$ZENN" "数式対応情報がある"
assert_contains "画像.*幅\|=.*x" "$ZENN" "画像幅指定の記載がある"

# --- internal-git.md: Alerts・詳細 ---
echo "[internal-git.md: フォーマット詳細]"
INTGIT="$PROJECT_ROOT/.ai/content/posting/internal-git.md"
assert_contains "NOTE\|TIP\|WARNING\|CAUTION\|Alert" "$INTGIT" "GitHub Alerts記法がある"
assert_contains "脚注" "$INTGIT" "脚注の記載がある"
assert_contains "折りたたみ\|details" "$INTGIT" "折りたたみの記載がある"
assert_contains "数式\|MathJax\|LaTeX" "$INTGIT" "数式対応情報がある"

# --- convert.md: 媒体別戦略参照 ---
echo "[convert.md: 媒体別戦略参照]"
CMD="$PROJECT_ROOT/.claude/commands/convert.md"
assert_contains "媒体別戦略" "$CMD" "媒体別戦略への参照がある"
assert_contains "構成最適化\|コンテンツ最適化\|フォーマット最適化\|エンゲージメント最適化" "$CMD" "最適化プロセスの記載がある"

echo ""
echo "Results: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
