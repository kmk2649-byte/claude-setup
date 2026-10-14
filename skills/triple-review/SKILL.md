---
name: triple-review
description: >-
  코드 리뷰를 세 가지 시각으로 한 번에 한다: code-review(버그), ponytail-review(과한 코드·지울 코드),
  Codex review(다른 모델의 시각). 결과는 하나의 보고서로 합친다. 사용자가 리뷰어를 지정하지 않고
  코드를 리뷰해 달라고 할 때 쓴다: "코드 리뷰해", "이 PR 리뷰해", "이 브랜치·변경 리뷰해",
  "review this code/PR", "/triple-review". 계약서·문서·카피처럼 코드가 아닌 리뷰에는 쓰지 않는다.
  /code-review, /ponytail-review, /codex:review 중 하나를 콕 집으면 이 스킬 대신 그것만 쓴다.
argument-hint: "[PR 번호 | 브랜치 | --base <ref>]"
---

# triple-review

세 리뷰어가 같은 대상을 서로 다른 시각으로 보고, 결과를 하나로 합친다. **리뷰만 한다. 코드는 고치지 않고, 사용자의 작업 폴더·브랜치도 바꾸지 않는다.**

사용자가 넘긴 것: `$ARGUMENTS` (비었으면 대화에서 대상을 정한다)

## 1. 대상 정하기

세 리뷰어는 반드시 같은 코드를 본다. 아래에서 `DIR`(리뷰할 폴더), Codex 인자, Claude 리뷰어에게 넘길 범위를 정한다. `DIR`은 기본이 현재 레포 루트다.

| 경우 | Codex 인자 | Claude 리뷰어 범위 |
|---|---|---|
| 인자 없음, 커밋 안 된 변경 있음(`git status --porcelain`이 비어 있지 않음) | `--scope working-tree` | "커밋 안 된 변경 전체: `git diff HEAD`와 추적 안 되는 새 파일(`git ls-files --others --exclude-standard`)" |
| 인자 없음, 변경 없음 | `--base origin/<기본 브랜치>` | `origin/<기본 브랜치>...HEAD` |
| 브랜치 `X` 또는 `--base X` | `--base origin/X` (원격에 없으면 `X`) | `<같은 기준>...HEAD` |
| PR 번호 `N` | `--base origin/<PR base>` | `<같은 기준>...HEAD`, 폴더는 아래 worktree |

- 기준 브랜치는 먼저 `git fetch origin <브랜치>`로 최신으로 받는다. 오래된 로컬 브랜치를 기준으로 쓰지 않는다.
- PR이면 사용자의 작업 폴더를 건드리지 않는다. PR의 base 브랜치 이름은 GitHub 도구(PR 조회)나 `gh pr view N --json baseRefName`으로 알아낸 뒤:
  ```bash
  git fetch origin <base> "+pull/N/head:refs/remotes/origin/pr-N"
  DIR=$(mktemp -d)/pr-N && git worktree add --detach "$DIR" origin/pr-N
  ```
  리뷰가 끝나면(실패해도) `git worktree remove --force "$DIR"`로 지운다.
- 기준을 정했는데 범위 밖에 남는 것이 있으면 기억해 두고 보고서에 "리뷰 안 됨"으로 적는다: 브랜치·PR 리뷰인데 작업 폴더에 커밋 안 된 변경이 있을 때, 인자 없음인데 푸시 안 된 커밋이 있을 때.
- 리뷰할 변경이 정말 없으면 그렇게 말하고 끝낸다.

## 2. Codex 시작 (백그라운드)

`/codex:review`는 Claude가 부를 수 없게 막혀 있으므로(`disable-model-invocation`), 그 명령이 실행하는 스크립트를 직접 돌린다. 셸 변수는 Bash 호출 사이에 이어지지 않으니, **경로 찾기와 실행을 매번 한 명령에** 넣는다.

준비 확인:
```bash
CC=$(ls -d ~/.claude/plugins/cache/openai-codex/codex/*/scripts/codex-companion.mjs 2>/dev/null | sort -V | tail -1); [ -n "$CC" ] && node "$CC" setup --json || echo "codex plugin not installed"
```

- 플러그인이 없거나 `codex.available`·`auth.loggedIn`이 false면 Codex는 건너뛴다. 이유를 보고서 끝에 적는다(로그인 안 됨이면 "`codex login` 또는 `OPENAI_API_KEY` 필요").
- 준비됐으면 Bash를 `run_in_background: true`로 실행한다. 몇 분 걸린다.
  ```bash
  cd "<DIR>" && CC=$(ls -d ~/.claude/plugins/cache/openai-codex/codex/*/scripts/codex-companion.mjs | sort -V | tail -1) && node "$CC" review --wait <Codex 인자>
  ```

기다리지 말고 바로 3으로 간다.

## 3. Claude 리뷰 둘

Skill 도구로 차례로 부른다. 둘 다 인자로 1에서 정한 폴더(`DIR`이 레포 루트가 아니면)와 범위를 그대로 적어 넘긴다. `--fix`, `--comment`는 넘기지 않는다.

1. `code-review`: 버그·정확성.
2. `ponytail:ponytail-review`: 과한 설계, 필요 없는 줄, 지울 코드.

각 결과(파일:줄, 내용, 심각도)를 받아 둔다. 이 단계에서는 사용자에게 따로 보고하지 않는다.

## 4. 합치기

Codex가 끝날 때까지 기다린 뒤(백그라운드 작업 완료 알림), 출력 원문을 읽는다. 실패했으면 이유를 기억하고 둘로만 합친다.

```
## 코드 리뷰 (3개 시각)
대상: <커밋 안 된 변경 | 브랜치 X vs origin/Y | PR #N>

1. [버그·Codex] api.ts:42 — 빈 배열이면 0으로 나눔
2. [버그] auth.ts:10 — 토큰 만료 확인 없음
3. [과한 코드] utils.ts — 한 번만 쓰는 래퍼, 지워도 됨

### 의견 갈림
- utils.ts 캐시: Codex는 필요하다, ponytail은 빼라. (내 판단: …)

리뷰 안 됨: 작업 폴더의 커밋 안 된 변경 2개 파일
건너뜀: Codex — 로그인 안 됨
```

- 같은 문제(같은 곳, 같은 원인)는 한 줄로 묶고, 찾은 리뷰어를 한 괄호 안에 `·`로 이어 적는다. 이름은 `버그`(code-review), `과한 코드`(ponytail-review), `Codex`. 예: `[버그·Codex]`.
- 순서: 심각도 순(데이터 손실·보안·잘못된 결과 → 오작동 → 정리). 같은 심각도면 여러 리뷰어가 짚은 것을 먼저.
- 리뷰어끼리 서로 반대되는 지적은 「의견 갈림」에 모으고, 코드를 보고 어느 쪽이 맞는지 한 줄로 판단을 붙인다.
- 한 리뷰어만 짚은 지적도 버리지 않는다. 다만 코드를 확인해 틀린 지적이면 빼고, 뺀 이유를 한 줄로 적는다.
- 지적이 하나도 없으면 "세 리뷰어 모두 문제 없음"이라고 쓴다.

마지막에 "몇 번을 고칠까요?"라고 묻고 멈춘다.
