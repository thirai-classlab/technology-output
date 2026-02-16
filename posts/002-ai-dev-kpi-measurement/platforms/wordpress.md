<!-- SEO
title: AI駆動開発の生産性を計測する方法｜Claude Code Hooks APIで可視化
description: AI駆動開発の生産性を「なんとなく便利」で終わらせていませんか？Claude Code Hooks APIでチームの利用状況を自動収集し、ダッシュボードで可視化する方法を実例付きで解説します。
category: AI駆動開発
tags: AI駆動開発, Claude Code, KPI, 生産性計測, AI コーディング 効果測定
-->

<!-- wp:heading -->
<h2>AI駆動開発の生産性、ちゃんと計れていますか？</h2>
<!-- /wp:heading -->

<!-- wp:paragraph -->
<p>「メンバー全員、Claude Code をもっと使うべきだ。MAX×20プランを使い切るぐらい活用してほしい」</p>
<!-- /wp:paragraph -->

<!-- wp:paragraph -->
<p>上長からこう言われたとき、正直なところ返す言葉がありませんでした。チームに Claude Code の Max プランを導入して数ヶ月。「便利になった」「コードレビューが楽になった」という声は聞こえてきます。しかし、実際にどのメンバーがどれくらい使っていて、どんなタスクに活用しているのか——そのデータがどこにもなかったのです。</p>
<!-- /wp:paragraph -->

[quote author="METR" source="Measuring the Impact of Early AI Assistance on Software Development" url="https://metr.org/blog/2025-07-10-early-ai-impact/"]経験豊富な開発者16人を対象としたランダム化比較試験で、AIツール使用時に生産性が19%低下した。しかも開発者自身は「24%速くなった」と予想し、実験後も「20%速くなった」と感じていた。[/quote]

<!-- wp:paragraph -->
<p>体感と実態のギャップ——これは他人事ではありません。[marker color="yellow"]「なんとなく便利」では、投資対効果を示せません[/marker]。チームの AI 活用を改善するには、まず計測できる状態を作る必要があります。</p>
<!-- /wp:paragraph -->

<!-- wp:paragraph -->
<p>そこで構築したのが、<strong>Claude Code の Hooks API を使ったチーム利用状況の自動収集・可視化システム</strong>です。本記事では、AI駆動開発の生産性を計測するための KPI 設計から、データ収集アーキテクチャ、ダッシュボードの機能までを実例付きで解説します。</p>
<!-- /wp:paragraph -->

<!-- wp:heading -->
<h2>AI コーディングの効果測定で何を測るべきか——4ティアKPI体系</h2>
<!-- /wp:heading -->

<!-- wp:paragraph -->
<p>AI コーディングツールの効果をどう定義し、何を測るべきでしょうか。単純な「コード生成行数」や「使用時間」では本質を捉えられません。チーム運用の中で見えてきた計測軸を、4つのティアに体系化しました。</p>
<!-- /wp:paragraph -->

<!-- wp:html -->
<pre class="mermaid">
graph TD
    T1[Tier 1: セッション効率]
    T2[Tier 2: AI品質]
    T3[Tier 3: 自律性・成熟度]
    T4[Tier 4: コスト効率]

    T1 --> T2
    T2 --> T3
    T3 --> T4

    T1 --- T1D["ターン数/セッション<br/>トークン数/ターン<br/>セッション時間<br/>ツール呼出数/ターン"]
    T2 --- T2D["ファーストパス成功率<br/>コードチャーン率<br/>人的介入率<br/>提案採用率"]
    T3 --- T3D["自律度比率<br/>エスカレーション頻度<br/>自己修正率<br/>コンテキスト活用効率"]
    T4 --- T4D["成果物あたりコスト<br/>トークン効率比<br/>ROI"]
</pre>
<!-- /wp:html -->

<!-- wp:heading {"level":3} -->
<h3>Tier 1: セッション効率——基礎的な利用状況の把握</h3>
<!-- /wp:heading -->

<!-- wp:paragraph -->
<p>最も基礎的な指標です。1セッションあたりのターン数が3〜8回なら効率的で、40回を超えると非効率なセッションの可能性があります。ツール呼出数が多ければ AI が自律的に作業を進めている証拠になります。</p>
<!-- /wp:paragraph -->

