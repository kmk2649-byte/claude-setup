# 업무 플러그인 사용·프롬프트 가이드

마케팅·영업·법무·재무 플러그인을 **처음 만들 때**와 **이미 있는 자료를 개선할 때**로 나눠 정리했다.

> 다른 가이드: [디자인](GUIDE.md) · [개발](GUIDE-dev.md) · [기타 도구](GUIDE-tools.md)

---

## 1. 먼저 알아 둘 것

| 플러그인 | 스킬 수 | 출처 | 설치 |
|---|---|---|---|
| marketing | 8 | anthropics/knowledge-work-plugins | `install.sh` |
| sales | 36 | 〃 | `install.sh` |
| legal | 9 | 〃 | `install.sh` |
| finance | 8 | 〃 | claude.ai 계정에서 자동 동기화 |

**부르는 법:** `플러그인:스킬` (예: `sales:call-prep`). 자연어로 요청해도 맞는 스킬이 불린다.

**연결 도구:** 스킬 설명의 `~~CRM`, `~~chat` 같은 표시는 "그 종류의 도구 아무거나"라는 뜻이다.
- **바로 쓰이는 것:** claude.ai 커넥터(Gmail·캘린더·Drive·Notion·Slack·Linear)
- **안 되는 것:** 플러그인이 함께 등록하는 HubSpot·Salesforce·DocuSign 등은 로그인이 안 돼 있어 쓸 수 없다. 대신 **파일을 올리거나 내용을 붙여 넣으면** 대부분 동작한다.

