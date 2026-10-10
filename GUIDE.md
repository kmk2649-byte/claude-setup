# 디자인 도구 사용·프롬프트 가이드

설치된 디자인 도구를 **처음 세팅할 때**와 **이미 만든 작업물을 개선할 때**로 나눠 정리했다. 프롬프트는 복사해서 `{ }`만 바꿔 쓰면 된다.

> 다른 가이드: [개발](GUIDE-dev.md) · [업무(마케팅·영업·법무·재무)](GUIDE-work.md) · [기타 도구](GUIDE-tools.md)

> 참고한 자료: 각 스킬의 SKILL.md(impeccable v4.5, hallmark v1.1, ui-ux-pro-max v2.13), [낭만빌더 셋업 가이드](https://sdk-kim-builds.com/guides/claude-web-design-skills-setup/), [바이브 메이커 디자인 스킬 5 PDF](https://docs.vibemake.kr/downloads/claude-design-skills5.pdf), [홍익맨 노션 배포자료](https://possible-timpani-b05.notion.site/5-3c9f67ccdbf88173ac08ee5183817752)

---

## 1. 설치된 도구 한눈에

| 도구 | 잘하는 것 | 코드를 고치나 | 필요한 것 |
|---|---|---|---|
| **impeccable** | 만들기·점검·다듬기 전부. 명령 22개 | 명령마다 다름 ([5-1](#5-1-impeccable)) | 첫 실행 때 자체 프로그램 내려받기(네트워크) |
| **design-taste-frontend** | 템플릿 티 안 나는 랜딩·포트폴리오 방향 잡기와 리디자인 | 고침 | 없음. 대시보드·폼은 범위 밖 |
| **hallmark** | AI 티 검사(`audit`), 다른 사이트 디자인 분석(`study`), 리디자인 | `audit`·`study`는 안 고침 | `study`에 URL을 줄 때만 네트워크 |
| **ui-ux-pro-max** | 업종별 스타일·색·서체 검색 DB, 디자인 시스템 파일 저장 | 안 고침(파일만 만듦) | Python 3 |
| ui-ux-pro-max:**brand** | 브랜드 가이드 → 색·서체 토큰 동기화 | 토큰 파일 씀 | Node |
| ui-ux-pro-max:**design-system** | 3층 토큰(기본값→의미→컴포넌트) CSS 생성, 하드코딩 검사 | 토큰 파일 씀 | Node·Python |
| ui-ux-pro-max:**ui-styling** | shadcn/ui·Tailwind로 컴포넌트 구현 | 고침 | React 계열 프로젝트 |
| ui-ux-pro-max:**design** | 로고·명함 등 CIP·아이콘 생성 | 이미지 생성 | `GEMINI_API_KEY` (검색·브리프는 키 없이 됨) |
| ui-ux-pro-max:**banner-design** | SNS·광고·히어로 배너(HTML → PNG) | 파일 생성 | 없음 |
| ui-ux-pro-max:**slides** | HTML 발표 자료(Chart.js) | 파일 생성 | 없음 |
| **emil-design-eng** | 애니메이션 속도·곡선, 눌림 반응 같은 디테일 | 요청하면 고침 | 없음 |
| **web-design-guidelines** | Vercel 접근성·UX 규칙 점검 | 안 고침(목록만) | 네트워크(매번 규칙을 내려받음) |
| **Playwright MCP** | 만든 화면을 브라우저로 열어 스크린샷 | — | 이미 설치됨 |

**"안 고침"인 도구는 목록만 준다.** 고치려면 "이 목록대로 고쳐 줘"라고 한 번 더 말하거나, 고치는 명령(`/impeccable polish` 등)으로 이어 간다.

---

## 2. 프롬프트 잘 쓰는 8가지 규칙

| # | 규칙 | 왜 | 이렇게 쓴다 |
|---|---|---|---|
| 1 | **스킬 이름을 넣는다** | 이름이 없으면 디자인 스킬끼리 겹쳐서 매번 다른 게 불린다 | `design-taste-frontend로 …`, `/impeccable polish …` |
| 2 | **만들기 전에 확인받게 한다** | 방향이 틀리면 다 만든 뒤 고쳐도 소용없다 | "방향을 먼저 한 줄로 정하고 **나한테 확인받아**" |
| 3 | **하지 말 것을 적는다** | 기준이 없으면 익숙한 기본값으로 돌아간다 | "같은 모양 카드 반복, 장식용 그라데이션, 기본 서체, 가운데 정렬 히어로는 쓰지 마" |
| 4 | **"세련되게" 대신 숫자로** | 애매한 말은 어디로 얼마나 갈지 모른다 | "VARIANCE 7, MOTION 6, DENSITY 3" |
| 5 | **브라우저로 보고 고치게 한다** | 코드만 보고는 여백·정렬·모바일 깨짐을 못 본다 | "Playwright로 열어서 스크린샷 보고 고쳐. **2~3번 반복해**" |
| 6 | **진단과 수정을 나눈다** | 점검 도구는 목록만 주고, 한꺼번에 고치면 뭐가 나아졌는지 모른다 | "먼저 문제를 **중요도 순서로** 보여 주고, 내가 고르면 고쳐" |
| 7 | **단계마다 멈추게 한다** | 한 번에 다 바꾸면 되돌리기 어렵다 | "단계마다 세 줄로 보고하고, 「다음」이라고 하면 넘어가" |
| 8 | **결과 형식을 정한다** | 표·줄 번호로 받으면 검토가 빠르다 | "전·후·이유 표로", "파일:줄 형식으로" |

---

## 3. 처음 세팅할 때 (새 프로젝트)

### 3-1. 기준 파일은 하나만

도구마다 자기 기준 파일을 만든다. 여러 개가 생기면 서로 다른 기준을 따르게 된다.

| 파일 | 만드는 도구 | 내용 |
|---|---|---|
| `PRODUCT.md` | `/impeccable init` | 제품·사용자·목적·브랜드 사실 |
| `DESIGN.md` + `.impeccable/design.json` | `/impeccable document`, 화면을 다 만든 뒤 자동 | 색·서체·간격 토큰과 디자인 규칙 |
| `design.md` + `.hallmark/` | hallmark (「lock the system」, 여러 페이지 리디자인, study 후 「lock the DNA」) | hallmark용 디자인 규칙 |
| `design-system/<이름>/MASTER.md` | ui-ux-pro-max `--persist` | 스타일·색·서체·피할 패턴 |
| `assets/design-tokens.*`, `docs/brand-guidelines.md` | brand, design-system | 토큰 CSS·JSON, 브랜드 가이드 |

**권장:** `PRODUCT.md` + `DESIGN.md`(impeccable)를 기준으로 삼는다. 다른 도구를 쓸 때는 프롬프트에 **"DESIGN.md를 기준으로 따라"**를 붙인다. ui-ux-pro-max는 처음 색·서체를 고를 때만 쓰고, 고른 값을 DESIGN.md에 옮긴다.

> Mac·Windows는 파일 이름의 대소문자를 구분하지 않아서 `DESIGN.md`와 hallmark의 `design.md`가 같은 파일이 된다. hallmark에게 "lock the system"을 시키면 impeccable의 DESIGN.md를 덮어쓸 수 있으니 주의한다.

### 3-2. 순서

| 단계 | 할 일 | 도구 |
|---|---|---|
| 1 | 제품 정보 정리 | `/impeccable init` |
| 2 | 방향 정하기 | 랜딩·포트폴리오는 design-taste-frontend, 앱 화면은 `/impeccable shape` |
| 3 | 색·서체 고르기 | ui-ux-pro-max (업종 검색) |
| 4 | 만들기 | impeccable 또는 design-taste-frontend |
| 5 | 보고 고치기 | Playwright 스크린샷 2~3회 |
| 6 | 점검 | `/impeccable critique`, `hallmark audit` |
| 7 | 마무리와 기록 | `/impeccable polish` → DESIGN.md |

### 3-3. 단계별 프롬프트

**1) 제품 정보 정리** (프로젝트마다 한 번)
```
/impeccable init
```
사용자·목적·제약을 묻고 `PRODUCT.md`를 만든다. 이후 모든 impeccable 명령이 이 파일을 참고하니, 매번 서비스 설명을 안 해도 된다.

**2) 방향 정하기**

랜딩·포트폴리오:
```
design-taste-frontend로 {회의록 자동 정리 서비스의 랜딩 페이지} 방향을 잡아줘.
타깃은 {5~20명 스타트업 팀}. 다이얼은 VARIANCE {7}, MOTION {6}, DENSITY {4}.
코드는 아직 쓰지 말고 「무엇을, 누구에게, 어떤 느낌으로」를 한 줄로 정리해서 확인받아.
```

앱 화면·대시보드:
```
/impeccable shape {프리랜서용 할 일 관리 앱의 대시보드}
```
질문을 주고받으며 브리프만 확정하고 멈춘다. 코드는 쓰지 않는다.

**3) 색·서체 고르기**
```
ui-ux-pro-max로 「{동네 꽃집 소개 페이지}」에 맞는 디자인 시스템 후보를 뽑아 줘.
스타일·색 다섯·서체 짝·피해야 할 패턴을 표로 보여 주고,
내가 고르면 그 값을 DESIGN.md와 프로젝트 색·서체 변수에 반영해 줘.
```
ui-ux-pro-max 파일로 따로 저장하고 싶으면 "`--persist`로 저장해 줘"를 붙인다. `design-system/<이름>/MASTER.md`가 생기고, "`--page dashboard`도"라고 하면 페이지별 예외 파일도 생긴다.

