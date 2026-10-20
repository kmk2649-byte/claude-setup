#!/usr/bin/env python3
"""모델 사다리 강제 훅: 매 턴 규칙을 상기시키고, 메인 모델이 한 턴에 직접 많이 읽으면 경고한다."""
import json, os, sys

REMIND = ('모델 사다리(전역 규칙): 하위 작업은 성격에 맞는 단계로 바로 맡긴다(찾기·요약 haiku-helper, 정리·평범한 수정 sonnet, '
          '설계·원인 분석 opus, 돈·보안 검토·막힌 버그 fable-expert), 실패하면 한 단계 위로. '
          '짧은 파일 1~3개·명령 하나는 직접, 긴 파일·여러 파일·긴 출력은 맡겨 요약만 받는다.')
WARN_AT = (15000, 40000, 80000)  # 한 턴 안에서 메인이 직접 받은 도구 출력 글자 수

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
    old = int(open(f).read() or 0) if os.path.exists(f) else 0
    new = old + len(json.dumps(d.get('tool_response', ''), ensure_ascii=False))
    open(f, 'w').write(str(new))
    hit = [w for w in WARN_AT if old < w <= new]
    if not hit:
        sys.exit(0)
    msg = (f'경고: 이번 턴에 메인 모델이 도구 출력을 직접 약 {new:,}자 읽었다. 남은 읽기·요약은 '
           'haiku-helper(정리가 필요하면 sonnet)에 맡기고 요약만 받아라. ' + REMIND)
print(json.dumps({'hookSpecificOutput': {'hookEventName': ev, 'additionalContext': msg}}, ensure_ascii=False))
