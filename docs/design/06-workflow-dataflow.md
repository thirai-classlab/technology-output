# ワークフロー・データフロー・投稿基盤 全体図

> ステータス: **確定**
> 最終更新: 2026-02-09

---

## 1. 全体フロー

```mermaid
flowchart LR
    P1["1. ブレスト<br/>/explore"]
    P2["2. 企画<br/>/strategy"]
    P3["3. マスター作成<br/>/draft"]
    P4["4. 媒体別変換<br/>/convert"]
    P5["5. 下書き投稿<br/>/post"]
    P6["6. 公開+Slack<br/>/post"]
    P7["7. 分析<br/>/track"]

    P1 --> P2 --> P3 --> P4 --> P5 --> P6 --> P7
    P7 -.->|次の記事へ| P1

    P1:::collab
    P2:::collab
    P3:::ai
    P4:::ai
    P5:::ai
    P6:::human
    P7:::collab

    classDef human fill:#ffcdd2,stroke:#c62828
    classDef ai fill:#c8e6c9,stroke:#2e7d32
    classDef collab fill:#e3f2fd,stroke:#1565c0
```

**凡例**: 赤=人間主導 / 緑=AI主導 / 青=共同作業

---

## 2. コマンド・データ・ツールの流れ（詳細）

```mermaid
flowchart TD
    subgraph phase1["Phase 1-2: ブレスト・企画"]
        direction TB
        CMD1["/explore"]
        CMD2["/strategy"]
        CMD1 -->|生成| D_EXP["explore.md<br/>探索記録"]
        D_EXP -->|入力| CMD2
        CMD2 -->|生成| D_STR["strategy.md<br/>戦略・媒体選択・KPI"]

        CMD1 -.->|Web検索| TOOL_WEB["WebSearch<br/>競合調査"]
    end

    subgraph phase2["Phase 3: マスター作成"]
        direction TB
        CMD3["/draft"]
        D_STR -->|入力| CMD3
        D_EXP -->|参照| CMD3
        CMD3 -->|生成| D_MASTER["master.md<br/>原本記事"]

        CMD3 -.->|並列執筆| TOOL_TASK1["Task ツール<br/>セクション分割"]
    end

    subgraph phase3["Phase 4: 媒体別変換"]
        direction TB
        CMD4["/convert"]
        D_MASTER -->|入力| CMD4
        D_STR -->|媒体戦略参照| CMD4

        CMD4 -->|生成| D_NOTE["platforms/note.md"]
        CMD4 -->|生成| D_QIITA["platforms/qiita.md"]
        CMD4 -->|生成| D_ZENN["platforms/zenn.md"]
        CMD4 -->|生成| D_WP["platforms/wordpress.md"]
        CMD4 -->|生成| D_GIT["platforms/internal-git.md"]

        CMD4 -.->|5並列変換| TOOL_TASK2["Task ツール<br/>サブエージェント"]
    end

    subgraph phase4["Phase 5-6: 下書き・公開・Slack"]
        direction TB
        CMD5["/post"]

        D_NOTE -->|入力| SK_NOTE["post-note<br/>scripts/post-note.py"]
        D_QIITA -->|入力| SK_QIITA["post-qiita<br/>qiita-cli"]
        D_ZENN -->|入力| SK_ZENN["post-zenn<br/>zenn-cli + git"]
        D_WP -->|入力| SK_WP["post-wordpress<br/>REST API"]
        D_GIT -->|入力| SK_GIT["post-internal-git<br/>GitHub API"]

        CMD5 -->|並列実行| SK_NOTE & SK_QIITA & SK_ZENN & SK_WP & SK_GIT

        SK_NOTE & SK_QIITA & SK_ZENN & SK_WP & SK_GIT -->|URL記録| D_TRACK["track.md<br/>投稿記録"]

        D_TRACK -->|URL参照| SK_SLACK["post-slack<br/>Slack MCP"]
        SK_SLACK -->|投稿| SLACK["#input チャンネル"]
    end

    subgraph phase5["Phase 7: 分析"]
        direction TB
        CMD6["/track"]
        D_TRACK -->|入力| CMD6
        CMD6 -->|更新| D_TRACK
        CMD6 -->|フィードバック| D_LEARN["次回 strategy.md<br/>前回の学び"]
    end

    phase1 --> phase2 --> phase3 --> phase4 --> phase5

    classDef cmd fill:#fff3e0,stroke:#e65100,font-weight:bold
    classDef data fill:#e8f5e9,stroke:#2e7d32
    classDef skill fill:#e3f2fd,stroke:#1565c0
    classDef tool fill:#f3e5f5,stroke:#7b1fa2

    class CMD1,CMD2,CMD3,CMD4,CMD5,CMD6 cmd
    class D_EXP,D_STR,D_MASTER,D_NOTE,D_QIITA,D_ZENN,D_WP,D_GIT,D_TRACK,D_LEARN data
    class SK_NOTE,SK_QIITA,SK_ZENN,SK_WP,SK_GIT,SK_SLACK skill
    class TOOL_WEB,TOOL_TASK1,TOOL_TASK2 tool
```