**4~5) 만들고 보고 고치기**
```
위에서 정한 방향과 DESIGN.md대로 {만들 것}을 만들어줘.
같은 모양 카드 반복, 장식용 그라데이션, 기본 서체, 가운데 정렬 히어로는 쓰지 마.
다 만들면 Playwright로 데스크톱·모바일을 열어 스크린샷을 보고
어색한 곳을 고쳐서 다시 확인해. 2~3번 반복해.
```

**6) 점검** (목록만 받기)
```
/impeccable critique {메인 페이지}
```
```
hallmark audit {src/app/page.tsx}
```

**7) 마무리**
```
/impeccable polish {메인 페이지}
```
critique 결과를 할 일 목록으로 읽어 마무리한다. 화면을 다 만들면 impeccable이 DESIGN.md를 기록한다. 안 생겼으면 `/impeccable document`.

### 3-4. 한 번에 돌리기

```
{만들 것}을 처음부터 만들 거야. 단계마다 멈추고 「다음」을 기다려.

1) /impeccable init으로 PRODUCT.md를 만들어.
2) design-taste-frontend로 방향(무엇을·누구에게·어떤 느낌)을 한 줄로 정해서 확인받아.
   다이얼은 VARIANCE {7}, MOTION {6}, DENSITY {4}.
3) ui-ux-pro-max로 이 업종의 색 다섯·서체 짝 후보를 보여 주고, 내가 고른 값을 DESIGN.md에 적어.
4) 그 기준대로 만들고, Playwright로 데스크톱·모바일을 2~3번 보고 고쳐.
5) /impeccable critique와 hallmark audit 결과를 중요도 순 한 표로 합쳐 보여 줘.
6) 내가 고른 항목을 /impeccable polish로 고치고 전·후 스크린샷을 나란히 보여 줘.
```