<!-- wp:heading {"level":3} -->
<h3>Tier 2: AI品質——提案精度を測る</h3>
<!-- /wp:heading -->

<!-- wp:paragraph -->
<p>AI の提案がどれだけ「一発で通る」かを測ります。ファーストパス成功率が60%を超えていれば良好です。コードチャーン率（AI が書いたコードが72時間以内に書き直される割合）が30%を超えていると要改善のサインです。</p>
<!-- /wp:paragraph -->

<!-- wp:heading {"level":3} -->
<h3>Tier 3: 自律性・成熟度——AI の自走力を評価</h3>
<!-- /wp:heading -->

<!-- wp:paragraph -->
<p>人間の介入なしに AI がどこまで自走できるかの指標です。自律度比率80%以上がエキスパートレベルとなります。</p>
<!-- /wp:paragraph -->

<!-- wp:heading {"level":3} -->
<h3>Tier 4: コスト効率——投資対効果の核心</h3>
<!-- /wp:heading -->

<!-- wp:paragraph -->
<p>成果物（PR・バグ修正等）あたりのコストや、トークン効率比（消費トークン÷採用されたコード行数）で測ります。AI駆動開発の生産性を経営層に示す際に最も重要な指標です。</p>
<!-- /wp:paragraph -->

<!-- wp:heading {"level":3} -->
<h3>レベル別ベンチマーク</h3>
<!-- /wp:heading -->

<!-- wp:table -->
<figure class="wp-block-table"><table>
<thead><tr><th>レベル</th><th>ターン数/セッション</th><th>ファーストパス成功率</th><th>自律度比率</th><th>日次コスト目安</th></tr></thead>
<tbody>
<tr><td>[badge color="accent"]Expert[/badge]</td><td>3〜8</td><td>70%以上</td><td>80%以上</td><td>$4以下</td></tr>
<tr><td>[badge color="primary"]Advanced[/badge]</td><td>9〜15</td><td>50〜70%</td><td>60〜80%</td><td>$4〜8</td></tr>
<tr><td>[badge color="warning"]Intermediate[/badge]</td><td>16〜25</td><td>30〜50%</td><td>40〜60%</td><td>$8〜15</td></tr>
<tr><td>[badge color="danger"]Beginner[/badge]</td><td>25以上</td><td>30%未満</td><td>40%未満</td><td>$15以上</td></tr>
</tbody>
</table></figure>
<!-- /wp:table -->

[tip]このベンチマークはチーム運用から得た実測値に基づいています。組織の開発スタイルに合わせて閾値を調整してください。[/tip]

<!-- wp:heading -->
<h2>アーキテクチャ設計——Hooks API でデータを自動収集する仕組み</h2>
<!-- /wp:heading -->

<!-- wp:paragraph -->
<p>KPI を計測するには、まずデータを集める基盤が必要です。Claude Code の Hooks API を使えば、開発者の作業を妨げることなく、利用データを自動収集できます。</p>
<!-- /wp:paragraph -->

<!-- wp:heading {"level":3} -->
<h3>全体アーキテクチャ</h3>
<!-- /wp:heading -->

