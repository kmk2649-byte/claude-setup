# 개발 도구 사용·프롬프트 가이드

개발 절차(superpowers), 최소 코드(ponytail), 리뷰 도구, 상위 모델(fable-expert)을 **새로 만들 때**와 **이미 있는 코드를 개선할 때**로 나눠 정리했다.

> 다른 가이드: [디자인](GUIDE.md) · [업무(마케팅·영업·법무·재무)](GUIDE-work.md) · [기타 도구](GUIDE-tools.md)

---

## 1. 도구 한눈에

| 도구 | 하는 일 | 코드를 고치나 |
|---|---|---|
| **superpowers** | 기획 → 계획 → TDD → 디버깅 → 검증 → 리뷰 → 마무리 절차. 세션마다 자동으로 켜짐 | 단계마다 다름 ([4-1](#4-1-superpowers)) |
| **ponytail** | 가장 작은 변경으로 끝내기. 세션마다 자동으로 켜짐(기본 full) | `/ponytail`만 고침, 나머지는 보고만 |
| `/code-review` | 버그 위주 리뷰. 강도 `low`~`max` | `--fix`를 붙일 때만 |
| `/ponytail-review` · `/ponytail-audit` | 과한 설계·불필요한 코드 찾기(변경분 · 레포 전체) | 아니요 |
| `/security-review` | 현재 브랜치 보안 점검 | 아니요 |
| `/simplify` | 변경분을 더 단순하게 정리 | 예 |
| `/run` | 앱을 실제로 띄워 변경 확인 | 아니요 |
| claude-automation-recommender | 레포를 보고 훅·스킬·MCP·에이전트 추천 | 아니요 |
| **fable-expert** | 어렵거나 실수 비용이 큰 일을 상위 모델에 맡기기 | 요청할 때만 |

---

## 2. 새로 만들 때 (새 프로젝트·새 기능)

### 2-1. 순서

| 단계 | 할 일 | 도구 | 남는 것 |
|---|---|---|---|
| 1 | 무엇을 왜 만들지 정하기 | brainstorming | 큰 일이면 `docs/superpowers/specs/날짜-주제-design.md` |
| 2 | 2~5분 단위 작업으로 쪼개기 | writing-plans | `docs/superpowers/plans/날짜-기능.md` |
| 3 | 작업 공간 분리 | using-git-worktrees | 새 브랜치·worktree |
| 4 | 구현 | executing-plans(싸다) 또는 subagent-driven-development(철저, 비쌈) | 코드·테스트 |
| 5 | 테스트 먼저 쓰기 | test-driven-development | 테스트 |
| 6 | 완료 전 실제로 돌려 확인 | verification-before-completion | 실행 결과 |
| 7 | 리뷰 | requesting-code-review, `/code-review` | 리뷰 결과 |
| 8 | 머지·PR | finishing-a-development-branch | PR |

superpowers는 설계를 승인받기 전에는 코드를 쓰지 않는다. 작은 일은 채팅 속 짧은 설계로 끝나고, 새 프로젝트·하위 시스템 같은 큰 일만 설계 문서를 쓴다.

### 2-2. 프롬프트

**새 프로젝트**
```
{프리랜서 일정 관리 웹앱}을 새로 만들 거야.
brainstorming으로 목표·사용자·범위를 정리해서 설계 문서를 쓰고 확인받아.
승인하면 writing-plans로 작업을 쪼개고, executing-plans로 진행해.
처음 버전은 {로그인·일정 등록·목록} 세 가지만.
```

**기존 프로젝트에 기능 추가**
```
{주문 내역 CSV 내보내기} 기능을 추가해 줘.
짧게 설계를 먼저 보여 주고, 테스트부터 쓰고 구현해.
끝나면 /code-review high로 점검해서 고친 뒤 PR까지 만들어 줘.
```

**덜 만들고 싶을 때** (ponytail과 함께)
```
/ponytail ultra
{알림 기능}을 만들고 싶은데, 정말 필요한 최소 범위부터 따져 줘.
```
`ultra`는 요청 자체를 의심하고 만들기 전에 반박한다. `lite`는 요청대로 만들고 더 작은 대안만 한 줄로 알려 준다.

**설계 갈림길이 클 때**
```
{결제 모듈을 직접 만들지, 외부 서비스를 쓸지} 판단이 필요해.
fable-expert에게 장단점 분석을 맡기고, 그 의견을 참고해서 네가 추천해 줘.
```

### 2-3. 처음 한 번: 레포에 맞는 자동화

```
이 레포에 맞는 Claude Code 자동화(훅·스킬·MCP·에이전트)를 추천해 줘.
```
claude-automation-recommender가 레포를 보고 이유·설치 명령과 함께 추천한다. 설치는 전역 규칙의 확인 절차대로 진행한다.

```
/init
```
이 레포의 구조·명령어를 정리한 CLAUDE.md를 만든다.

---

## 3. 이미 있는 코드를 개선할 때

### 3-1. 버그

```
{로그인 후 가끔 빈 화면이 뜨는} 버그를 고쳐 줘.
원인을 먼저 찾아서 설명하고, 재현 테스트를 쓴 다음 고쳐.
고친 뒤 테스트를 돌려 결과를 보여 줘.
```
systematic-debugging이 "원인을 찾기 전에는 고치지 않는다"를 지킨다. ponytail은 수정 전에 그 함수를 부르는 곳을 모두 찾아, 공통 코드에서 한 번에 고친다.

**두 번 고쳐도 안 잡힐 때**
```
이 버그를 두 번 고쳤는데 계속 실패해. fable-expert에게 원인 분석만 맡기고, 수정은 네가 해.
```

### 3-2. 리뷰

| 보고 싶은 것 | 프롬프트 |
|---|---|
| 버그(기본) | `/code-review high` |
| 리뷰하고 바로 고치기 | `/code-review high --fix` |
| PR에 코멘트로 남기기 | `/code-review high --comment` |
| 과한 설계·지울 코드 | `/ponytail-review` |
| 보안 | `/security-review` |
| 계획대로 다 만들었는지 | `superpowers:requesting-code-review로 계획서 대비 점검해 줘` |
| 돈·인증·데이터 이전이 걸린 큰 변경 | `fable-expert로 이 변경 최종 리뷰해 줘` |

`/ponytail-review`는 Must/Should/Nice 번호 목록만 준다. "2번과 5번 고쳐 줘"처럼 골라서 시킨다.

### 3-3. 정리·리팩터

```
/ponytail-audit
```
레포 전체에서 버그·보안·부하·테스트 없는 위험 코드·느린 곳·지울 것을 중요도 순으로 보여 준다(고치지 않음).
```
위 목록에서 1~3번만 고쳐 줘. 동작은 바뀌지 않게 하고 테스트로 확인해.
```
```
/simplify
```
방금 바꾼 코드를 더 짧고 단순하게 정리한다(버그 찾기는 아님).

### 3-4. 쌓인 지름길 확인

```
/ponytail-debt
```
`shortcut:` 주석(나중에 고쳐야 할 지름길)을 모아 목록으로 보여 준다.

### 3-5. 남이 만든 큰 레포 파악

```
/graphify .
```
코드 연결 지도를 만들고 핵심 모듈과 추천 질문을 보여 준다. 자세한 사용법은 [기타 도구 가이드](GUIDE-tools.md#1-graphify--코드문서를-지식-그래프로).

---

## 4. 도구별 참고

### 4-1. superpowers

| 스킬 | 언제 | 코드 수정 |
|---|---|---|
| brainstorming | 기능·동작을 바꾸기 전 | 승인 전에는 아니요 |
| writing-plans | 설계 승인 후 | 아니요(계획서만) |
| executing-plans | 같은 세션에서 직접 실행. 싸다 | 예 |
| subagent-driven-development | 작업마다 새 에이전트 + 작업별 리뷰. 철저하지만 비쌈 | 예 |
| using-git-worktrees | 구현 시작 전 작업 공간 분리 | 브랜치만 |
| test-driven-development | 기능·버그·리팩터 전 실패 테스트부터 | 예 |
| systematic-debugging | 모든 버그·테스트 실패. 원인부터 | 원인 확정 후 |
| verification-before-completion | "됐다"고 말하기 전 실제 실행 | 아니요 |
| requesting / receiving-code-review | 리뷰 요청 / 리뷰 받은 뒤 검증하고 반영 | 반영할 때 |
| dispatching-parallel-agents | 독립 작업 2개 이상 동시에 | 에이전트가 |
| finishing-a-development-branch | 끝난 뒤 로컬 머지 / PR / 유지 중 선택 | git 작업 |
| writing-skills | 새 스킬 만들기 | 스킬 파일 |
| diagnosing-superpowers | superpowers가 이상하게 굴 때 원인 보고서 | 아니요 |

슬래시 명령은 없다. 스킬 이름을 말하거나 자연어로 요청하면 된다.

### 4-2. ponytail

| 명령 | 하는 일 |
|---|---|
| `/ponytail lite` · `full` · `ultra` | 강도 바꾸기. lite=대안만 제안, full=기본, ultra=만들기 전에 반박 |
| `stop ponytail` 또는 `normal mode` | 끄기 |
| `/ponytail-review` | 변경분 리뷰(목록만) |
| `/ponytail-audit` | 레포 전체 점검(목록만) |
| `/ponytail-debt` | `shortcut:` 주석 목록 |
| `/ponytail-gain` | 절감 효과 수치 |
| `/ponytail-help` | 도움말 |

답 끝에 "건너뛴 것과 위험" 한두 줄이 붙는다. 서브에이전트에도 같은 규칙이 들어간다.

### 4-3. superpowers와 ponytail이 부딪힐 때

둘 다 세션마다 켜지고, 서로의 우선순위는 정해져 있지 않다.

| 쟁점 | superpowers | ponytail |
|---|---|---|
| 테스트 | 기능·버그·리팩터는 항상 TDD | 사소한 변경은 테스트 없음, 새 로직엔 작은 테스트 하나 |
| 문서 | 큰 일은 설계 문서·계획서 | 필요 없는 건 만들지 않음 |

원하는 쪽을 프롬프트에 적으면 그대로 따른다. 사용자 지시가 두 스킬보다 우선이다.
- 꼼꼼하게: "이번엔 superpowers 절차대로 설계 문서와 TDD까지 해 줘"
- 가볍게: "작은 수정이니 설계 문서 없이 최소 변경으로 해 줘"

### 4-4. 리뷰 도구 고르기

| 상황 | 도구 |
|---|---|
| 일반 PR·변경분 | `/code-review` |
| 코드가 너무 커졌다 | `/ponytail-review` (레포 전체는 `/ponytail-audit`) |
| 계획서 대비 빠진 것 | `superpowers:requesting-code-review` |
| 인증·권한·입력 처리 | `/security-review` |
| 돈·데이터 이전·큰 변경 | 위 도구 + fable-expert 최종 검토 |

---

## 5. 막힐 때

| 증상 | 할 일 |
|---|---|
| 작은 수정인데 설계 문서부터 쓰려 한다 | "작은 수정이니 설계 문서 없이 바로 해 줘" |
| 테스트 없이 끝내려 한다 | "테스트부터 쓰고, 돌린 결과를 보여 줘" |
| 너무 많이 만든다 | `/ponytail ultra` 또는 "처음 버전은 {세 가지}만" |
| 너무 적게 만든다 | `/ponytail lite` 또는 `stop ponytail` |
| "됐다"는데 실제로 안 된다 | "verification-before-completion대로 실제로 돌려서 증거를 보여 줘" |
| 같은 버그를 두 번 못 잡았다 | fable-expert에게 원인 분석을 맡긴다 |
| subagent-driven-development가 비싸다 | "executing-plans로 진행해 줘" |