**凡例**: オレンジ=コマンド / 緑=データ / 青=Skill / 紫=ツール

---

## 3. フェーズ別詳細

### 3.1 ブレスト・企画

```mermaid
flowchart LR
    subgraph input["入力"]
        THEME[人間がテーマを提示]
    end

    subgraph explore["/explore"]
        E1[テーマ妥当性] --> E2[ペルソナ定義]
        E2 --> E3[競合調査]
        E3 --> E4[コアメッセージ]
        E4 --> E5[構成案]
    end

    subgraph strategy["/strategy"]
        S1[目的] --> S2[差別化]
        S2 --> S3[媒体選択]
        S3 --> S4[KPI設定]
    end

    subgraph output["成果物"]
        OUT1["explore.md"]
        OUT2["strategy.md"]
    end

    THEME --> explore
    explore --> OUT1
    OUT1 --> strategy
    strategy --> OUT2
```

| 項目 | /explore | /strategy |
|------|----------|-----------|
| コマンド | `.claude/commands/explore.md` | `.claude/commands/strategy.md` |
| ルール | `.ai/content/brainstorm/explore.md` | `.ai/content/strategy/strategy.md` |
| ツール | WebSearch（競合調査） | なし（対話中心） |
| 入力 | テーマ（人間） | explore.md |
| 出力 | explore.md | strategy.md（ステータス: 確定） |

---

### 3.2 マスター作成

```mermaid
flowchart LR
    subgraph input["入力"]
        IN1["strategy.md<br/>構成案・コアメッセージ"]
        IN2["explore.md<br/>調査結果"]
    end

    subgraph draft["/draft"]
        D1[構成案に沿って執筆]
        D2[セルフチェック]
        D1 --> D2
        D1 -.->|大規模記事| PAR["Task ツール<br/>セクション並列執筆"]
    end

    subgraph review["/review ループ"]
        R1[人間がレビュー]
        R2[AIが修正]
        R1 --> R2 --> R1
    end

    subgraph output["成果物"]
        OUT["master.md<br/>原本（媒体非依存）"]
    end

    IN1 & IN2 --> draft --> OUT --> review --> OUT
```

| 項目 | /draft | /review |
|------|--------|---------|
| コマンド | `.claude/commands/draft.md` | `.claude/commands/review.md` |
| ルール | `.ai/content/writing/draft.md` | `.ai/content/review/review.md` |
| ツール | Task（セクション並列執筆） | なし（対話） |
| 入力 | strategy.md + explore.md | master.md + 人間のフィードバック |
| 出力 | master.md | master.md（レビュー済み） |

---

### 3.3 媒体別変換

```mermaid
flowchart TD
    subgraph input["入力"]
        MASTER["master.md"]
        STR["strategy.md<br/>媒体戦略"]
        RULES["共通ルール<br/>.ai/content/posting/common.md"]
    end

    subgraph convert["/convert — 5並列サブエージェント"]
        direction LR
        C1["note変換<br/>Mermaid→テキスト図解<br/>エッセイ調"]
        C2["Qiita変換<br/>タグ追加<br/>対象読者セクション"]
        C3["Zenn変換<br/>frontmatter追加<br/>メッセージボックス"]
        C4["WordPress変換<br/>SEOメタ追加<br/>CTA"]
        C5["社内Git変換<br/>である体<br/>社内補足"]
    end

    subgraph output["成果物 — platforms/"]
        O1["note.md"]
        O2["qiita.md"]
        O3["zenn.md"]
        O4["wordpress.md"]
        O5["internal-git.md"]
    end

    MASTER --> C1 & C2 & C3 & C4 & C5
    STR --> convert
    RULES --> convert
    C1 --> O1
    C2 --> O2
    C3 --> O3
    C4 --> O4
    C5 --> O5
```

| 媒体 | 変換ルール | 主な変換内容 |
|------|-----------|-------------|
| note | `.ai/content/posting/note.md` | Mermaid→テキスト図解、エッセイ調、リード文追加 |
| Qiita | `.ai/content/posting/qiita.md` | タグコメント、対象読者セクション、参考リンク |
| Zenn | `.ai/content/posting/zenn.md` | YAML frontmatter、:::message ボックス |
| WordPress | `.ai/content/posting/wordpress.md` | SEOメタコメント、SEO見出し最適化、CTA |
| 社内Git | `.ai/content/posting/internal-git.md` | である体、社内向け補足セクション |

---

### 3.4 下書き投稿・公開・Slack展開