### 3-5. 브랜드 자산이 필요할 때

| 만들 것 | 프롬프트 |
|---|---|
| 브랜드 가이드·토큰 | `ui-ux-pro-max:brand로 브랜드 가이드(docs/brand-guidelines.md)를 만들고 색·서체를 토큰 파일로 동기화해 줘` |
| 토큰 CSS | `ui-ux-pro-max:design-system으로 기본값→의미→컴포넌트 3층 토큰 CSS를 만들어 줘` |
| 로고 | `ui-ux-pro-max:design으로 {브랜드명} 로고 방향 브리프를 먼저 보여 줘` (실제 생성은 `GEMINI_API_KEY` 필요) |
| 배너 | `ui-ux-pro-max:banner-design으로 {유튜브 채널아트} 배너를 스타일 3가지로 만들어 PNG로 저장해 줘` |
| 발표 자료 | `ui-ux-pro-max:slides로 {투자 유치} 발표 자료 10장을 만들어 줘` |
| shadcn 컴포넌트 | `ui-ux-pro-max:ui-styling으로 shadcn을 세팅하고 버튼·카드·다이얼로그를 DESIGN.md 색으로 맞춰 줘` |

이미 DESIGN.md가 있으면 brand·design-system 대신 그 값을 쓰라고 말한다. 기준이 두 개로 갈라지는 것을 막는다.

