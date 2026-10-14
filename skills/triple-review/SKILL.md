---
name: triple-review
description: >-
  코드 리뷰를 세 가지 시각으로 한 번에 한다: code-review(버그), ponytail-review(과한 코드·지울 코드),
  Codex review(다른 모델의 시각). 결과는 하나의 보고서로 합친다. 사용자가 리뷰어를 지정하지 않고
  "코드 리뷰해", "리뷰해 줘", "이 PR 리뷰", "review this", "/triple-review"라고 할 때 쓴다.
  사용자가 /code-review, /ponytail-review, /codex:review 중 하나를 콕 집으면 이 스킬 대신 그것만 쓴다.
argument-hint: "[PR 번호 | 브랜치 | --base <ref>]"
---

# triple-review

세 리뷰어가 같은 대상을 서로 다른 시각으로 보고, 결과를 하나로 합친다. **리뷰만 한다. 코드는 고치지 않는다.**

사용자가 넘긴 것: `$ARGUMENTS` (비었으면 대화에서 대상을 정한다)

## 1. 대상 정하기

세 리뷰어 모두 같은 대상을 본다. 셋 중 하나로 정한다.

- 아무것도 없으면: 지금 작업 트리의 변경(커밋 안 된 것 포함). 그것도 비었으면 현재 브랜치 vs 기본 브랜치.
- 브랜치 또는 `--base <ref>`: 그 기준 대비 현재 브랜치.
- PR 번호: PR의 head 브랜치를 체크아웃하고, PR의 base를 기준으로 본다.

리뷰할 변경이 정말 없으면 그렇게 말하고 끝낸다.

## 2. Codex 시작 (백그라운드)

`/codex:review`는 Claude가 부를 수 없게 막혀 있으므로(`disable-model-invocation`), 그 명령이 실행하는 스크립트를 직접 돌린다.

```bash
CC=$(ls -d ~/.claude/plugins/cache/openai-codex/codex/*/scripts/codex-companion.mjs 2>/dev/null | sort -V | tail -1)
node "$CC" setup --json
```

- `CC`가 비었거나 `codex.available`이 false거나 `auth.loggedIn`이 false면 Codex는 건너뛴다. 이유를 기억해 보고서 끝에 적는다(로그인 안 됨이면 "`codex login` 또는 `OPENAI_API_KEY` 필요").
- 준비됐으면 Bash를 `run_in_background: true`로 실행한다. 몇 분 걸린다.
  - 작업 트리: `node "$CC" review --wait --scope working-tree`
  - 브랜치·PR: `node "$CC" review --wait --base <기준>`

기다리지 말고 바로 3으로 간다.

## 3. Claude 리뷰 둘

Skill 도구로 차례로 부른다. 둘 다 1에서 정한 대상을 넘긴다. `--fix`, `--comment`는 넘기지 않는다.

1. `code-review`: 버그·정확성.
2. `ponytail:ponytail-review`: 과한 설계, 필요 없는 줄, 지울 코드.

각 결과(파일:줄, 내용, 심각도)를 받아 둔다. 이 단계에서는 사용자에게 따로 보고하지 않는다.

## 4. 합치기

Codex가 끝날 때까지 기다린 뒤(백그라운드 작업 완료 알림), 출력 원문을 읽는다. 실패했으면 이유를 기억하고 둘로만 합친다.

```
## 코드 리뷰 (3개 시각)
대상: <작업 트리 | 브랜치 X vs Y | PR #N>

1. [버그·Codex] api.ts:42 — 빈 배열이면 0으로 나눔
2. [버그] auth.ts:10 — 토큰 만료 확인 없음
3. [과한 코드] utils.ts — 한 번만 쓰는 래퍼, 지워도 됨

### 의견 갈림
- utils.ts 캐시: Codex는 필요하다, ponytail은 빼라. (내 판단: …)

건너뜀: Codex — 로그인 안 됨
```

- 같은 문제(같은 곳, 같은 원인)는 한 줄로 묶고 찾은 리뷰어를 모두 표시한다: `[버그]`, `[과한 코드]`, `[Codex]`.
- 순서: 심각도 순(데이터 손실·보안·잘못된 결과 → 오작동 → 정리). 같은 심각도면 여러 리뷰어가 짚은 것을 먼저.
- 리뷰어끼리 서로 반대되는 지적은 「의견 갈림」에 모으고, 코드를 보고 어느 쪽이 맞는지 한 줄로 판단을 붙인다.
- 한 리뷰어만 짚은 지적도 버리지 않는다. 다만 코드를 확인해 틀린 지적이면 뺀다.
- 지적이 하나도 없으면 "세 리뷰어 모두 문제 없음"이라고 쓴다.

마지막에 "몇 번을 고칠까요?"라고 묻고 멈춘다.
