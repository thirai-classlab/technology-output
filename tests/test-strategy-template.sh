#!/bin/bash
# テスト: 媒体別戦略テンプレートの構造チェック
# 施策①: 媒体別戦略テンプレート拡張

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

echo "=== test-strategy-template.sh ==="

# --- template.md: 共通戦略セクション（既存） ---
echo "[template.md: 共通戦略セクション]"
TEMPLATE="$PROJECT_ROOT/.ai/content/strategy/template.md"
assert_exists "$TEMPLATE" "template.md が存在する"
assert_contains "## 目的" "$TEMPLATE" "目的セクションがある"
assert_contains "## ペルソナ" "$TEMPLATE" "ペルソナセクションがある"
assert_contains "## コアメッセージ" "$TEMPLATE" "コアメッセージセクションがある"
assert_contains "## 差別化" "$TEMPLATE" "差別化セクションがある"
assert_contains "## 構成案" "$TEMPLATE" "構成案セクションがある"
assert_contains "## タイミング" "$TEMPLATE" "タイミングセクションがある"
assert_contains "## KPI" "$TEMPLATE" "KPIセクションがある"
assert_contains "## 前回の学び" "$TEMPLATE" "前回の学びセクションがある"

# --- template.md: 媒体別戦略セクション（新規） ---
echo "[template.md: 媒体別戦略セクション]"
assert_contains "## 媒体別戦略" "$TEMPLATE" "媒体別戦略セクションがある"
assert_contains "### note" "$TEMPLATE" "note セクションがある"
assert_contains "### Qiita" "$TEMPLATE" "Qiita セクションがある"
assert_contains "### Zenn" "$TEMPLATE" "Zenn セクションがある"
assert_contains "### WordPress" "$TEMPLATE" "WordPress セクションがある"
assert_contains "### 社内Git" "$TEMPLATE" "社内Git セクションがある"

# --- template.md: 各媒体の必須項目 ---
echo "[template.md: 媒体別テンプレート項目]"
assert_contains "この媒体での狙い" "$TEMPLATE" "「この媒体での狙い」項目がある"
assert_contains "ペルソナ調整" "$TEMPLATE" "「ペルソナ調整」項目がある"
assert_contains "構成の変更点" "$TEMPLATE" "「構成の変更点」項目がある"
assert_contains "目標文字数" "$TEMPLATE" "「目標文字数」項目がある"

# --- template.md: 媒体固有の項目 ---
echo "[template.md: 媒体固有の項目]"
assert_contains "トーン" "$TEMPLATE" "note向け「トーン」項目がある"
assert_contains "CTA" "$TEMPLATE" "CTA 項目がある"
assert_contains "技術深度" "$TEMPLATE" "技術系媒体向け「技術深度」項目がある"
assert_contains "タグ戦略" "$TEMPLATE" "Qiita向け「タグ戦略」項目がある"
assert_contains "SEOキーワード" "$TEMPLATE" "WordPress向け「SEOキーワード」項目がある"
assert_contains "検索意図" "$TEMPLATE" "WordPress向け「検索意図」項目がある"
assert_contains "社内コンテキスト" "$TEMPLATE" "社内Git向け「社内コンテキスト」項目がある"

# --- platform-strategy-guide.md（新規ファイル） ---
echo "[platform-strategy-guide.md]"
GUIDE="$PROJECT_ROOT/.ai/content/strategy/platform-strategy-guide.md"
assert_exists "$GUIDE" "platform-strategy-guide.md が存在する"
assert_contains "note" "$GUIDE" "note の特性が記載されている"
assert_contains "Qiita" "$GUIDE" "Qiita の特性が記載されている"
assert_contains "Zenn" "$GUIDE" "Zenn の特性が記載されている"
assert_contains "WordPress" "$GUIDE" "WordPress の特性が記載されている"
assert_contains "社内Git" "$GUIDE" "社内Git の特性が記載されている"
assert_contains "読者層" "$GUIDE" "読者層の情報がある"
assert_contains "成功パターン" "$GUIDE" "成功パターンの情報がある"

# --- strategy.md: 媒体別戦略ルール ---
echo "[strategy.md: 媒体別戦略ルール]"
RULES="$PROJECT_ROOT/.ai/content/strategy/strategy.md"
assert_contains "媒体別戦略" "$RULES" "媒体別戦略のルールがある"
assert_contains "platform-strategy-guide" "$RULES" "ガイド参照の指示がある"
assert_contains "共通戦略" "$RULES" "共通戦略と媒体別の区別がある"

# --- commands/strategy.md: 媒体別ステップ ---
echo "[commands/strategy.md: 媒体別ステップ]"
CMD="$PROJECT_ROOT/.claude/commands/strategy.md"
assert_contains "platform-strategy-guide" "$CMD" "ガイド読み込みステップがある"
assert_contains "媒体別戦略" "$CMD" "媒体別戦略の対話ステップがある"

echo ""
echo "Results: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
