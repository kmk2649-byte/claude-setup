# claude-setup

Claude Code 개인 설정 모음. 스킬·에이전트·플러그인·MCP를 `install.sh` 한 번으로 설치한다.

> 사용법과 프롬프트(처음 세팅·개선): [디자인](GUIDE.md) · [개발](GUIDE-dev.md) · [업무(마케팅·영업·법무·재무)](GUIDE-work.md) · [기타 도구](GUIDE-tools.md)

## 설치

- **로컬 PC:** `bash install.sh` (여러 번 실행해도 안전)
- **SSH 서버:** 아래 한 줄을 실행한다. 처음이면 받아서 설치하고, 이미 있으면 최신으로 받아 다시 설치한다. 레포를 고친 뒤에도 같은 줄을 다시 돌리면 된다.

  ```bash
  git clone https://github.com/kmk2649-byte/claude-setup ~/claude-setup 2>/dev/null || git -C ~/claude-setup pull; bash ~/claude-setup/install.sh
  ```
  미리 필요한 것: `claude` 설치·로그인, Node.js, Python 3. 브라우저는 `install.sh`가 playwright 전용 Chromium을 받아 둔다. 브라우저가 시스템 라이브러리 없음으로 안 뜨면 `sudo npx -y playwright install-deps chromium`을 한 번 실행한다.
- **클라우드 세션:** 환경의 setup script가 이 레포 `main`의 `install.sh`를 실행한다. 새 세션부터 적용된다.

> 설치 줄마다 `|| true`가 붙어 있어 실패해도 조용히 넘어간다. 새로 넣은 게 안 보이면 해당 명령을 직접 실행해 오류를 확인할 것.

## 전역 규칙 (`CLAUDE.md`)

모든 프로젝트에 적용할 규칙. `install.sh`가 `~/.claude/CLAUDE.md`의 `<!-- claude-setup:start -->`~`end` 구간에 넣는다. 다시 실행하면 그 구간만 바꾸고 구간 밖에 직접 적은 내용은 남긴다. 규칙을 고칠 때는 이 레포의 `CLAUDE.md`만 고치면 된다.

## 스킬 (`skills/`)

| 스킬 | 설명 |
|---|---|
| impeccable | UI 디자인 종합 도구. 디자인, 리디자인, 검토, 다듬기, 색·타이포·레이아웃·애니메이션, 접근성, 반응형 |
| design-taste-frontend | 템플릿 같지 않은 랜딩 페이지·포트폴리오 제작. 리디자인은 현재 상태 점검부터 |
| emil-design-eng | Emil Kowalski의 UI 철학으로 컴포넌트·애니메이션·디테일 다듬기 |
| web-design-guidelines | Vercel 웹 인터페이스 가이드라인으로 UI 코드 검토 (`파일:줄` 형식) |
| hallmark | 구조까지 다양하게 만드는 anti-AI-slop 디자인. 테마 21종, `audit`·`redesign`·`study`(URL·스크린샷에서 디자인 DNA 추출) |
| graphify | 코드·문서·이미지를 지식 그래프로 만들어 구조와 관계를 질문 |
| find-skills | "이런 걸 하는 스킬 있어?"라고 물으면 skills.sh에서 찾아 설치 횟수·출처를 확인하고 추천·설치 (vercel-labs/skills) |
| mcp-builder | Python(FastMCP)·TypeScript로 MCP 서버 만들기 안내와 평가 스크립트 (anthropics/skills) |
| arena | 답이 마음에 안 들 때 `/arena --quick 과제`. 서브에이전트들이 같은 과제를 서로 다른 전략으로 풀고, 공격·방어·심판 채점 토너먼트로 하나만 남긴다. 기본은 100명(서브에이전트 595회 호출)이라 평소엔 `--quick`(16명, 91회). 파일을 현재 폴더 `.arena/`에 쓰므로 수정 자동 승인 모드 권장. Python 3 필요 (Jakeschincariol/arena-skill, MIT) |
| court | 아이디어·계획이 괜찮은지 물을 때 `/court 아이디어`. 검사·변호 Claude가 논쟁하고, 서로 다른 관점의 배심원 12명이 따로 투표한 뒤 판사가 판결과 "무죄가 되려면 바꿀 것"을 정리한다(서브에이전트 17회, `--quick`은 6명·11회). 파일을 현재 폴더 `.court/`에 쓴다. Python 3 필요 (alexyc9381/court-skill, MIT) |
| triple-review | "코드 리뷰해"라고 하면 `code-review`(버그)·`ponytail-review`(과한 코드)·Codex review(다른 모델)를 같은 대상에 돌려 하나의 보고서로 합친다. 같은 지적은 묶어 찾은 리뷰어를 표시하고, 리뷰어끼리 엇갈리면 「의견 갈림」으로 모은다. 리뷰만 하고 고치지 않는다. Codex는 로그인이 안 돼 있으면 건너뛴다 |
| court | 아이디어·계획·주장을 재판에 올려 냉정한 반대 의견을 받는다. `/court --quick 아이디어`. 검사·변호가 서로 반박하고 배경이 다른 배심원이 각자 투표, 판사가 판결과 뒤집힐 조건을 낸다. 기본 배심원 12명(서브에이전트 17회), `--quick`은 6명. 현재 폴더 `.court/`에 기록. Python 3 필요 (alexyc9381/court-skill, MIT) |

