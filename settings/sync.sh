#!/usr/bin/env bash
# SessionStart 훅: claude-setup main이 마지막 설치 때와 다르면 install.sh를 다시 돌린다.
# 클라우드는 처음 setup 결과를 저장해 두고 복원만 해서, 레포를 고쳐도 새 세션에 반영되지 않기 때문.
R=~/.cache/claude-setup
REV=~/.claude/.claude-setup-rev
if [ -d "$R/.git" ]; then
  git -C "$R" fetch -q --depth 1 origin main 2>/dev/null || exit 0
else
  git clone -q --depth 1 https://github.com/kmk2649-byte/claude-setup "$R" 2>/dev/null || exit 0
  git -C "$R" fetch -q --depth 1 origin main 2>/dev/null || exit 0
fi
new=$(git -C "$R" rev-parse FETCH_HEAD)
[ "$new" = "$(cat "$REV" 2>/dev/null)" ] && exit 0
git -C "$R" reset -q --hard FETCH_HEAD
if bash "$R/install.sh" >~/.claude/.claude-setup-sync.log 2>&1; then
  echo "claude-setup을 최신(${new:0:7})으로 다시 설치했다. 스킬·규칙 변경은 일부 다음 세션부터 보일 수 있다."
else
  echo "claude-setup 자동 업데이트 실패(~/.claude/.claude-setup-sync.log 참고)."
fi
