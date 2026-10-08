# 디자인 스킬 프롬프트 가이드

주로 쓰는 스킬은 **impeccable**과 **design-taste-frontend** 두 개다. 나머지는 필요할 때만 이름을 불러서 쓴다.

> 스킬 이름을 프롬프트에 넣으면 그 스킬이 확실히 쓰인다. 이름을 빼면 Claude가 고르는데, 디자인 스킬끼리 겹쳐서 매번 다를 수 있다.

---

## 1. 상황별로 고르기

| 하고 싶은 일 | 쓸 스킬 | 프롬프트 시작 |
|---|---|---|
| 새 랜딩·포트폴리오 페이지 만들기 | design-taste-frontend | `design-taste-frontend로 ...` |
| 새 앱 화면·대시보드 만들기 | impeccable | `/impeccable ...` |
| 만들기 전에 기획부터 | impeccable | `/impeccable shape ...` |
| 이미 있는 화면 고치기·다듬기 | impeccable | `/impeccable polish ...` 등 |
| 디자인 리뷰 받기 | impeccable | `/impeccable critique ...` |
| 접근성·반응형·성능 점검 | impeccable | `/impeccable audit ...` |
| 마음에 드는 사이트 디자인 따라하기 | hallmark | `hallmark study <URL>` |
| 팔레트·폰트 조합만 고르기 | ui-ux-pro-max | `ui-ux-pro-max로 ...` |
| 웹 가이드라인 규칙 점검 | web-design-guidelines | `web-design-guidelines로 ...` |
| 애니메이션·인터랙션 디테일 | emil-design-eng | `emil-design-eng 기준으로 ...` |

---

## 2. impeccable — 화면 만들기·고치기·점검

### 처음 한 번: 프로젝트 정보 등록

```
/impeccable init
```
질문에 답하면 `PRODUCT.md`(누가 쓰는지, 브랜드, 원칙)를 만든다. 이후 모든 명령이 이 파일을 참고하니 프로젝트마다 한 번 해 두면 결과가 훨씬 좋아진다.

이미 디자인이 있는 프로젝트라면 이것도:
```
/impeccable document
```
현재 코드에서 색·폰트·간격을 뽑아 `DESIGN.md`로 정리한다.

### 명령어 한눈에

| 단계 | 명령 | 언제 |
|---|---|---|
| **기획** | `shape` | 코드 쓰기 전에 질문을 주고받으며 디자인 방향을 정할 때 |
| **평가** | `critique` | UX 관점 리뷰 (점수 포함) |
| | `audit` | 접근성·성능·반응형 기술 점검 (P0~P3 등급) |
| **다듬기** | `polish` | 출시 전 마지막 정리 (정렬, 간격, 일관성) |
| | `bolder` | 너무 밋밋할 때 |
| | `quieter` | 너무 요란할 때 |
| | `distill` | 복잡한 걸 덜어낼 때 |
| | `harden` | 에러 처리, 긴 텍스트, 빈 데이터 같은 실전 대비 |
| | `onboard` | 첫 사용 화면, 빈 상태 |
| **강화** | `typeset` | 폰트·글자 위계 |
| | `layout` | 간격·리듬·배치 |
| | `colorize` | 색이 너무 없을 때 |
| | `animate` | 의미 있는 애니메이션 추가 |
| | `delight` | 기억에 남는 작은 디테일 |
| | `overdrive` | 셰이더, 물리 효과 같은 과감한 기술 |
| **고치기** | `clarify` | 문구, 라벨, 에러 메시지 |
| | `adapt` | 모바일·태블릿 대응 |
| | `optimize` | 느린 화면 |

### 바로 쓰는 프롬프트

```
/impeccable shape 할 일 관리 앱의 대시보드. 혼자 일하는 프리랜서용
```
```
/impeccable 회원가입 화면 만들어줘. 이메일과 구글 로그인
```
```
/impeccable critique src/app/page.tsx
```
```
/impeccable audit 전체 사이트
```
```
/impeccable polish src/components/PricingTable.tsx
```
```
/impeccable bolder 히어로 섹션이 너무 평범해
```
```
/impeccable harden 주문 목록 화면. 주문이 0개일 때, 1000개일 때, 상품명이 아주 길 때
```
```
/impeccable adapt 대시보드를 모바일에서도 쓸 수 있게
```

**인자 없이 `/impeccable`만 치면** 지금 프로젝트에 맞는 명령 메뉴를 보여준다. 뭘 써야 할지 모를 때 좋다.

### 추천 순서