## 에이전트 (`agents/`)

| 에이전트 | 설명 |
|---|---|
| fable-expert | 가장 상위 모델(Fable)로 도는 해결사. 두 번 고쳐도 안 잡히는 버그, 설계 결정, 보안·돈·데이터 이전 코드 검토, 큰 변경의 최종 검토에만 부른다. 비싸니 일상 작업엔 쓰지 않는다 |
| impeccable-asset-producer | (impeccable 보조) 승인된 시안에서 이미지 에셋 추출 |
| impeccable-documenter | (impeccable 보조) 완성된 결과물에서 `DESIGN.md` 작성 |
| impeccable-finish-reviewer | (impeccable 보조) 완성본이 시안과 품질 기준에 맞는지 검토 |
| impeccable-manual-edit-applier | (impeccable 보조) 브라우저에서 직접 고친 문구를 소스에 반영 |

## 플러그인

| 플러그인 | 마켓플레이스 | 설명 |
|---|---|---|
| ponytail | DietrichGebert/ponytail | 가장 단순한 해결책 모드. 과한 설계 리뷰(`ponytail-review`)와 레포 점검(`ponytail-audit`) 포함 |
| superpowers | claude-plugins-official | 기획 → 계획 → TDD → 디버깅 → 검증 → 리뷰 순으로 진행하는 개발 규칙 모음 |
| claude-code-setup | claude-plugins-official | 코드베이스를 분석해 훅·스킬·MCP·서브에이전트 추천 |
| ui-ux-pro-max | nextlevelbuilder/ui-ux-pro-max-skill | 스타일·팔레트·폰트 조합·차트·스택별 가이드를 로컬 DB로 검색해 디자인 시스템 생성 (Python 3 필요). 배너·브랜드·슬라이드·shadcn/ui 스킬 포함 |
| marketing·sales·legal | anthropics/knowledge-work-plugins | 마케팅(콘텐츠·캠페인·SEO 등 8), 영업(딜·파이프라인·콜 준비 등 38), 법무(계약 검토·NDA·컴플라이언스 등 9) 스킬. 함께 등록되는 원격 MCP(HubSpot·Salesforce·DocuSign 등)는 각각 로그인해야 쓰이고, 클라우드에서는 '인증 필요'로만 보인다 |
| codex | openai/codex-plugin-cc | Claude Code 안에서 Codex에 리뷰·작업 맡기기. `/codex:setup`(준비 상태 확인), `/codex:review`, `/codex:adversarial-review`, `/codex:rescue`, `/codex:status`·`result`·`cancel`. 아래 codex CLI와 로그인이 필요하다. 끝날 때 Codex 리뷰를 거치게 하는 훅은 기본 꺼짐(`/codex:setup --enable-review-gate`로 켬) |

## MCP

| MCP | 설명 |
|---|---|
| playwright | 브라우저 자동화 (페이지 열기, 클릭, 입력, 스크린샷). 화면 없는 Linux(SSH 서버·클라우드)는 `--headless --browser chromium`, root면 `--no-sandbox`, 클라우드는 내장 Chromium을 쓴다 |

`install.sh`에 넣지 않고 claude.ai 커넥터로 쓰는 MCP (로그인이 브라우저에서 필요해서, 한 번 연결하면 클라우드·데스크톱·웹 모두에서 쓸 수 있다):