**한국 기준이 기본:** 플러그인 원문은 미국 기준(법무는 미국 주법, 재무는 US GAAP·SOX·달러)이지만, 이 설정은 법무·재무를 **한국 기준으로 바꿔 쓴다.** 전역 규칙과 `install.sh`가 설치하는 한국 기준 플레이북(`~/.claude/legal.local.md`, `~/.claude/finance.local.md`) 덕분이다. 자세한 건 [6장](#6-한국-기준으로-쓰기).

---

## 2. 마케팅 (marketing)

### 처음 만들 때

| 만들 것 | 프롬프트 |
|---|---|
| 캠페인 계획 | `marketing:campaign-plan {신제품 출시}. 목표 {가입 1천}, 타깃 {20대 직장인}, 기간 {6주}, 예산 {500만 원}` |
| 콘텐츠 초안 | `marketing:draft-content {블로그 글}: {회의록 자동화로 줄이는 시간}. 톤은 친근하게, 1500자` |
| 이메일 시퀀스 | `marketing:email-sequence {가입 후 온보딩} 5통. 발송 간격과 A/B 제목도` |

`content-creation`은 `draft-content`와 거의 같다. `draft-content`만 쓰면 된다.

### 이미 있는 자료 개선

| 할 일 | 프롬프트 |
|---|---|
| 브랜드 톤 점검 | `marketing:brand-review [글 붙여넣기]. 심각도별 지적과 고친 문장을 전·후로` |
| 경쟁사 비교 | `marketing:competitive-brief {경쟁사 A, B}와 우리 포지셔닝 비교` |
| 성과 보고 | `marketing:performance-report {9월 캠페인} [지표 표 붙여넣기]. 잘된 점·미달·다음 액션` |
| SEO 점검 | `marketing:seo-audit {https://우리사이트}` |

**브랜드 톤 고정:** 브랜드 보이스 문서를 한 번 붙여 넣고 "앞으로 이 톤을 기준으로 써 줘"라고 한다. 계속 쓸 거면 프로젝트 CLAUDE.md에 넣어 둔다. 한국어 톤은 직접 적어야 한다.

---

## 3. 영업 (sales)

### 처음 한 번

```
sales:setup
```
연결된 도구를 확인하고, 보낸 메일로 내 글투를 익히고, 시작용 스킬 3개를 추천한다. 설정 파일은 필요 없다.

### 처음 만들 때

| 만들 것 | 프롬프트 |
|---|---|
| 잠재 고객 조사 | `sales:account-research {회사명}. 우리 서비스와 맞는지도 판단해 줘` |
| 첫 연락 메일 | `sales:draft-outreach {회사명 담당자}. Gmail 임시보관함에 넣어 줘` |
| 미팅 준비 | `sales:call-prep 내일 {회사명} 미팅` |
| 제안 자료 | `sales:create-an-asset {회사명}용 한 장짜리 소개서` |
| 고객 계획 | `sales:account-plan {회사명}` / `sales:close-plan {딜명}` |
| 이해관계자 지도 | `sales:stakeholder-map {회사명}` |
| 반론 대응 | `sales:handle-objection "가격이 비싸다"` |

### 매일·매주 (Gmail·캘린더로 동작)

| 언제 | 프롬프트 |
|---|---|
| 아침 | `sales:daily-briefing` |
| 메일 정리 | `sales:inbox-sweep` (고객 메일 분류와 답장 초안) |
| 미팅 잡기 | `sales:schedule-meeting {회사명}과 다음 주 30분` |
| 퇴근 전 | `sales:end-of-day` |
| 주말 | `sales:weekly-wrap` |

### 이미 있는 자료 개선

| 할 일 | 프롬프트 |
|---|---|
| 통화 정리 | `sales:call-summary [메모·녹취 붙여넣기]` — 고객 후속 메일, 내부 요약, CRM 갱신안 |
| 고객 목소리 모으기 | `sales:customer-voice [통화 기록들]` |
| 딜 점검 | `sales:deal-review {딜명}` |
| 파이프라인·전망 | `sales:pipeline-review`, `sales:forecast {4분기}` |
| CRM 정리 | `sales:crm-hygiene-check` (목록만, 고치지 않음) |
| 수주·실주 분석 | `sales:win-loss-review` |
| 기존 고객 관리 | `sales:customer-health`, `sales:renewal-radar`, `sales:expansion-whitespace` |

딜·파이프라인 스킬은 CRM 데이터가 핵심이다. CRM이 연결돼 있지 않으면 엑셀·CSV로 내보내 올린다.

---

## 4. 법무 (legal)

### (선택) 우리 회사 기준으로 바꾸기

`review-contract`·`triage-nda`는 플레이북과 비교해서 검토한다. 기본은 한국 법 일반 기준(`~/.claude/legal.local.md`)이다. 회사 방침이 따로 있으면 프로젝트에 `.claude/legal.local.md`를 만들어 덮어쓴다.

```
~/.claude/legal.local.md를 바탕으로 우리 회사용 .claude/legal.local.md를 만들어 줘.
책임 한도, 면책, 지식재산, 개인정보(개인정보보호법), 계약 기간·해지, NDA 기본값을
항목마다 「우리 기본 입장 / 받아들일 수 있는 범위 / 절대 안 되는 것」으로 물어보면서 채워 줘.
```

### 처음 만들 때

| 할 일 | 프롬프트 |
|---|---|
| 오늘 법무 일 요약 | `legal:brief daily` (Gmail·캘린더) |
| 특정 주제 정리 | `legal:brief topic {하도급 대금 지급 기한}` |
| 미팅 준비 | `legal:meeting-briefing {내일 계약 협상}` |
| 정형 답변 | `legal:legal-response {개인정보 열람 요청}` |
| 새 사업 규제 확인 | `legal:compliance-check {고객 데이터로 맞춤 광고}` |

### 이미 있는 문서 개선

| 할 일 | 프롬프트 |
|---|---|
| 계약 검토 | `legal:review-contract [계약서 파일]. 우리는 {공급자}, {금요일} 서명 목표, {책임 한도}를 중점으로` |
| NDA 분류 | `legal:triage-nda [NDA 파일]` — 바로 서명 / 확인 필요 / 수정 필요 |
| 리스크 평가 | `legal:legal-risk-assessment {이번 분쟁 건}` |
| 거래처 계약 현황 | `legal:vendor-check {업체명}` |

`signature-request`는 DocuSign 연결이 필요해서 지금은 서명 전 체크리스트까지만 쓸 수 있다.

**법률 자문이 아니다.** 결과는 검토 초안으로 쓰고, 중요한 건은 변호사 확인을 받는다.

---

## 5. 재무 (finance)

### 처음 만들 때

| 만들 것 | 프롬프트 |
|---|---|
| 분개 | `finance:journal-entry {선급비용 상각} {2026년 9월} [근거 자료]` |
| 재무제표 | `finance:financial-statements {월간} {2026년 9월} [시산표 파일]. 전월·예산 대비 포함` |
| 결산 일정 | `finance:close-management {9월 결산} 일자별 작업 순서와 담당` |

### 이미 있는 숫자 검증·개선

| 할 일 | 프롬프트 |
|---|---|
| 대사 | `finance:reconciliation {보통예금} {9월} [은행 거래내역, 원장 파일]` |
| 차이 분석 | `finance:variance-analysis {판관비} {9월} vs {예산}. 원인별로 나누고 설명 문장까지` |
| 통제 테스트 | `finance:sox-testing {매출 인식} {3분기}` — 표본 선정과 워크페이퍼 |
| 감사 대응 | `finance:audit-support {통제 미비 분류 기준}` |

데이터는 엑셀·CSV를 올리거나 붙여 넣는다(ERP·BI 연결 없음).

---

## 6. 한국 기준으로 쓰기

| 분야 | 기본값 | 바꾸는 법 |
|---|---|---|
| 법무 | 미국(델라웨어·뉴욕·캘리포니아) | **자동.** `~/.claude/legal.local.md`(대한민국 법, 개인정보 보호법, 하도급법, 약관규제법 등). 회사 방침은 프로젝트 `.claude/legal.local.md`로 덮어쓴다 |
| 재무 | US GAAP, ASC 조항, SOX, 달러 | **자동.** `~/.claude/finance.local.md`(K-IFRS·일반기업회계기준, US GAAP→K-IFRS 대응표, 내부회계관리제도, 원화). 회사 방침은 프로젝트 `.claude/finance.local.md`로 덮어쓴다 |

미국 기준이 필요하면 "US GAAP 기준으로", "미국 뉴욕주 법 기준으로"처럼 직접 말한다. 플레이북 원본은 claude-setup 레포 `korea/` 폴더에 있다.
| 마케팅 | 영어 예시, 미국 광고 관행 | 브랜드 톤을 한국어로 적어 두고, 표시광고법 등은 직접 확인 |
| 영업 | 미국식 CRM 단계 | 우리 회사 영업 단계를 한 번 알려 준다 |

**재무는 연결된 한국 자료 도구와 같이 쓴다:**
```
finance:financial-statements로 [시산표 파일]을 재무제표로 만들어 줘.
계정 분류와 표시는 MyKIFRS로 K-IFRS 기준서 문단을 확인해서 맞추고, 근거 문단을 같이 적어.
```
```
finance:variance-analysis로 우리 {매출총이익률} 변화를 분석하고,
MyDART에서 {동종사 2곳}의 최근 공시 수치와 비교해 줘. 출처와 기준일을 같이 적어.
```
MyKIFRS(K-IFRS 기준서·질의회신), MyDART(공시·감사보고서), MyFSS(금감원 자료)는 claude.ai 커넥터로 이미 연결돼 있다.

**전문가 검토:** 재무·세무·감사 결과는 초안이다. 보고·제출 전에 담당자 검토를 받는다.

---

## 7. 막힐 때

| 증상 | 할 일 |
|---|---|
| "CRM이 연결돼 있지 않다"며 멈춘다 | 엑셀·CSV를 올리거나 내용을 붙여 넣는다 |
| "인증 필요" 목록이 길다 | 플러그인이 등록한 HubSpot·DocuSign 등 때문이다. 스킬 사용에는 지장 없다 |
| 계약 검토가 미국 기준으로 나온다 | `~/.claude/legal.local.md`가 있는지 확인한다(없으면 `install.sh` 다시 실행). "대한민국 법 기준으로"를 붙인다 |
| 재무제표가 US GAAP 형식이다 | `~/.claude/finance.local.md`를 확인하고, "K-IFRS 기준, 원화로"를 붙인다 |
| 스킬이 안 불린다 | `플러그인:스킬` 이름을 정확히 넣는다. 새로 설치한 직후면 새 세션을 연다 |
