#!/bin/bash
# 全テスト実行スクリプト
set -uo pipefail
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
TOTAL_PASS=0; TOTAL_FAIL=0; RUN=0

for test_file in "$SCRIPT_DIR"/test-*.sh; do
  RUN=$((RUN + 1))
  echo ""
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  if bash "$test_file"; then
    echo ">>> $(basename "$test_file"): OK"
    TOTAL_PASS=$((TOTAL_PASS + 1))
  else
    echo ">>> $(basename "$test_file"): FAILED"
    TOTAL_FAIL=$((TOTAL_FAIL + 1))
  fi
done

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Total: $RUN test files, $TOTAL_PASS passed, $TOTAL_FAIL failed"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

[ "$TOTAL_FAIL" -eq 0 ]
