#!/bin/bash
# テスト: CLI/MCPツールの存在確認
# タスク#2,#3: CLIツール・MCPツールのセットアップ確認

set -euo pipefail
PROJECT_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
PASS=0; FAIL=0

assert_command_exists() {
  if command -v "$1" &>/dev/null; then
    echo "  PASS: $1 がインストールされている ($(command -v "$1"))"
    PASS=$((PASS + 1))
  else
    echo "  FAIL: $1 が見つからない"
    FAIL=$((FAIL + 1))
  fi
}

assert_npm_available() {
  local pkg="$1" desc="$2"
  # グローバル or プロジェクトローカルにインストールされているか
  if npm list -g "$pkg" 2>/dev/null | grep -q "$pkg" || \
     (cd "$PROJECT_ROOT" && npm list "$pkg" 2>/dev/null | grep -q "$pkg"); then
    echo "  PASS: $desc が利用可能"
    PASS=$((PASS + 1))
  else
    echo "  FAIL: $desc が利用不可 (npm install -g $pkg or npm install $pkg)"
    FAIL=$((FAIL + 1))
  fi
}

echo "=== test-tools.sh ==="

echo "[基盤ツール]"
assert_command_exists "node"
assert_command_exists "npm"
assert_command_exists "git"

echo "[CLI投稿ツール]"
assert_npm_available "@qiita/qiita-cli" "qiita-cli"
assert_npm_available "zenn-cli" "zenn-cli"

# note-cli: JY8752/note-cli (Homebrew)
assert_command_exists "note-cli"

echo "[MCP設定]"
# Claude Code / Claude DesktopのMCP設定を検索
MCP_FILES=(
  "$HOME/.claude/claude_desktop_config.json"
  "$HOME/.claude/mcp.json"
  "$PROJECT_ROOT/.mcp.json"
)

MCP_FOUND=false
for mcp_file in "${MCP_FILES[@]}"; do
  if [ -f "$mcp_file" ]; then
    MCP_FOUND=true
    break
  fi
done

if $MCP_FOUND; then
  echo "  PASS: MCP設定ファイルが存在する"
  PASS=$((PASS + 1))

  # 各MCPの設定有無（全候補ファイルを横断検索）
  for mcp_name in "wordpress" "github" "slack"; do
    found=false
    for mcp_file in "${MCP_FILES[@]}"; do
      if grep -qi "$mcp_name" "$mcp_file" 2>/dev/null; then
        found=true
        break
      fi
    done
    if $found; then
      echo "  PASS: ${mcp_name}-mcp の設定あり"
      PASS=$((PASS + 1))
    else
      echo "  FAIL: ${mcp_name}-mcp の設定が見つからない"
      FAIL=$((FAIL + 1))
    fi
  done
else
  echo "  FAIL: MCP設定ファイルが見つからない"
  FAIL=$((FAIL + 1))
  for mcp_name in "wordpress" "github" "slack"; do
    echo "  SKIP: ${mcp_name}-mcp (MCP設定なし)"
    FAIL=$((FAIL + 1))
  done
fi

echo ""
echo "Results: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
