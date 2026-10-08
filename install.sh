#!/usr/bin/env bash
# 이 컴퓨터(현재 사용자)에 Claude 스킬·에이전트·플러그인·MCP 설치. 여러 번 실행해도 안전.
set -e
DIR=$(cd "$(dirname "$0")" && pwd)
mkdir -p ~/.claude/skills ~/.claude/agents
cp -r "$DIR"/skills/* ~/.claude/skills/
cp "$DIR"/agents/*.md ~/.claude/agents/
claude plugin marketplace add DietrichGebert/ponytail 2>/dev/null || true
claude plugin install ponytail@ponytail --scope user 2>/dev/null || true
claude plugin marketplace add anthropics/claude-plugins-official 2>/dev/null || true
claude plugin install superpowers@claude-plugins-official --scope user 2>/dev/null || true
# 클라우드 컨테이너: Chrome 없음 → 내장 Chromium, root라 샌드박스 끔, 화면 없음
PW_ARGS=""
[ -x /opt/pw-browsers/chromium ] && PW_ARGS="--headless --no-sandbox --executable-path /opt/pw-browsers/chromium"
claude mcp add --scope user playwright -- npx @playwright/mcp@latest $PW_ARGS 2>/dev/null || true
echo "완료: 스킬 $(ls "$DIR"/skills | wc -l)개, 에이전트 $(ls "$DIR"/agents | wc -l)개, ponytail·superpowers 플러그인, playwright"