| MCP | 설치 |
|---|---|
| QuantConnect | https://claude.ai/customize/connectors 에서 커스텀 커넥터 추가 → URL `https://www.quantconnect.com/api/v2/mcp` → Connect 후 조직 선택·Authorize → 새 세션. 조직에 유료 agent node(A1-1 이상)가 필요하다. PC·SSH 터미널에서만 쓸 때는 `claude mcp add --transport http --scope user quantconnect https://www.quantconnect.com/api/v2/mcp` 후 `/mcp`로 로그인 |

## CLI 도구

| 도구 | 설명 |
|---|---|
| codex | OpenAI Codex CLI (`@openai/codex`, npm 전역 설치, 약 430MB). 이미 있으면 건너뛴다. ChatGPT 계정으로 로그인해서 쓴다(API 키 아님). 로그인은 컨테이너에만 남아 세션마다 다시 해야 하므로, Codex를 쓸 때 로그인이 안 돼 있으면 Claude가 `codex login --device-auth`를 시작해 주소와 코드를 보여 준다. 코드만 입력하면 된다 |

## 겹치는 것

- **코드 리뷰:** 그냥 "코드 리뷰해"면 `triple-review`가 `code-review`(버그)·`ponytail-review`(과한 설계)·`/codex:review`(다른 모델의 시각)를 합쳐 돌린다. 하나만 원하면 그 이름으로 부를 것. `superpowers:requesting-code-review`는 따로.
- **여러 에이전트 대결:** `arena`는 같은 과제의 여러 답 중 가장 좋은 답을 고르고, `court`는 아이디어 하나가 좋은지 나쁜지 판정한다.
- **다른 관점 받기:** `/arena`는 같은 과제의 *답*을 여러 개 만들어 겨루게 하고, `/court`는 이미 정한 *아이디어*를 찬반으로 심사한다.
- **디자인:** impeccable이 가장 넓고, design-taste-frontend는 새 페이지 제작, web-design-guidelines는 규칙 점검, ui-ux-pro-max는 스타일·팔레트·폰트 데이터 검색, hallmark는 기존 사이트 디자인 분석(`study`)이 강점. ui-ux-pro-max의 `design`·`ui-ux-pro-max` 스킬과 hallmark, design-taste-frontend는 impeccable과 범위가 겹친다.

## 넣었다가 뺀 것

| 항목 | 뺀 이유 |
|---|---|
| agent-browser | playwright MCP와 기능이 같음 |
| example-skills (anthropics/skills) | 디자인은 impeccable·design-taste-frontend로 충분하고, 나머지는 기본 스킬과 겹침 |
| productivity (knowledge-work-plugins) | memory-management 스킬이 CLAUDE.md·memory/에 기억을 써서 second-brain 규칙과 겹침 |
| claude-mem, OmniRoute, Headroom, task-observer | 클라우드 컨테이너는 세션이 끝나면 지워지거나 로컬 프록시가 필요해 맞지 않음. 로컬 PC 전용으로는 고려 가능 |

## 설정 훅 (`settings/`)

`install.sh`가 `~/.claude/settings.json`의 `hooks`에 합친다. 다시 실행해도 하나만 남고, 다른 설정·훅은 그대로 둔다.

| 파일 | 설명 |
|---|---|
| agent-board-hooks.json | 에이전트 현황판(`Personal_Dashboard`). 세션 시작·질문·대기·완료·오류·종료 때 상태를 Supabase `report_status()`에 보낸다. 이 레포가 공개라 anon 키는 넣지 않고 환경변수 `AGENT_BOARD_ANON_KEY`로 받는다. 클라우드는 환경 설정의 환경변수에 넣는다. 변수가 없는 환경의 세션은 현황판에 안 나올 뿐 작업은 그대로 된다 |

## 한국 기준 플레이북 (`korea/`)

legal·finance 플러그인은 원래 미국 기준(미국 주법, US GAAP·SOX)이다. `install.sh`가 `korea/legal.local.md`·`korea/finance.local.md`를 `~/.claude/`에 넣고, 전역 규칙(CLAUDE.md)이 이 파일을 기본 플레이북으로 읽게 한다. 프로젝트 `.claude/`에 같은 이름의 파일이 있으면 그쪽이 우선이다.

## 추가·삭제할 때

1. 스킬은 `skills/<이름>/`, 에이전트는 `agents/`에 넣고, 플러그인·MCP는 `install.sh`에 한 줄 추가.
2. `npx skills add ...`는 `.claude/skills/`와 `skills-lock.json`을 만든다. 스킬 폴더만 `skills/`로 옮기고 나머지는 지운다.
3. 이 README의 표도 같은 PR에서 고친다.
