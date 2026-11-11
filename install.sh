#!/usr/bin/env bash
# 이 컴퓨터(현재 사용자)에 Claude 스킬·에이전트·플러그인·MCP 설치. 여러 번 실행해도 안전.
set -e
DIR=$(cd "$(dirname "$0")" && pwd)
mkdir -p ~/.claude/skills ~/.claude/agents
cp -r "$DIR"/skills/* ~/.claude/skills/
cp "$DIR"/agents/*.md ~/.claude/agents/
# 법무·재무 플러그인의 한국 기준 기본 플레이북 (프로젝트 .claude/에 있으면 그쪽이 우선)
cp "$DIR"/korea/*.local.md ~/.claude/
# 전역 규칙: 이 레포 CLAUDE.md를 ~/.claude/CLAUDE.md의 표시 구간에 넣는다(있으면 교체, 구간 밖 내용은 그대로)
F=~/.claude/CLAUDE.md; touch "$F"
awk '/^<!-- claude-setup:start -->$/{s=1} !s{print} /^<!-- claude-setup:end -->$/{s=0}' "$F" > "$F.tmp"
{ cat "$F.tmp"; echo '<!-- claude-setup:start -->'; cat "$DIR/CLAUDE.md"; echo '<!-- claude-setup:end -->'; } > "$F"
rm "$F.tmp"
# 에이전트 현황판·Claude 오피스 훅(Personal_Dashboard)·모델 사다리 훅·impeccable 디자인 검출 훅: ~/.claude/settings.json에 합친다. 예전 report_status·report_office·office-hook 훅은 빼고 다시 넣어 여러 번 실행해도 하나만 남는다.
# anon 키는 레포(공개)에 두지 않고 환경변수 AGENT_BOARD_ANON_KEY로 받는다. 없으면 보고만 401로 실패하고 세션은 그대로 돈다.
cp "$DIR/settings/office-hook.py" "$DIR/settings/ladder-hook.py" ~/.claude/
# 윈도우는 python3 가 없거나 스토어 안내용 가짜일 때가 많다 → 실제로 도는 것을 골라 훅 명령에도 그 이름을 쓴다
PY=$(for p in python3 python py; do "$p" -c '' >/dev/null 2>&1 && { echo "$p"; break; }; done) || true
[ -n "$PY" ] || echo "경고: 파이썬을 못 찾아 현황판·오피스·모델 사다리 훅을 설치하지 못했습니다(python.org 에서 설치 후 다시 실행)" >&2
"${PY:-python3}" - "$PY" "$DIR/settings/agent-board-hooks.json" "$DIR/settings/office-hooks.json" "$DIR/settings/ladder-hooks.json" <<'EOF' || true
import json, os, sys
py = sys.argv.pop(1)
p = os.path.expanduser('~/.claude/settings.json')
s = json.load(open(p, encoding='utf-8')) if os.path.exists(p) else {}
hooks = s.setdefault('hooks', {})
for ev in hooks:
    hooks[ev] = [g for g in hooks[ev] if not any(m in json.dumps(g) for m in ('report_status', 'report_office', 'office-hook', 'ladder-hook', 'impeccable/scripts/impeccable'))]
for f in sys.argv[1:]:
    for ev, groups in json.loads(open(f, encoding='utf-8').read().replace('python3 ~/', py + ' ~/'))['hooks'].items():
        hooks[ev] = hooks.get(ev, []) + groups
json.dump(s, open(p + '.tmp', 'w', encoding='utf-8'), ensure_ascii=False, indent=2)
os.replace(p + '.tmp', p)
EOF
claude plugin marketplace add DietrichGebert/ponytail 2>/dev/null || true
claude plugin install ponytail@ponytail --scope user 2>/dev/null || true
claude plugin marketplace add anthropics/claude-plugins-official 2>/dev/null || true
claude plugin install superpowers@claude-plugins-official --scope user 2>/dev/null || true
claude plugin install claude-code-setup@claude-plugins-official --scope user 2>/dev/null || true
claude plugin marketplace add nextlevelbuilder/ui-ux-pro-max-skill 2>/dev/null || true
claude plugin install ui-ux-pro-max@ui-ux-pro-max-skill --scope user 2>/dev/null || true
claude plugin marketplace add anthropics/knowledge-work-plugins 2>/dev/null || true
claude plugin install legal@knowledge-work-plugins --scope user 2>/dev/null || true
# marketing·sales는 전역에서 끔(매 턴 기술 목록·인증 안 된 연결 서버가 붙어 토큰 낭비). 쓰는 프로젝트에서만 그 프로젝트 .claude/settings.json enabledPlugins로 켠다
for p in marketing sales; do claude plugin disable $p@knowledge-work-plugins --scope user 2>/dev/null || true; done
# Codex는 뺐다. 예전에 설치한 PC에서도 지운다(리뷰 때 Codex 로그인을 자꾸 요구해서)
claude plugin uninstall codex@openai-codex --scope user 2>/dev/null || true
claude plugin marketplace add HeyCubit/effortless 2>/dev/null || true
claude plugin install effortless@effortless --scope user 2>/dev/null || true
# 브라우저 자동화: agent-browser CLI(약 130MB) + 스킬. playwright MCP는 뺐다(예전에 등록한 PC에서도 지운다)
claude mcp remove --scope user playwright >/dev/null 2>&1 || true
command -v agent-browser >/dev/null || npm install -g agent-browser >/dev/null 2>&1 || true
if [ -x /opt/pw-browsers/chromium ]; then
  # 클라우드엔 Chromium이 이미 있음 → 그걸 쓰게 설정(이미 설정 파일이 있으면 그대로 둔다)
  mkdir -p ~/.agent-browser
  [ -f ~/.agent-browser/config.json ] || echo '{"executablePath":"/opt/pw-browsers/chromium"}' > ~/.agent-browser/config.json
else
  # Chrome for Testing 받기. 화면 없는 Linux는 시스템 라이브러리까지
  if [ "$(uname)" = Linux ] && [ -z "$DISPLAY$WAYLAND_DISPLAY" ]; then agent-browser install --with-deps >/dev/null 2>&1 || true
  else agent-browser install >/dev/null 2>&1 || true; fi
fi
# Uplika(네이버 블로그·SNS 발행·키워드·노출). 이미 있으면 그대로 둔다. 로그인은 claude 실행 → /mcp → uplika 에서 한 번
claude mcp add --transport http --scope user uplika https://api.uplika.com/mcp >/dev/null 2>&1 || true
echo "완료: 전역 규칙(~/.claude/CLAUDE.md), 한국 기준 법무·재무 플레이북, 스킬 $(ls "$DIR"/skills | wc -l)개, 에이전트 $(ls "$DIR"/agents | wc -l)개, ponytail·superpowers·claude-code-setup·ui-ux-pro-max·legal·effortless 플러그인, uplika MCP, agent-browser CLI"
