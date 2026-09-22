# g-pi

One-shot, idempotent configuration for the [pi coding agent](https://pi.dev):
global memory, skills, and packages in a single run.

## Quick start

```bash
curl -fsSL https://raw.githubusercontent.com/starmountain1997/gvim/main/g-pi/configure-pi.py | python3
```

Force overwrite (existing memory, skills, and packages are reinstalled; backups kept):

```bash
curl -fsSL https://raw.githubusercontent.com/starmountain1997/gvim/main/g-pi/configure-pi.py | python3 - --force
```

Or clone and run:

```bash
gh repo clone starmountain1997/gvim
python3 gvim/g-pi/configure-pi.py
```

## What it configures

| Step | Target | Mechanism |
|------|--------|-----------|
| 1. Global memory | `~/.pi/agent/AGENTS.md` | Writes the embedded memory content (backup on `--force`) |
| 2. Skills | `~/.pi/agent/skills/` | `gh repo clone` + install every `SKILL.md` found |
| 3. Packages | `~/.pi/agent/settings.json` | `pi install npm:...` / `pi install git:...` |

The run is idempotent: everything already in place is skipped, only missing
items are installed. Restart pi afterwards so changes take effect.

## Requirements

- [`pi`](https://pi.dev) on `PATH`
- [`gh`](https://cli.github.com) authenticated (`gh auth status`) — all GitHub
  access goes through the GitHub CLI
- Python 3.9+ (stdlib only, no third-party dependencies)

## Defaults

```python
DEFAULT_SKILLS = ["blader/humanizer"]

DEFAULT_PACKAGES = [
    "npm:@narumitw/pi-subagents",
    "npm:pi-hashline-edit-pro",
    "npm:@ff-labs/pi-fff",
    "npm:pi-agent-browser-native",
    "npm:pi-agent-web-access",
    "git:github.com/DietrichGebert/ponytail",
]
```

Customize without editing the script:

```bash
PI_DEFAULT_SKILLS="owner/repo" PI_DEFAULT_PACKAGES="npm:a git:b" \
  curl -fsSL https://raw.githubusercontent.com/starmountain1997/gvim/main/g-pi/configure-pi.py | python3
```

To change the global memory content, edit `MEMORY_CONTENT` in the script, or
edit `~/.pi/agent/AGENTS.md` directly.
