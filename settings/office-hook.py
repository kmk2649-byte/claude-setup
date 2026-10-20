#!/usr/bin/env python3
"""Claude 오피스 보고 (Personal_Dashboard web/office.html).

훅 입력을 줄여 Supabase report_office(p)에 보낸다. 도구를 쓰기 직전(PreToolUse)이면
세션 기록 끝에서 Claude가 마지막으로 한 생각·말을 꺼내 생각 구름으로 쓰게 한다.
office-hooks.json이 백그라운드로 띄우므로 Claude는 기다리지 않는다. 실패해도 조용히 끝난다.
"""
import json
import os
import sys
import urllib.request

URL = 'https://ckxmzpqfjxwbqibfxvxu.supabase.co/rest/v1/rpc/report_office'
KEEP = ('description', 'file_path', 'notebook_path', 'command', 'pattern', 'url', 'query', 'subagent_type', 'model')


def thought(path):
    """기록 끝 256KB에서 가장 최근 assistant의 생각·말 한 줄. 새 질문을 지나면 멈춘다(지난 턴 생각은 안 씀)."""
    try:
        with open(path, 'rb') as f:
            f.seek(0, 2)
            f.seek(max(0, f.tell() - 262144))
            lines = f.read().decode('utf-8', 'ignore').splitlines()
    except OSError:
        return None
    for line in reversed(lines):
        try:
            d = json.loads(line)
        except ValueError:
            continue
        content = (d.get('message') or {}).get('content')
        if d.get('type') == 'user' and isinstance(content, str):
            return None
        if d.get('type') != 'assistant' or not isinstance(content, list):
            continue
        for b in reversed(content):
            text = (b.get('text') or b.get('thinking') or '').strip()
            if text:
                return ' '.join(text.split())[:100]
    return None


def home(p):
    """층 이름이 될 폴더: 세션을 시작한 폴더(기록 첫 cwd)의 git 저장소 맨 위.
    시작 폴더가 저장소가 아니면(여러 저장소를 붙인 클라우드 세션의 /home/user) 그 아래 가장 먼저 받은 저장소.
    세션이 다른 저장소로 cd 해도 층이 바뀌지 않게 한다."""
    start = None
    try:
        with open(p.get('transcript_path') or '', encoding='utf-8', errors='ignore') as f:
            for _, line in zip(range(50), f):
                if '"cwd"' in line:
                    start = json.loads(line).get('cwd')
                    break
    except (OSError, ValueError):
        pass
    start = start or p.get('cwd') or ''
    d = start
    while d and d != os.path.dirname(d):
        if os.path.isdir(os.path.join(d, '.git')):
            return d
        d = os.path.dirname(d)
    try:
        repos = [os.path.join(start, n) for n in os.listdir(start) if os.path.isdir(os.path.join(start, n, '.git'))]
        if repos:
            return min(repos, key=lambda r: (os.stat(os.path.join(r, '.git')).st_ctime, r))
    except OSError:
        pass
    return start


def slim(p):
    ti = p.get('tool_input')
    out = {k: p[k] for k in ('hook_event_name', 'session_id', 'cwd', 'tool_name', 'tool_use_id', 'agent_id',
                             'agent_type', 'message', 'prompt', 'error') if isinstance(p.get(k), str)}
    out['cwd'] = home(p)
    if 'prompt' in out:
        out['prompt'] = out['prompt'][:200]
    if isinstance(ti, dict):
        out['tool_input'] = {k: str(ti[k])[:300] for k in KEEP if ti.get(k)}
    if p.get('hook_event_name') == 'PreToolUse' and not p.get('agent_id') and p.get('transcript_path'):
        out['thought'] = thought(p['transcript_path'])
    return out


def main():
    key = os.environ.get('AGENT_BOARD_ANON_KEY')
    if not key:
        return
    p = json.load(sys.stdin)
    req = urllib.request.Request(URL, json.dumps({'p': slim(p)}).encode(), {
        'apikey': key, 'Authorization': 'Bearer ' + key, 'Content-Type': 'application/json'})
    urllib.request.urlopen(req, timeout=5).read()


if __name__ == '__main__':
    try:
        main()
    except Exception:
        pass