```mermaid
flowchart TD
    subgraph draft_post["下書き投稿 — /post（前半）"]
        direction TB
        CHECK[投稿前チェック<br/>ファイル存在・媒体確認]
        CONFIRM1[人間に投稿先を確認]
        CHECK --> CONFIRM1
        CONFIRM1 --> PARALLEL1["Task ツールで Skill を並列実行"]
    end

    subgraph skills_draft["Skill 並列実行（下書き）"]
        direction LR
        S1["post-wordpress<br/>REST API<br/>status: draft"]
        S2["post-qiita<br/>npx qiita publish<br/>private: true"]
        S3["post-zenn<br/>git push<br/>published: false"]
        S4["post-note<br/>scripts/post-note.py<br/>draft"]
        S5["post-internal-git<br/>GitHub API<br/>直接コミット"]
    end

    subgraph review_publish["確認・公開 — /post（後半）"]
        direction TB
        HUMAN_CHECK["人間が各媒体で下書き確認"]
        CONFIRM2["公開承認"]
        PARALLEL2["Skill を --publish で再実行"]
        HUMAN_CHECK --> CONFIRM2 --> PARALLEL2
    end

    subgraph post_process["公開後処理"]
        direction TB
        RECORD["track.md に公開URL記録"]
        CROSS["クロスリンク追記"]
        SLACK_SKILL["post-slack Skill"]
        SLACK_CH["Slack #input チャンネル"]

        RECORD --> CROSS --> SLACK_SKILL --> SLACK_CH
    end

    draft_post --> skills_draft --> review_publish --> post_process

    classDef human fill:#ffcdd2,stroke:#c62828
    class CONFIRM1,HUMAN_CHECK,CONFIRM2 human
```

| Skill | 投稿手段 | 認証方式 | 下書き | 公開 |
|-------|---------|---------|--------|------|
| post-wordpress | WordPress REST API (curl) | Basic認証（.mcp.json） | `status: draft` | `status: publish` |
| post-qiita | `npx qiita publish` | GitHub連携 | `private: true` | `private: false` + `--force` |
| post-zenn | `git push` (zenn-cli) | Git SSH | `published: false` | `published: true` + push |
| post-note | `scripts/post-note.py` | Cookie認証（.env） | `draft` サブコマンド | `publish` サブコマンド |
| post-internal-git | GitHub API (curl) | Fine-grained PAT | masterに直接コミット | （コミット=公開） |
| post-slack | Slack MCP | xoxp トークン | - | メッセージ投稿 |

---

### 3.5 分析

```mermaid
flowchart LR
    subgraph input["入力"]
        TRACK["track.md<br/>投稿記録・公開URL"]
    end

    subgraph collect["/track — 反響データ収集"]
        direction TB
        M1["Qiita: いいね・ストック"]
        M2["Zenn: いいね"]
        M3["note: スキ"]
        M4["WordPress: PV"]
        M5["社内Git: 閲覧数"]
    end

    subgraph analyze["分析・振り返り"]
        A1[KPI達成度の評価]
        A2[媒体別の反応比較]
        A3[改善点の抽出]
        A1 --> A2 --> A3
    end

    subgraph output["成果物"]
        OUT1["track.md<br/>反響データ更新"]
        OUT2["次回 strategy.md<br/>前回の学びに反映"]
    end

    TRACK --> collect --> analyze
    analyze --> OUT1 & OUT2
```

| 項目 | 内容 |
|------|------|
| コマンド | `.claude/commands/track.md` |
| ルール | `.ai/content/track/track.md` |
| 計測タイミング | 投稿後1週間・1ヶ月 |
| KPI例 | Qiita いいね50+、Zenn いいね30+、note スキ20+、WP PV500+ |

---

## 4. データの生成・参照関係

```mermaid
flowchart LR
    subgraph files["記事ディレクトリ posts/NNN-slug/"]
        EXP["explore.md"]
        STR["strategy.md"]
        MASTER["master.md"]
        IMG["images.md"]
        TRACK["track.md"]

        subgraph plat["platforms/"]
            P_NOTE["note.md"]
            P_QIITA["qiita.md"]
            P_ZENN["zenn.md"]
            P_WP["wordpress.md"]
            P_GIT["internal-git.md"]
        end
    end

    E["/explore"] -->|生成| EXP
    S["/strategy"] -->|生成| STR
    EXP -->|参照| S
    D["/draft"] -->|生成| MASTER
    STR -->|参照| D
    EXP -->|参照| D

    CV["/convert"] -->|生成| plat
    MASTER -->|入力| CV
    STR -->|媒体戦略| CV
    CV -->|画像URL| IMG

    PO["/post"] -->|読み込み| plat
    PO -->|生成・更新| TRACK
    STR -->|ステータス更新| PO

    TR["/track"] -->|更新| TRACK
    TRACK -->|次回に反映| STR

    classDef cmd fill:#fff3e0,stroke:#e65100
    classDef file fill:#e8f5e9,stroke:#2e7d32

    class E,S,D,CV,PO,TR cmd
    class EXP,STR,MASTER,IMG,TRACK,P_NOTE,P_QIITA,P_ZENN,P_WP,P_GIT file
```