- **새로 만들 때:** `init` → `shape` → 만들기 → `critique` → `polish`
- **있는 걸 고칠 때:** `critique`로 문제 확인 → 해당 명령(`layout`, `typeset` 등) → `audit` → `polish`

---

## 3. design-taste-frontend — 템플릿 같지 않은 랜딩·포트폴리오

어떤 느낌인지만 말하면 알아서 방향을 잡는다. 시작하기 전에 한 줄로 "디자인 해석"을 먼저 보여준다.

### 다이얼 3개

결과의 성격을 정하는 숫자. 직접 말하지 않으면 요청 내용을 보고 정한다.

| 다이얼 | 1 | 10 | 기본 |
|---|---|---|---|
| **VARIANCE** (구성 변화) | 완전 대칭 | 예술적 파격 | 8 |
| **MOTION** (움직임) | 정적 | 영화 같은 연출 | 6 |
| **DENSITY** (정보 밀도) | 갤러리처럼 여유 | 조종석처럼 빽빽 | 4 |

**느낌별 자동 설정:**
| 이렇게 말하면 | VARIANCE / MOTION / DENSITY |
|---|---|
| "미니멀, 깔끔, Linear 스타일" | 5–6 / 3–4 / 2–3 |
| "프리미엄, 애플 같은, 럭셔리" | 7–8 / 5–7 / 3–4 |
| "재밌게, 실험적, 에이전시, Awwwards" | 9–10 / 8–10 / 3–4 |
| "신뢰감, 공공기관, 접근성 중요" | 3–4 / 2–3 / 4–5 |

### 바로 쓰는 프롬프트

```
design-taste-frontend로 SaaS 랜딩 페이지 만들어줘. 회의록 자동 정리 서비스, 타깃은 스타트업 팀
```
```
design-taste-frontend로 프로덕트 디자이너 포트폴리오. 프리미엄하고 차분하게
```
```
design-taste-frontend로 만들어줘. VARIANCE 9, MOTION 8, DENSITY 3. 크리에이티브 에이전시 소개 페이지
```
```
design-taste-frontend로 이 페이지 리디자인. 지금 구조는 유지하고 세련되게
```
```
design-taste-frontend로 이 페이지 리디자인. 완전히 새롭게 갈아엎어도 돼
```

**팁:** "구조 유지"라고 하면 기존 틀을 지키며 다듬고, "갈아엎어"라고 하면 VARIANCE·MOTION을 +2 올려 크게 바꾼다.

---

## 4. 보조 스킬

### hallmark — 남의 사이트에서 디자인 DNA 뽑기
```
hallmark study https://linear.app
```
```
hallmark study [스크린샷 첨부] 이 느낌으로 내 서비스 소개 페이지 만들어줘
```
```
hallmark study https://stripe.com 분석하고 design.md로 저장해줘
```
레이아웃 구조, 폰트, 색을 분석해 준다. 픽셀을 그대로 베끼지는 않는다.

### ui-ux-pro-max — 팔레트·폰트 데이터 검색
```
ui-ux-pro-max로 핀테크 앱에 어울리는 팔레트와 폰트 조합 3개 추천해줘
```
```
ui-ux-pro-max로 웰니스 예약 서비스 디자인 시스템 뽑아줘
```

### web-design-guidelines — 규칙 점검
```
web-design-guidelines로 src/components 점검해줘
```
문제를 `파일:줄` 형식으로 짧게 알려준다.

### emil-design-eng — 애니메이션·디테일
```
emil-design-eng 기준으로 이 모달 열고 닫히는 애니메이션 다듬어줘
```
```
emil-design-eng 기준으로 버튼 hover·press 반응 손봐줘
```

---

## 5. 결과가 좋아지는 요령

1. **누가 쓰는지 말하기.** "랜딩 페이지"보다 "30대 프리랜서가 세금 계산할 때 쓰는 앱의 랜딩"이 훨씬 낫다.
2. **분위기를 형용사 2~3개로.** "차분하고 신뢰감 있게", "대담하고 장난스럽게".
3. **참고 사이트 이름 대기.** "Linear처럼", "Stripe 문서처럼". 정확히 따라하려면 `hallmark study`.
4. **한 번에 하나씩.** "색도 바꾸고 레이아웃도 바꾸고 애니메이션도"보다 `colorize` → `layout` → `animate` 순서로 나눠서.
5. **기존 프로젝트면 `DESIGN.md`부터.** `/impeccable document`로 만들어 두면 모든 스킬이 그 기준을 따른다.