<!-- wp:html -->
<pre class="mermaid">
graph LR
    subgraph "各メンバーPC"
        CC[Claude Code] -->|イベント発火| H[Hook Scripts<br/>6種]
    end

    subgraph "サーバー（Docker）"
        API[Express API<br/>6エンドポイント]
        DB[(MariaDB<br/>7テーブル)]
        DASH[Next.js<br/>ダッシュボード<br/>9ページ]
        AI[AI分析<br/>Claude Agent SDK]

        API -->|Prisma| DB
        DASH -->|18 API| DB
        AI -->|分析| DB
    end

    H -->|POST /api/hook/*| API
</pre>
<!-- /wp:html -->

<!-- wp:paragraph -->
<p>各メンバーの PC に配置した6種のフックスクリプトが、Claude Code のライフサイクルイベント（セッション開始・プロンプト送信・ツール実行・応答完了・セッション終了）を検知し、中央サーバーに自動送信します。メンバーは普段の開発作業をそのまま行うだけで、データが蓄積されていきます。</p>
<!-- /wp:paragraph -->

<!-- wp:heading {"level":3} -->
<h3>6種のフックイベントで網羅的にデータ収集</h3>
<!-- /wp:heading -->

<!-- wp:table -->
<figure class="wp-block-table"><table>
<thead><tr><th>フック</th><th>タイミング</th><th>取得データ</th></tr></thead>
<tbody>
<tr><td>SessionStart</td><td>セッション開始</td><td>モデル名、開始種別、Git リポジトリ・ブランチ</td></tr>
<tr><td>UserPromptSubmit</td><td>プロンプト送信</td><td>プロンプト全文</td></tr>
<tr><td>SubagentStart</td><td>サブエージェント起動</td><td>エージェント種別（Bash/Explore/Plan等）</td></tr>
<tr><td>SubagentStop</td><td>サブエージェント終了</td><td>トークン消費量、ツール使用記録</td></tr>
<tr><td>Stop</td><td>応答完了</td><td>トランスクリプト解析 → 全メトリクス</td></tr>
<tr><td>SessionEnd</td><td>セッション終了</td><td>終了理由（user_exit/clear/logout）</td></tr>
</tbody>
</table></figure>
<!-- /wp:table -->

[info]最も重要なのは <strong>Stop フック</strong> です。Claude Code が応答を完了するたびに発火し、JSONL 形式のトランスクリプトファイルを解析して、セッション全体のトークン消費量・ツール使用・ファイル変更・エラー数などを一括で集計します。[/info]

<!-- wp:heading {"level":3} -->
<h3>データフロー: プロンプトからDB保存まで</h3>
<!-- /wp:heading -->

<!-- wp:html -->
<pre class="mermaid">
sequenceDiagram
    participant Dev as 開発者
    participant CC as Claude Code
    participant Hook as Hook Script
    participant API as Express API
    participant DB as MariaDB

    Dev->>CC: プロンプト入力
    CC->>Hook: UserPromptSubmit イベント
    Hook->>API: POST /api/hook/prompt
    API->>DB: Turn レコード作成

    CC->>CC: ツール実行・コード生成
    CC->>Hook: Stop イベント
    Hook->>Hook: JSONL トランスクリプト解析
    Hook->>API: POST /api/hook/stop（全メトリクス）
    API->>DB: Session/Turn/ToolUse/FileChange 更新
</pre>
<!-- /wp:html -->

<!-- wp:heading {"level":3} -->
<h3>DB スキーマ（7テーブル）</h3>
<!-- /wp:heading -->

<!-- wp:table -->
<figure class="wp-block-table"><table>
<thead><tr><th>テーブル</th><th>役割</th><th>主なカラム</th></tr></thead>
<tbody>
<tr><td>Member</td><td>メンバー情報</td><td>git_email（主キー）、claude_account</td></tr>
<tr><td>Session</td><td>セッション情報</td><td>session_uuid、total_input_tokens、total_output_tokens、estimated_cost、turn_count</td></tr>
<tr><td>Turn</td><td>ターン情報</td><td>prompt_text、duration_ms、input_tokens、output_tokens、model</td></tr>
<tr><td>Subagent</td><td>サブエージェント</td><td>agent_type、duration_seconds、input_tokens、output_tokens</td></tr>
<tr><td>ToolUse</td><td>ツール使用記録</td><td>tool_name、tool_category、status、is_mcp、mcp_server</td></tr>
<tr><td>FileChange</td><td>ファイル変更記録</td><td>file_path、operation（read/write/edit）</td></tr>
<tr><td>SessionEvent</td><td>セッションイベント</td><td>event_type、event_data（JSON）</td></tr>
</tbody>
</table></figure>
<!-- /wp:table -->

<!-- wp:heading {"level":3} -->
<h3>ワンコマンドでセットアップ完了</h3>
<!-- /wp:heading -->

<!-- wp:paragraph -->
<p>チームメンバーが簡単にセットアップできるインストーラを用意しました。</p>
<!-- /wp:paragraph -->

<pre class="language-bash" data-lang="Bash"><code>bash &lt;(curl -s https://your-server/install.sh)</code></pre>

[steps]
[step title="フックスクリプトの配置"]6種のフックスクリプトを <code>~/.claude/hooks/</code> に自動配置します。[/step]
[step title="設定ファイルの生成"]API接続先の設定ファイル（<code>config.json</code>）を生成します。[/step]
[step title="グローバル設定のマージ"]Claude Code のグローバル設定（<code>~/.claude/settings.json</code>）にフック定義を安全にマージします。[/step]
[step title="疎通テストの実行"]API サーバーへの疎通テストを自動実行し、接続を確認します。[/step]
[/steps]

[note]既存のフック設定がある場合も安全にマージされ、開発環境を壊さない設計になっています。[/note]

<!-- wp:heading {"level":3} -->
<h3>必要なキー設定</h3>
<!-- /wp:heading -->

<!-- wp:paragraph -->
<p>本システムを利用するには、以下の3つのキーを設定します。</p>
<!-- /wp:paragraph -->

<!-- wp:table -->
<figure class="wp-block-table"><table>
<thead><tr><th>キー</th><th>用途</th><th>設定場所</th></tr></thead>
<tbody>
<tr><td>GitHub PAT（Personal Access Token）</td><td>リポジトリ・ブランチ情報の取得、コード変更の追跡</td><td>サーバー側環境変数</td></tr>
<tr><td>Claude Code 認証（2種から選択）</td><td>ダッシュボードの AI 分析チャット・コーチング機能（Claude Agent SDK）</td><td>サーバー側環境変数</td></tr>
</tbody>
</table></figure>
<!-- /wp:table -->

<!-- wp:paragraph -->
<p>Claude Code の認証は以下の2種類から選択できます:</p>
<!-- /wp:paragraph -->

<!-- wp:list {"ordered":true} -->
<ol>
<li><strong>Max プランのサブスクリプション</strong>（OAuth ログイン）</li>
<li><strong>Anthropic API Key</strong></li>
</ol>
<!-- /wp:list -->

<!-- wp:list -->
<ul>
<li><strong>GitHub PAT</strong> を設定すると、セッションごとのリポジトリ名・ブランチ名を自動取得し、リポジトリ分析ページでプロジェクト単位の AI 活用状況を可視化できます</li>
<li><strong>Claude Code 認証</strong> を設定すると、チーム概要・メンバー詳細ページの AI 分析チャットが利用可能になり、データに基づいた自然言語での質問や改善提案を受けられます。Max プランのサブスク契約があればそのまま利用でき、API Key でも同等の機能が使えます</li>
</ul>
<!-- /wp:list -->

[tip]GitHub PAT は <code>repo</code> スコープが必要です。Claude Code 認証は Max プランのサブスクリプションまたは Anthropic API Key のどちらか一方を設定してください。[/tip]

<!-- wp:heading -->
<h2>実装のポイント——トランスクリプト解析とコスト計算</h2>
<!-- /wp:heading -->

<!-- wp:heading {"level":3} -->
<h3>Prisma スキーマ</h3>
<!-- /wp:heading -->

<!-- wp:paragraph -->
<p>セッション単位でトークン消費量を追跡します。Anthropic のプロンプトキャッシュ機能に対応し、<code>cache_creation_tokens</code> と <code>cache_read_tokens</code> を分離して記録している点がポイントです。</p>
<!-- /wp:paragraph -->

<pre class="language-typescript" data-lang="Prisma"><code>model Session {
  id                       Int       @id @default(autoincrement())
  memberId                 Int?      @map("member_id")
  sessionUuid              String    @unique @map("session_uuid")
  model                    String?
  totalInputTokens         Int       @default(0) @map("total_input_tokens")
  totalOutputTokens        Int       @default(0) @map("total_output_tokens")
  totalCacheCreationTokens Int       @default(0) @map("total_cache_creation_tokens")
  totalCacheReadTokens     Int       @default(0) @map("total_cache_read_tokens")
  estimatedCost            Float?    @map("estimated_cost") @db.Double
  turnCount                Int       @default(0) @map("turn_count")
  toolUseCount             Int       @default(0) @map("tool_use_count")
  summary                  String?   @db.Text
  gitRepo                  String?   @map("git_repo")
  gitBranch                String?   @map("git_branch")

  member        Member?        @relation(fields: [memberId], references: [id])
  turns         Turn[]
  toolUses      ToolUse[]
  fileChanges   FileChange[]
  sessionEvents SessionEvent[]

  startedAt             DateTime? @map("started_at")

  @@index([memberId])
  @@index([startedAt])
  @@index([model])
  @@map("sessions")
}</code></pre>

<!-- wp:heading {"level":3} -->
<h3>トランスクリプト解析</h3>
<!-- /wp:heading -->

<!-- wp:paragraph -->
<p>Stop フックの核心は、Claude Code が出力する JSONL 形式のトランスクリプトファイルの解析です。JSONL の各行は <code>assistant</code>、<code>user</code>、<code>system</code>、<code>summary</code> のいずれかの type を持ちます。</p>
<!-- /wp:paragraph -->

<pre class="language-javascript" data-lang="JavaScript"><code>function parseTranscript(transcriptPath) {
  const lines = fs.readFileSync(transcriptPath, 'utf8')
    .split('\n').filter(Boolean);

  for (const line of lines) {
    const obj = JSON.parse(line);

    if (obj.type === 'assistant') {
      // トークン数・モデル名を集計
      // tool_use ブロックからツール使用を抽出
      // Write/Edit ツールからファイル変更を記録
    }

    if (obj.type === 'user') {
      // tool_result でなければ新しいターン
      // tool_result のエラーをツール使用記録に反映
    }

    if (obj.type === 'system') {
      // turn_duration: ターンごとの所要時間
      // compact_boundary: コンテキスト圧縮イベント
    }
  }
}</code></pre>

<!-- wp:paragraph -->
<p>ツール使用は7カテゴリに自動分類されます。</p>
<!-- /wp:paragraph -->

<pre class="language-javascript" data-lang="JavaScript"><code>function getToolCategory(name) {
  if (/^(Read|Glob|Grep)$/.test(name)) return 'search';
  if (/^(Write|Edit|MultiEdit)$/.test(name)) return 'file_edit';
  if (name === 'Bash') return 'bash';
  if (name === 'Task') return 'subagent';
  if (/^(WebFetch|WebSearch)$/.test(name)) return 'web';
  if (/^mcp__/.test(name)) return 'mcp';
  return 'other';
}</code></pre>

[tip]MCP（Model Context Protocol）ツールは <code>mcp__</code> プレフィックスで自動検出し、どの MCP サーバー経由の呼び出しかも記録します。[/tip]

<!-- wp:heading {"level":3} -->
<h3>コスト計算</h3>
<!-- /wp:heading -->

<!-- wp:paragraph -->
<p>モデルごとの単価テーブルに基づき、セッション単位でコストを算出します。プロンプトキャッシュの書き込み・読み込みも個別単価で計算するため、キャッシュ効率の分析も可能です。</p>
<!-- /wp:paragraph -->

<pre class="language-typescript" data-lang="TypeScript"><code>const COST_TABLE = {
  'claude-opus-4-6':          { input: 15,   output: 75, cacheWrite: 18.75, cacheRead: 1.50 },
  'claude-sonnet-4-5':        { input: 3,    output: 15, cacheWrite: 3.75,  cacheRead: 0.30 },
  'claude-haiku-4-5':         { input: 0.80, output: 4,  cacheWrite: 1.00,  cacheRead: 0.08 },
};

// 単位: USD per 1M tokens
function calculateCost(model: string, usage: TokenUsage) {
  const rates = COST_TABLE[model];
  return (usage.inputTokens / 1_000_000) * rates.input
       + (usage.outputTokens / 1_000_000) * rates.output
       + (usage.cacheCreationTokens / 1_000_000) * rates.cacheWrite
       + (usage.cacheReadTokens / 1_000_000) * rates.cacheRead;
}</code></pre>

<!-- wp:heading -->
<h2>ダッシュボードで AI 活用状況を可視化する</h2>
<!-- /wp:heading -->

<!-- wp:paragraph -->
<p>構築したダッシュボードは9つのページで構成されています。ここでは主要な機能をスクリーンショットとともにご紹介します。</p>
<!-- /wp:paragraph -->

<!-- wp:heading {"level":3} -->
<h3>チーム概要——全体の利用状況を俯瞰する</h3>
<!-- /wp:heading -->

<!-- wp:image -->
<figure class="wp-block-image"><img src="https://takuma-h.sandboxes.jp/wp-content/uploads/2026/02/002-team-overview.png" alt="チーム概要ダッシュボード - KPIカード、日次トークン推移、ツール使用ランキング、ヒートマップ" /></figure>
<!-- /wp:image -->

<!-- wp:paragraph -->
<p><strong>チーム概要</strong>では、総セッション数・総トークン数・推定コスト（前週比トレンド付き）・アクティブメンバー数を KPI カードで表示します。日次トークン推移の折れ線グラフ、ツール使用ランキング Top 10、そして曜日×時間帯・リポジトリ×日付・メンバー×日付の3軸ヒートマップで、[marker color="yellow"]「いつ、誰が、どのリポジトリで作業しているか」[/marker]がひと目でわかります。</p>
<!-- /wp:paragraph -->

<!-- wp:heading {"level":4} -->
<h4>AI分析チャット</h4>
<!-- /wp:heading -->

<!-- wp:image -->
<figure class="wp-block-image"><img src="https://takuma-h.sandboxes.jp/wp-content/uploads/2026/02/002-team-overview-chat.png" alt="AI分析チャット - 自然言語でダッシュボードデータに質問できる" /></figure>
<!-- /wp:image -->

<!-- wp:paragraph -->
<p>チーム概要ページには <strong>AI 分析チャット機能</strong>が統合されています。ダッシュボードのデータをコンテキストとして、Claude Agent SDK を通じて自然言語で質問できます。「今週最もコスト効率が良かったメンバーは？」「Opus と Sonnet の使い分けに偏りはある？」といった分析クエリに即座に回答します。</p>
<!-- /wp:paragraph -->

<!-- wp:heading {"level":3} -->
<h3>メンバー詳細——個人の AI 活用パターンを深掘りする</h3>
<!-- /wp:heading -->

<!-- wp:image -->
<figure class="wp-block-image"><img src="https://takuma-h.sandboxes.jp/wp-content/uploads/2026/02/002-member-detail.png" alt="メンバー詳細 - セッション分類、モデル使用内訳、ツール使用ランキング" /></figure>
<!-- /wp:image -->

<!-- wp:paragraph -->
<p>個人にドリルダウンした分析ページです。</p>
<!-- /wp:paragraph -->

<!-- wp:list -->
<ul>
<li><strong>セッション分類</strong>: Quick（短時間）/ Moderate（中程度）/ Complex（複雑）の3段階でセッションを自動分類</li>
<li><strong>モデル使用内訳</strong>: Opus / Sonnet / Haiku の使い分けをドーナツチャートで表示</li>
<li><strong>ツール使用ランキング</strong>: そのメンバーがよく使うツールの傾向</li>
<li><strong>週次トレンド</strong>: 日次の入出力トークン推移</li>
</ul>
<!-- /wp:list -->

<!-- wp:heading {"level":4} -->
<h4>AIコーチング</h4>
<!-- /wp:heading -->

<!-- wp:image -->
<figure class="wp-block-image"><img src="https://takuma-h.sandboxes.jp/wp-content/uploads/2026/02/002-member-detail-chat.png" alt="AIコーチング - 個人のデータに基づいた改善提案" /></figure>
<!-- /wp:image -->

<!-- wp:paragraph -->
<p>メンバー詳細ページにも AI 分析が統合されています。個人のデータに基づいた改善提案を受けられます。「セッション時間が長い傾向があります。タスクを細分化してみてはどうですか」「Opus の利用が多いですが、このタイプのタスクなら Sonnet でも十分かもしれません」——といった具体的なコーチングが可能です。</p>
<!-- /wp:paragraph -->

<!-- wp:heading {"level":3} -->
<h3>セッション詳細——ターン単位で原因を追跡する</h3>
<!-- /wp:heading -->

<!-- wp:image -->
<figure class="wp-block-image"><img src="https://takuma-h.sandboxes.jp/wp-content/uploads/2026/02/002-session-detail.png" alt="セッション詳細 - ターン別ツリー表示、ツール使用記録、サブエージェント、ファイル変更" /></figure>
<!-- /wp:image -->

<!-- wp:paragraph -->
<p>1つのセッションを最も細かく分析するページです。</p>
<!-- /wp:paragraph -->

<!-- wp:list -->
<ul>
<li><strong>ターン別ツリー表示</strong>: 各ターンのプロンプト、AI の応答、ツール使用をツリー構造で展開</li>
<li><strong>ツール使用記録</strong>: ツール名・カテゴリ・成否・エラーメッセージをすべて記録</li>
<li><strong>サブエージェント</strong>: Task ツール経由で起動されたサブエージェントのモデル・トークン・コストを個別表示</li>
<li><strong>ファイル変更</strong>: 操作種別（create/edit/delete/read）を色分けバッジで表示</li>
</ul>
<!-- /wp:list -->

<!-- wp:paragraph -->
<p>「このセッションでなぜコストが高くなったのか」「どのツール呼び出しでエラーが発生したのか」をターン単位で追跡できます。</p>
<!-- /wp:paragraph -->

<!-- wp:heading {"level":3} -->
<h3>メンバー一覧——チーム内の利用格差を発見する</h3>
<!-- /wp:heading -->

<!-- wp:image -->
<figure class="wp-block-image"><img src="https://takuma-h.sandboxes.jp/wp-content/uploads/2026/02/002-member-list.png" alt="メンバー一覧 - ランクバッジ、前週比変化率、メンバー×日付ヒートマップ" /></figure>
<!-- /wp:image -->

<!-- wp:paragraph -->
<p>メンバー全員のランキングと比較ができるページです。</p>
<!-- /wp:paragraph -->

<!-- wp:list -->
<ul>
<li><strong>ランクバッジ</strong>: トークン消費量でランキングを表示</li>
<li><strong>前週比変化率</strong>: 各メンバーの利用量が増加傾向か減少傾向かを可視化</li>
<li><strong>メンバー×日付ヒートマップ</strong>: 誰がいつ活発に使っているかのパターンを発見</li>
</ul>
<!-- /wp:list -->

<!-- wp:paragraph -->
<p>チーム内での利用格差や、活用が進んでいないメンバーを早期に発見できます。</p>
<!-- /wp:paragraph -->

<!-- wp:heading {"level":3} -->
<h3>その他のビュー</h3>
<!-- /wp:heading -->

[columns count="2"]
[column]
<!-- wp:heading {"level":4} -->
<h4>プロンプトフィード</h4>
<!-- /wp:heading -->

<!-- wp:image -->
<figure class="wp-block-image"><img src="https://takuma-h.sandboxes.jp/wp-content/uploads/2026/02/002-prompt-feed.png" alt="プロンプトフィード - チーム全員のプロンプトをリアルタイム表示" /></figure>
<!-- /wp:image -->

<!-- wp:paragraph -->
<p>チーム全員のプロンプトをリアルタイムで表示するタイムラインビューです。ユーザー → リポジトリ → ブランチ → セッション → プロンプトの階層構造で、15秒間隔で自動更新されます。「今、チームの誰がどんな作業をしているか」をリアルタイムで把握でき、ナレッジ共有のきっかけにもなります。</p>
<!-- /wp:paragraph -->
[/column]
[column]
<!-- wp:heading {"level":4} -->
<h4>リポジトリ分析</h4>
<!-- /wp:heading -->

<!-- wp:image -->
<figure class="wp-block-image"><img src="https://takuma-h.sandboxes.jp/wp-content/uploads/2026/02/002-repository.png" alt="リポジトリ分析 - リポジトリ別テーブル、ブランチ別統計" /></figure>
<!-- /wp:image -->

<!-- wp:paragraph -->
<p>リポジトリ単位で AI 活用状況を比較するページです。セッション数、トークン数、推定コスト、メンバー数、最終活動日をテーブルで一覧でき、各リポジトリをドリルダウンするとブランチ別統計やホットスポット（変更頻度の高いファイル）を表示します。</p>
<!-- /wp:paragraph -->
[/column]
[/columns]

<!-- wp:heading {"level":4} -->
<h4>トークン分析</h4>
<!-- /wp:heading -->

<!-- wp:image -->
<figure class="wp-block-image"><img src="https://takuma-h.sandboxes.jp/wp-content/uploads/2026/02/002-token-analysis.png" alt="トークン分析 - トークン予測、モデル別コスト分布、モデルミックスシミュレーション" /></figure>
<!-- /wp:image -->

<!-- wp:paragraph -->
<p>コスト最適化のためのページです。線形回帰による将来消費量の予測チャート、モデル別コスト分布、そして[marker color="yellow"]モデルミックスシミュレーション[/marker]が特徴的です。「Opus の利用を30%減らして Sonnet に振り替えたら月額いくら削減できるか」をインタラクティブにシミュレーションできます。</p>
<!-- /wp:paragraph -->

<!-- wp:heading -->
<h2>まとめ——「なんとなく便利」から「計測可能な生産性」へ</h2>
<!-- /wp:heading -->

<!-- wp:paragraph -->
<p>AI駆動開発の生産性は、感覚ではなくデータで語る時代に入っています。本記事で紹介した計測システムでできることをまとめます。</p>
<!-- /wp:paragraph -->

<!-- wp:list -->
<ul>
<li><strong>チーム全体の AI 活用状況を可視化</strong> — 誰が、いつ、どのプロジェクトで、どのモデルを使っているか</li>
<li><strong>コスト構造を把握</strong> — モデル別・メンバー別・リポジトリ別のコスト配分と予測</li>
<li><strong>セッション品質を分析</strong> — ターン数・ツール使用・エラー率からセッションの効率を評価</li>
<li><strong>リアルタイム監視</strong> — プロンプトフィードでチームの活動状況をリアルタイム把握</li>
<li><strong>AI による分析・コーチング</strong> — ダッシュボードデータに対する自然言語クエリと改善提案</li>
</ul>
<!-- /wp:list -->

<!-- wp:paragraph -->
<p>この計測基盤があることで、[marker color="yellow"]「AI を使えているか」という曖昧な問いに対して、データに基づいた議論ができるようになります[/marker]。</p>
<!-- /wp:paragraph -->

[info]今後の展望として、CI/CD パイプラインの DORA メトリクス（デプロイ頻度・変更リードタイム等）との統合や、PR レビュー品質との相関分析を検討しています。AI の活用度と実際のデリバリー成果を結びつけることで、より説得力のある ROI の提示が可能になるはずです。[/info]

<!-- wp:paragraph -->
<p>リポジトリは GitHub で公開しています。Claude Code を使っているチームで、AI コーディングの効果測定に興味がある方はぜひ試してみてください。</p>
<!-- /wp:paragraph -->

[link_card url="https://github.com/thirai-classlab/claude-activity-tracker" title="claude-activity-tracker" description="Claude Code の利用状況を自動収集・可視化するダッシュボード。Hooks API + Next.js + MariaDB で構成。"]

<hr />

<!-- wp:heading -->
<h2>AI駆動開発のプロフェッショナルチームで働きませんか？</h2>
<!-- /wp:heading -->

<!-- wp:paragraph -->
<p>私たちは、AI駆動開発の生産性を計測し、継続的に改善しながらプロダクト開発に取り組んでいます。Claude Code を活用した最先端の開発環境で、一緒に挑戦してみませんか？</p>
<!-- /wp:paragraph -->

[link_card url="https://classlab.co.jp/contact" title="クラスラボ株式会社 - 採用情報" description="AI駆動開発に取り組むエンジニアを募集しています。お気軽にお問い合わせください。"]

<!-- wp:heading {"level":3} -->
<h3>この記事の他媒体版</h3>
<!-- /wp:heading -->

<!-- wp:list -->
<ul>
<li><a href="https://qiita.com/takuma-h/items/b528762f1a77adc3be0b">Qiita版</a>（技術詳細・コード解説重視）</li>
<li><a href="https://zenn.dev/t_hirai/articles/ai-dev-kpi-measurement">Zenn版</a>（実装ガイド・設計思想重視）</li>
</ul>
<!-- /wp:list -->