---

## 4. 이미 만든 작업물을 개선할 때

### 4-1. 먼저 한 번: 현재 디자인을 기준 파일로

```
/impeccable init
/impeccable document
```
`init`은 기존 코드를 보고 제품 정보를 추론한 뒤 빈 곳만 묻는다. `document`는 지금 코드의 색·서체·간격을 뽑아 `DESIGN.md`로 만들고, 분위기 같은 말로 정할 부분만 묻는다. 이미 DESIGN.md가 있으면 갱신·덮어쓰기·병합 중 무엇을 할지 묻는다.

작은 수정 하나만 할 때는 건너뛰어도 된다.

### 4-2. 진단 (목록만 받는다)

| 보고 싶은 것 | 프롬프트 | 결과 |
|---|---|---|
| UX 전반 | `/impeccable critique {대상}` | 사용성 10항목 점수(/40)와 P0~P3 문제 목록 |
| 기술 품질 | `/impeccable audit {대상}` | 접근성·성능·반응형 문제 목록 |
| AI 티 | `hallmark audit {파일}` | 문제·위치(파일·줄)·심각도·고칠 방법 |
| 접근성·UX 규칙 | `web-design-guidelines로 {src/app/**} 검사` | 파일:줄 목록 |
| 애니메이션 | `emil-design-eng로 이 프로젝트 애니메이션 검토. 전·후·이유 표로` | 전·후·이유 표 |
| 사용 편의 기준 | `ui-ux-pro-max의 앱 UI 체크리스트로 {화면} 점검해 줘` | 우선순위별 체크 결과 |

여러 개를 한 번에:
```
{메인 페이지}를 고치기 전에 진단만 해 줘. 코드는 아직 고치지 마.
/impeccable critique, /impeccable audit, hallmark audit 결과를
중요도·위치·고칠 방법 세 칸의 한 표로 합치고, 겹치는 항목은 하나로 묶어.
```

### 4-3. 고치기 (증상별)

