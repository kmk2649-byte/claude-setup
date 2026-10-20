#!/usr/bin/env python3
"""모델 사다리 강제 훅: 매 턴 규칙을 상기시키고, 메인 모델이 한 턴에 직접 읽기·검색을 많이 하면 경고한다."""
import json, os, sys

REMIND = ('모델 사다리(전역 규칙): 하위 작업은 직접 하지 말고 haiku-helper(하이쿠)부터 맡기고, '
          '못 하면 sonnet → opus → fable-expert 순서로 올린다. 메인은 일 나누기·결과 확인·보고만.')
WARN_AT = (4, 10, 20)  # 한 턴 안에서 메인이 직접 쓴 Read·Grep·Glob·Bash 횟수

d = json.load(sys.stdin)
if d.get('agent_id'):  # 서브에이전트 안의 도구 호출은 세지 않는다
    sys.exit(0)
ev = d.get('hook_event_name')
f = os.path.expanduser(f"~/.claude/state/ladder-{d.get('session_id', 'x')}")
os.makedirs(os.path.dirname(f), exist_ok=True)

if ev == 'UserPromptSubmit':
    open(f, 'w').write('0')
    msg = REMIND
else:
    n = int(open(f).read() or 0) + 1 if os.path.exists(f) else 1
    open(f, 'w').write(str(n))
    if n not in WARN_AT:
        sys.exit(0)
    msg = (f'경고: 이번 턴에 메인 모델이 직접 도구를 {n}번 썼다. 남은 찾기·읽기·요약·기계적 수정은 '
           'haiku-helper에 맡기고(Agent subagent_type "haiku-helper"), 요약만 받아라. ' + REMIND)
print(json.dumps({'hookSpecificOutput': {'hookEventName': ev, 'additionalContext': msg}}, ensure_ascii=False))
