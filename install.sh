#!/usr/bin/env bash
# 이 컴퓨터(현재 사용자)에 Claude 스킬·에이전트·플러그인·MCP 설치. 여러 번 실행해도 안전.
set -e
DIR=$(cd "$(dirname "$0")" && pwd)
mkdir -p ~/.claude/skills ~/.claude/agents
cp -r "$DIR"/skills/* ~/.claude/skills/
cp "$DIR"/agents/*.md ~/.claude/agents/
# 전역 규칙: 이 레포 CLAUDE.md를 ~/.claude/CLAUDE.md의 표시 구간에 넣는다(있으면 교체, 구간 밖 내용은 그대로)
F=~/.claude/CLAUDE.md; touch "$F"
awk '/^<!-- claude-setup:start -->$/{s=1} !s{print} /^<!-- claude-setup:end -->$/{s=0}' "$F" > "$F.tmp"
{ cat "$F.tmp"; echo '<!-- claude-setup:start -->'; cat "$DIR/CLAUDE.md"; echo '<!-- claude-setup:end -->'; } > "$F"
rm "$F.tmp"
claude plugin marketplace add DietrichGebert/ponytail 2>/dev/null || true
claude plugin install ponytail@ponytail --scope user 2>/dev/null || true
claude plugin marketplace add anthropics/claude-plugins-official 2>/dev/null || true
claude plugin install superpowers@claude-plugins-official --scope user 2>/dev/null || true
claude plugin install claude-code-setup@claude-plugins-official --scope user 2>/dev/null || true
claude plugin marketplace add nextlevelbuilder/ui-ux-pro-max-skill 2>/dev/null || true
claude plugin install ui-ux-pro-max@ui-ux-pro-max-skill --scope user 2>/dev/null || true
# 클라우드 컨테이너: Chrome 없음 → 내장 Chromium, root라 샌드박스 끔, 화면 없음
PW_ARGS=""
[ -x /opt/pw-browsers/chromium ] && PW_ARGS="--headless --no-sandbox --executable-path /opt/pw-browsers/chromium"
claude mcp add --scope user playwright -- npx @playwright/mcp@latest $PW_ARGS 2>/dev/null || true
echo "완료: 전역 규칙(~/.claude/CLAUDE.md), 스킬 $(ls "$DIR"/skills | wc -l)개, 에이전트 $(ls "$DIR"/agents | wc -l)개, ponytail·superpowers·claude-code-setup·ui-ux-pro-max 플러그인, playwright"
