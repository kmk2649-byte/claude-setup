# claude-setup

Claude Code 개인 설정 모음. 스킬·에이전트·플러그인·MCP를 `install.sh` 한 번으로 설치한다.

## 설치

- **로컬 PC:** `bash install.sh` (여러 번 실행해도 안전)
- **클라우드 세션:** 환경의 setup script가 이 레포 `main`의 `install.sh`를 실행한다. 새 세션부터 적용된다.

> 설치 줄마다 `|| true`가 붙어 있어 실패해도 조용히 넘어간다. 새로 넣은 게 안 보이면 해당 명령을 직접 실행해 오류를 확인할 것.

## 스킬 (`skills/`)

| 스킬 | 설명 |
|---|---|
| impeccable | UI 디자인 종합 도구. 디자인, 리디자인, 검토, 다듬기, 색·타이포·레이아웃·애니메이션, 접근성, 반응형 |
| design-taste-frontend | 템플릿 같지 않은 랜딩 페이지·포트폴리오 제작. 리디자인은 현재 상태 점검부터 |
| emil-design-eng | Emil Kowalski의 UI 철학으로 컴포넌트·애니메이션·디테일 다듬기 |
| web-design-guidelines | Vercel 웹 인터페이스 가이드라인으로 UI 코드 검토 (`파일:줄` 형식) |
| graphify | 코드·문서·이미지를 지식 그래프로 만들어 구조와 관계를 질문 |

## 에이전트 (`agents/`, impeccable 보조)

| 에이전트 | 설명 |
|---|---|
| impeccable-asset-producer | 승인된 시안에서 이미지 에셋 추출 |
| impeccable-documenter | 완성된 결과물에서 `DESIGN.md` 작성 |
| impeccable-finish-reviewer | 완성본이 시안과 품질 기준에 맞는지 검토 |
| impeccable-manual-edit-applier | 브라우저에서 직접 고친 문구를 소스에 반영 |

## 플러그인

| 플러그인 | 마켓플레이스 | 설명 |
|---|---|---|
| ponytail | DietrichGebert/ponytail | 가장 단순한 해결책 모드. 과한 설계 리뷰(`ponytail-review`)와 레포 점검(`ponytail-audit`) 포함 |
| superpowers | claude-plugins-official | 기획 → 계획 → TDD → 디버깅 → 검증 → 리뷰 순으로 진행하는 개발 규칙 모음 |
| claude-code-setup | claude-plugins-official | 코드베이스를 분석해 훅·스킬·MCP·서브에이전트 추천 |

## MCP

| MCP | 설명 |
|---|---|
| playwright | 브라우저 자동화 (페이지 열기, 클릭, 입력, 스크린샷). 클라우드에서는 내장 Chromium을 `--headless --no-sandbox`로 사용 |

## 겹치는 것

- **코드 리뷰:** `code-review`(기본, 버그), `ponytail-review`(과한 설계), `superpowers:requesting-code-review`. 원하는 쪽을 이름으로 부를 것.
- **디자인:** impeccable이 가장 넓고, design-taste-frontend는 새 페이지 제작, web-design-guidelines는 규칙 점검.

## 넣었다가 뺀 것

| 항목 | 뺀 이유 |
|---|---|
| agent-browser | playwright MCP와 기능이 같음 |
| example-skills (anthropics/skills) | 디자인은 impeccable·design-taste-frontend로 충분하고, 나머지는 기본 스킬과 겹침 |
| claude-mem, OmniRoute, Headroom, task-observer | 클라우드 컨테이너는 세션이 끝나면 지워지거나 로컬 프록시가 필요해 맞지 않음. 로컬 PC 전용으로는 고려 가능 |

## 추가·삭제할 때

1. 스킬은 `skills/<이름>/`, 에이전트는 `agents/`에 넣고, 플러그인·MCP는 `install.sh`에 한 줄 추가.
2. `npx skills add ...`는 `.claude/skills/`와 `skills-lock.json`을 만든다. 스킬 폴더만 `skills/`로 옮기고 나머지는 지운다.
3. 이 README의 표도 같은 PR에서 고친다.
