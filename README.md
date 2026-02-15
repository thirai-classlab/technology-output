# AI時代のエンジニアスキルセット

複数媒体（note / Qiita / Zenn / WordPress / 社内Git）へナレッジ記事を継続投稿するための Claude Code プロジェクト。

記事の企画から執筆・変換・投稿・振り返りまでを 8 Phase のワークフローで管理し、Claude Code のカスタムコマンドとサブエージェント（Skills）で自動化する。

## 動作環境

| 項目 | バージョン |
|------|-----------|
| OS | macOS / Linux |
| Node.js | 18 以上 |
| Python | 3.9 以上 |
| Git | 2.x |
| Claude Code | 最新版 |

### 必要な CLI ツール

| ツール | 用途 | インストール |
|--------|------|-------------|
| `node` / `npm` / `npx` | qiita-cli, zenn-cli, MCP サーバー実行 | [nodejs.org](https://nodejs.org/) |
| `python3` / `pip` | note.com API スクリプト | [python.org](https://www.python.org/) |
| `git` | Zenn 投稿、バージョン管理 | OS 標準 or [git-scm.com](https://git-scm.com/) |
| `claude` | Claude Code CLI | [Anthropic](https://claude.ai/claude-code) |

## 環境セットアップ

### 1. リポジトリのクローン

```bash
git clone https://github.com/<your-org>/AI時代のエンジニアスキルセット.git
cd AI時代のエンジニアスキルセット
```

### 2. Node.js 依存パッケージのインストール

```bash
npm install
```

qiita-cli と zenn-cli がインストールされる。

### 3. Python 依存パッケージのインストール

```bash
pip install requests markdown-it-py
```

note.com API 投稿スクリプト（`scripts/post-note.py`）で使用する。

### 4. MCP 設定ファイルのコピー

```bash
cp .mcp.json.example .mcp.json
```

`.mcp.json` は `${VAR}` で環境変数を参照する。実値は次の手順で設定する。

### 5. 環境変数の設定

```bash
cp .claude/settings.local.json.example .claude/settings.local.json
```

`.claude/settings.local.json` を開き、各値を自分の認証情報に書き換える。

```jsonc
{
  "env": {
    "WP_API_URL": "https://your-site.example.com/",
    "WP_API_USERNAME": "your-email@example.com",
    "WP_API_PASSWORD": "xxxx xxxx xxxx xxxx xxxx xxxx",
    "GITHUB_PAT": "github_pat_xxxxxxxxxx",
    "GITHUB_INTERNAL_PAT": "github_pat_xxxxxxxxxx",
    "SLACK_MCP_XOXP_TOKEN": "xoxp-xxxxxxxxxxxx",
    "SLACK_CHANNEL_ID": "C08ACUZ7Z1U",
    "NOTE_COOKIES": "_note_session_v5=xxxxxxxxxx"
  }
}
```

> `.claude/settings.local.json` は `.gitignore` で除外されているため、秘密情報がコミットされることはない。

### 6. 各サービスの認証情報の取得方法

| 変数 | 取得手順 |
|------|---------|
| `WP_API_PASSWORD` | WordPress 管理画面 > ユーザー > アプリケーションパスワード で発行 |
| `GITHUB_PAT` | GitHub > Settings > Developer settings > Fine-grained personal access tokens（public_repo スコープ） |
| `GITHUB_INTERNAL_PAT` | 同上（repo スコープ、社内org へのアクセス権付き） |
| `SLACK_MCP_XOXP_TOKEN` | Slack App 管理画面で xoxp トークンを発行（`chat:write`, `channels:read` スコープ） |
| `NOTE_COOKIES` | ブラウザで note.com にログイン > DevTools > Application > Cookies > `_note_session_v5` の値をコピー |

### 7. セットアップの検証

```bash
# 全テスト実行
bash tests/run-all.sh

# 個別検証
npx qiita version           # qiita-cli
npx zenn --version           # zenn-cli
python3 scripts/post-note.py check-auth   # note.com API
```

## 利用手順

### ワークフロー全体像

```
/new-article → /explore → /strategy → /draft → /review → /convert → /post → /track
```

Claude Code を起動し、各フェーズのコマンドを順に実行する。

```bash
claude
```

### Phase 1: INPUT — 記事ディレクトリ作成

```
/new-article
```

スラグを指定すると `posts/{NNN}-{slug}/` にテンプレートが生成される。

### Phase 2: EXPLORE — テーマ深掘り

```
/explore
```

対話形式でテーマを深掘りし、ペルソナ定義・競合調査・差別化要素を `explore.md` に記録する。

### Phase 3: STRATEGY — 戦略策定

```
/strategy
```

explore.md をもとに記事戦略（目的・ペルソナ・コアメッセージ・構成案・媒体戦略・KPI）を策定し、`strategy.md` を生成する。

### Phase 4: DRAFT — 原稿執筆

```
/draft
```

strategy.md の構成案に従い `master.md`（媒体非依存の原本）を執筆する。

### Phase 5: REVIEW — レビュー

```
/review
```

master.md を確認し、フィードバックに基づいて修正を繰り返す。

### Phase 6: CONVERT — 媒体変換

```
/convert
```

master.md を 5 媒体（note / Qiita / Zenn / WordPress / 社内Git）向けにフォーマット変換し、`platforms/` に出力する。画像がある場合は WordPress にアップロードし、全媒体から参照する。

### Phase 7: POST — 投稿・公開

```
/post
```

以下の流れで進む:

1. 全媒体に**下書き投稿**（並列実行）
2. 各媒体の下書きURLを提示 → **人間が確認**
3. 承認後、全媒体を**公開**
4. 公開URLを `track.md` に記録
5. **Slack で社内展開**

### Phase 8: TRACK — 振り返り

```
/track
```

各媒体の反響（PV・いいね・コメント等）を収集・分析し、次の記事戦略に活かす。

## 投稿先と使用ツール

| 媒体 | ツール | 投稿方式 |
|------|--------|---------|
| note | `scripts/post-note.py` | API（Cookie 認証） |
| Qiita | qiita-cli (`npx qiita publish`) | CLI |
| Zenn | zenn-cli + `git push` | CLI + Git |
| WordPress | wordpress-mcp | MCP（REST API） |
| 社内Git | GitHub MCP (github-internal) | MCP（GitHub API） |
| Slack | Slack MCP | MCP |

## ディレクトリ構成

```
.
├── .ai/                        ← AIルール（dev/ + content/）
├── .claude/
│   ├── commands/               ← カスタムコマンド（8 Phase）
│   ├── skills/                 ← サブエージェント（投稿 Skill）
│   ├── settings.local.json     ← 環境変数（※gitignore）
│   └── settings.local.json.example
├── .mcp.json                   ← MCP サーバー設定（${VAR} 参照）
├── .mcp.json.example
├── scripts/
│   └── post-note.py            ← note.com API 投稿スクリプト
├── tests/                      ← テストスクリプト
├── docs/design/                ← 設計ドキュメント
├── posts/                      ← 記事管理
│   ├── README.md
│   └── {NNN}-{slug}/
│       ├── strategy.md         ← 戦略
│       ├── explore.md          ← 探索記録
│       ├── master.md           ← 原本
│       ├── track.md            ← 反響記録
│       ├── images.md           ← 画像URL一覧
│       └── platforms/          ← 媒体別変換版
├── articles/                   ← zenn-cli 用
├── public/                     ← qiita-cli 用
├── CLAUDE.md                   ← プロジェクト規約
└── package.json
```

## テスト

```bash
# 全テスト
bash tests/run-all.sh

# 個別テスト
bash tests/test-structure.sh     # ディレクトリ構造
bash tests/test-commands.sh      # コマンドファイル整合性
bash tests/test-tools.sh         # CLI ツール存在確認
bash tests/test-note-api.sh      # note.com API スクリプト
bash tests/test-new-article.sh   # /new-article 動作確認
```

## トラブルシューティング

### note.com の Cookie が期限切れ

ブラウザで note.com に再ログインし、DevTools から `_note_session_v5` を取得して `.claude/settings.local.json` を更新する。

```bash
python3 scripts/post-note.py check-auth
```

### MCP サーバーが接続できない

1. `.mcp.json` が存在するか確認
2. `.claude/settings.local.json` の値が正しいか確認
3. Claude Code を再起動して環境変数を再読み込み

### qiita-cli / zenn-cli が動作しない

```bash
npm install                  # 依存パッケージ再インストール
npx qiita version            # 動作確認
npx zenn --version           # 動作確認
```

初回利用時は `npx qiita login` / `npx zenn init` が必要な場合がある。

## ライセンス

Private project.