| 증상 | 프롬프트 |
|---|---|
| 진단 목록을 그대로 고치기 | `이 목록에서 P0·P1만 고쳐 줘` 또는 `/impeccable polish {대상}` |
| 너무 밋밋하다 | `/impeccable bolder {히어로 섹션}` |
| 너무 요란하다 | `/impeccable quieter {전체 페이지}` |
| 복잡하다 | `/impeccable distill {설정 화면}` |
| 글자가 어색하다 | `/impeccable typeset {블로그 글 페이지}` |
| 간격·배치가 어색하다 | `/impeccable layout {가격표 섹션}` |
| 색이 너무 없다 | `/impeccable colorize {대시보드}` |
| 움직임이 없다 | `/impeccable animate {카드 목록}` |
| 재미가 없다 | `/impeccable delight {빈 화면과 완료 화면}` |
| 아주 화려하게 | `/impeccable overdrive {히어로}` |
| 문구가 헷갈린다 | `/impeccable clarify {결제 화면 에러 메시지}` |
| 모바일에서 깨진다 | `/impeccable adapt {대시보드}` |
| 실제 데이터에 약하다 | `/impeccable harden {주문 목록}` — 빈 목록, 1000개, 긴 이름, 네트워크 오류, 긴 번역문까지 |
| 처음 쓰는 사람이 헤맨다 | `/impeccable onboard {가입 후 첫 화면}` |
| 느리다 | `/impeccable optimize {메인 페이지}` |
| 같은 스타일이 여기저기 복사돼 있다 | `/impeccable extract {src/components}` — 공통 토큰·컴포넌트로 묶기 |
| 애니메이션이 굼뜨다 | `emil-design-eng 기준으로 transition: all과 ease-in을 고치고 버튼에 눌림 반응을 넣어 줘` |
| AI가 만든 것 같다 | [4-5](#4-5-ai-티-집중-제거) |

**뭘 써야 할지 모를 때:** `/impeccable`만 치면 프로젝트를 보고 2~3개를 추천한다. 자동으로 실행하지는 않는다.

### 4-4. 리디자인

| 원하는 정도 | 프롬프트 | 바뀌는 것 |
|---|---|---|
| 구조는 두고 세련되게 | `design-taste-frontend로 이 페이지 리디자인. 지금 구조와 문구는 유지하고 세련되게.` | MOTION만 +1. 메뉴·주소·구성 유지 |
| 많이 바꾸기 | `design-taste-frontend로 이 페이지 리디자인. 과감하게 갈아엎어도 돼.` | VARIANCE·MOTION +2. 내용과 메뉴 구성은 유지 |
| 완전히 새로 | `design-taste-frontend로 이 내용만 가지고 처음부터 새로 만들어줘.` | 전부 |
| 겉모양만 다른 스타일로 | `hallmark redesign {src/app} --mood {editorial}` | 화면 모양만 교체. 지울 파일은 먼저 확인받음 |
| 마음에 드는 사이트처럼 | `hallmark study {https://linear.app}` → `이 DNA로 내 랜딩을 리디자인해 줘. DESIGN.md를 기준으로 따라.` | 서체·색·구성을 분석해 적용(그대로 복제하지 않음) |

### 4-5. AI 티 집중 제거

```
hallmark audit {src/app/page.tsx} 결과와, 아래 항목을 함께 확인해 줘.
반복적인 카드 레이아웃, 과도한 둥근 상자, 불필요한 그라데이션, 평범한 가운데 정렬 히어로,
획일적인 간격, 흔한 서체, 의미 없는 애니메이션, 근거 없는 숫자(「+47% 전환」 같은).

먼저 목록을 보여 주고, 내가 확인하면
전부 지우지 말고 이 제품의 목적과 DESIGN.md에 맞는 선택으로 바꿔.
근거 없는 숫자는 실제 값이나 「확인 필요」로 바꿔.
끝나면 Playwright로 열어서 다시 평가해.
```

### 4-6. 브라우저에서 직접 골라 고치기 (impeccable live)

개발 서버(Vite·Next 등)나 HTML 파일이 로컬에서 열려 있을 때만 된다. 배포된 사이트에는 안 된다.

```
/impeccable live
```
브라우저에서 요소를 고르고 bolder 같은 동작을 누르면 시안 여러 개가 바로 바뀌어 보이고, 고른 것만 코드에 반영된다. 처음 한 번은 설정 파일을 만들고, 보안 설정(CSP) 수정이 필요하면 동의를 구한다.

요소를 직접 고르지 않고 말로 시킬 때:
```
/impeccable generate 3 bold variants of the pricing cards
```

### 4-7. 단계별로 한 번에

```
지금 이 프로젝트의 {메인 화면}을 단계별로 손봐 줘.
단계마다 무엇을 바꿨는지 세 줄로 보고하고, 내가 「다음」이라고 하면 넘어가.

1) /impeccable init과 /impeccable document로 PRODUCT.md·DESIGN.md를 만들어(있으면 건너뛰어).
2) /impeccable critique와 hallmark audit 결과를 중요도 순 한 표로 합쳐 보여 줘. 아직 고치지 마.
3) 내가 고른 항목을 고쳐. 근거 없는 숫자는 「확인 필요」로 바꿔.
4) emil-design-eng 기준으로 transition: all과 ease-in을 고치고 버튼에 눌림 반응을 넣어. 전·후·이유 표로.
5) web-design-guidelines로 접근성 위반을 파일:줄로 받아 고쳐.
6) /impeccable polish로 마무리하고, Playwright로 고치기 전·후 화면을 나란히 보여 줘.
```
마음에 안 드는 단계는 "4번은 건너뛰어"라고 하면 된다.

---

## 5. 도구별 참고

### 5-1. impeccable

`/impeccable <명령> [대상]` 형식. 인자 없이 치면 추천 메뉴.

| 묶음 | 명령 | 코드 수정 |
|---|---|---|
| 준비 | `init`(=`teach`, PRODUCT.md), `document`(DESIGN.md) | 아니요(기준 파일만) |
| 만들기 | 자연어 요청(예: `/impeccable 회원가입 화면 만들어줘`), `shape`(브리프만), `craft`(옛 이름) | shape만 아니요 |
| 진단 | `critique`(UX 점수), `audit`(기술 점검) | 아니요 |
| 다듬기 | `polish`, `bolder`, `quieter`, `distill`, `harden`, `onboard` | 예 |
| 강화 | `animate`, `colorize`, `typeset`, `layout`, `delight`, `overdrive` | 예 |
| 고치기 | `clarify`, `adapt`, `optimize`, `extract` | 예 |
| 시안 | `live`(브라우저에서 고르기), `generate [개수] [동작] [요소]` | 고른 것만 |
| 관리 | `doctor`(기준 파일 점검·복구), `hooks on/off/status`(편집 후 자동 디자인 검사), `pin <명령>`(`/polish`처럼 짧은 명령 만들기) | 아니요 |

화면을 새로 만들 때는 점검 에이전트(impeccable-finish-reviewer)와 기록 에이전트(impeccable-documenter)가 자동으로 붙는다. 따로 부를 필요 없다.

### 5-2. design-taste-frontend

명령어 없이 대화로 쓴다. 시작할 때 "이렇게 이해했다"는 한 줄을 먼저 보여 주고, 요청이 애매하면 질문을 하나만 한다.

| 다이얼 | 낮게 | 높게 |
|---|---|---|
| **VARIANCE** (레이아웃) | 정돈된 그리드 | 비대칭, 겹침, 과감한 크기 차이 |
| **MOTION** (움직임) | hover 정도 | spring, 스크롤 연동 |
| **DENSITY** (정보량) | 여유롭게 | 대시보드처럼 빽빽 |

기본값은 8/6/4. 숫자를 안 주면 "미니멀", "프리미엄", "실험적" 같은 말을 보고 정한다.

| 만들 것 | VARIANCE | MOTION | DENSITY |
|---|---|---|---|
| SaaS 랜딩 | 7 | 6 | 4 |
| 디자이너 포트폴리오 | 8 | 7 | 3 |
| 에이전시·크리에이티브 | 9 | 8 | 3 |
| 공공기관·신뢰 중요 | 3 | 2 | 5 |

이미지를 주면 말보다 정확하다:
```
[시안·무드보드 이미지 첨부]
design-taste-frontend로 이 느낌의 포트폴리오를 만들어줘. 그대로 베끼지는 마.
```

### 5-3. hallmark

| 명령 | 하는 일 |
|---|---|
| (명령 없이) | 새로 만들기. 청중·용도·톤 3가지를 묻는다. "알아서 해"라고 하면 추론 |
| `hallmark audit <대상>` | AI 티 목록. 고치지 않는다. 끝에 `N critical · M major · K minor` |
| `hallmark redesign <대상> [--mood <이름>]` | 기존 구조 안에서 겉모양만 교체 |
| `hallmark study <URL 또는 스크린샷>` | 서체·색·구성 추출. 끝나면 「만들기 / DNA 고정(design.md) / 끝」 중 묻는다 |

테마 21종 중에서 고르고, 브랜드 색을 주거나 "custom theme"라고 하면 직접 만든다. 템플릿 판매 사이트(themeforest·dribbble 등)는 study를 거부한다.

### 5-4. ui-ux-pro-max

업종·스타일 검색 DB(스타일 50, 팔레트 192, 서체 짝 74, UX 규칙 119). 자연어로 부르면 내부 검색 스크립트를 알아서 돌린다.

| 하고 싶은 일 | 프롬프트 |
|---|---|
| 디자인 시스템 추천 | `ui-ux-pro-max로 {핀테크 앱} 디자인 시스템 추천해 줘` |
| 파일로 저장 | `… --persist로 {프로젝트명} 저장해 줘` → `design-system/<이름>/MASTER.md` |
| 페이지별 예외 | `… dashboard 페이지용 예외도 만들어 줘` → `pages/dashboard.md`(MASTER보다 우선) |
| 특정 주제 검색 | `ui-ux-pro-max로 모달 키보드 접근성 규칙 찾아 줘` |
| 스택별 가이드 | `ui-ux-pro-max로 Next.js에 맞는 구현 규칙 보여 줘` |

이미 있는 파일을 덮어쓰려면 직접 허락해야 한다(`--force`).

### 5-5. emil-design-eng

질문 없이 이름만 부르면 인사 한 줄만 한다. 무엇을 볼지 같이 말한다. 검토 결과는 항상 `전 | 후 | 이유` 표로 나온다.

| 대상 | 속도 |
|---|---|
| 버튼 눌림 | 100~160ms |
| 툴팁·작은 팝오버 | 125~200ms |
| 드롭다운·셀렉트 | 150~250ms |
| 모달·서랍 | 200~500ms |

`transition: all` 대신 바뀌는 속성만, `ease-in` 금지, 버튼 `:active`에 `scale(0.97)`, 등장은 `scale(0)`이 아니라 `0.95`부터, 키보드 동작에는 애니메이션을 넣지 않는다.

### 5-6. web-design-guidelines

```
web-design-guidelines로 {src/components/**} 검사해 줘.
```
검사할 때마다 Vercel 규칙을 인터넷에서 새로 받는다. 파일을 안 알려주면 되묻는다. 목록만 주니, 고치려면 "이 목록대로 접근성 문제부터 고쳐 줘"를 이어서 말한다.

---

## 6. 막힐 때

| 증상 | 할 일 |
|---|---|
| 스킬을 안 쓰는 것 같다 | 프롬프트에 스킬 이름을 넣는다. 그래도 안 되면 새 세션을 연다 |
| 결과가 여전히 뻔하다 | 규칙 3(하지 말 것)과 4(다이얼 숫자)를 추가하고, 마음에 드는 이미지를 붙인다 |
| `audit`·`critique`가 코드를 안 고친다 | 원래 그렇다. "이 목록대로 고쳐 줘" 또는 `/impeccable polish` |
| 도구마다 색·서체가 다르게 나온다 | [3-1](#3-1-기준-파일은-하나만). "DESIGN.md를 기준으로 따라"를 붙인다 |
| impeccable이 처음에 멈춘다 | 첫 실행 때 자체 프로그램을 내려받는다. 네트워크를 확인한다 |
| web-design-guidelines가 실패한다 | 규칙을 인터넷에서 받아야 한다. 네트워크가 막힌 환경이면 `/impeccable audit`으로 대신한다 |
| ui-ux-pro-max가 Python이 없다며 멈춘다 | Python 3를 설치한다 |
| 로고·아이콘 생성이 안 된다 | `GEMINI_API_KEY`가 필요하다. 키 없이 브리프까지만 받을 수 있다 |
| `/impeccable live`가 안 붙는다 | 로컬 개발 서버가 떠 있어야 한다. 배포 사이트와 앱(iOS·Android)에는 안 된다 |
| 화면 확인을 안 하고 끝낸다 | "Playwright로 열어서 스크린샷 보고 고쳐"를 프롬프트 끝에 붙인다 |
| 한 번에 너무 많이 바뀐다 | "단계마다 멈추고 「다음」을 기다려"를 붙인다 |

> **핵심 한 줄:** 기준 파일 하나(DESIGN.md) → 만들기 → 보기(Playwright) → 진단(목록) → 고르고 고치기 → 반복.