---

## 5. 投稿基盤の全体構成

```mermaid
flowchart TB
    subgraph claude["Claude Code"]
        CMD["/post コマンド<br/>.claude/commands/post.md"]
        CMD -->|Task ツールで並列起動| SKILLS
        subgraph SKILLS["Skills（サブエージェント）"]
            SK1["post-wordpress"]
            SK2["post-qiita"]
            SK3["post-zenn"]
            SK4["post-note"]
            SK5["post-internal-git"]
            SK6["post-slack"]
        end
    end

    subgraph infra["投稿基盤"]
        direction LR
        subgraph api_group["API"]
            WP_API["WordPress REST API<br/>takuma-h.sandboxes.jp"]
            NOTE_API["note.com 非公式API<br/>scripts/post-note.py"]
            GH_API["GitHub API<br/>classlab-inc/document"]
        end
        subgraph cli_group["CLI"]
            Q_CLI["qiita-cli<br/>npx qiita publish"]
            Z_CLI["zenn-cli<br/>git push"]
        end
        subgraph mcp_group["MCP"]
            SL_MCP["Slack MCP<br/>#input C08ACUZ7Z1U"]
        end
    end

    subgraph platforms["投稿先プラットフォーム"]
        direction LR
        WP_SITE["WordPress<br/>takuma-h.sandboxes.jp"]
        QIITA["Qiita<br/>qiita.com/takuma-h"]
        ZENN["Zenn<br/>zenn.dev/takuma_h"]
        NOTE["note<br/>note.com"]
        GITHUB["社内Git<br/>github.com/classlab-inc"]
        SLACK["Slack<br/>#input"]
    end

    SK1 --> WP_API --> WP_SITE
    SK2 --> Q_CLI --> QIITA
    SK3 --> Z_CLI --> ZENN
    SK4 --> NOTE_API --> NOTE
    SK5 --> GH_API --> GITHUB
    SK6 --> SL_MCP --> SLACK

    subgraph auth["認証情報"]
        direction LR
        AUTH1[".mcp.json<br/>WP: Basic認証<br/>GitHub: PAT<br/>Slack: xoxp"]
        AUTH2[".env<br/>NOTE_COOKIES"]
        AUTH3["Git SSH<br/>Zenn用"]
        AUTH4["GitHub連携<br/>Qiita用"]
    end

    auth -.->|認証| infra
```

| 媒体 | 投稿基盤 | 認証情報の格納先 | プロトコル |
|------|---------|-----------------|-----------|
| WordPress | REST API (curl) | `.mcp.json` (username + password) | HTTPS |
| Qiita | qiita-cli (npm) | GitHub OAuth連携 | HTTPS |
| Zenn | zenn-cli + git push | Git SSH鍵 | SSH |
| note | scripts/post-note.py | `.env` (NOTE_COOKIES) | HTTPS |
| 社内Git | GitHub API (curl) | `.mcp.json` (Fine-grained PAT) | HTTPS |
| Slack | Slack MCP | `.mcp.json` (xoxp トークン) | HTTPS |

---

## 6. 投稿順序とタイミング

```mermaid
sequenceDiagram
    participant H as 人間
    participant P as /post コマンド
    participant WP as WordPress
    participant Q as Qiita
    participant Z as Zenn
    participant N as note
    participant G as 社内Git
    participant S as Slack

    H->>P: /post 実行
    P->>H: 投稿先確認

    Note over P: 下書き投稿（並列）
    par 並列実行
        P->>WP: draft投稿
        P->>Q: private投稿
        P->>Z: published:false push
        P->>N: draft投稿
        P->>G: masterコミット
    end

    WP-->>P: 編集URL
    Q-->>P: 記事URL
    Z-->>P: ダッシュボードURL
    N-->>P: 編集URL
    G-->>P: GitHub URL

    P->>H: 下書き一覧を報告
    H->>H: 各媒体で下書き確認
    H->>P: 公開承認

    Note over P: 公開（並列）
    par 並列実行
        P->>WP: status:publish
        P->>Q: private:false
        P->>Z: published:true push
        P->>N: publish
    end

    WP-->>P: 公開URL
    Q-->>P: 公開URL
    Z-->>P: 公開URL
    N-->>P: 公開URL

    Note over P: 公開後処理
    P->>P: track.md に全URL記録
    P->>P: クロスリンク追記
    P->>S: 全URL付きメッセージ
    S-->>H: #input に通知
```
