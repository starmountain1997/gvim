#!/usr/bin/env python3
"""configure-pi.py — Configure the pi coding agent in one run.

Does everything, idempotently (skips what is already done; --force overwrites):

1. Global memory  -> ~/.pi/agent/AGENTS.md
2. Skills         -> ~/.pi/agent/skills/   (cloned from GitHub via gh)
3. Packages       -> pi install npm:...    (pi extensions/plugins)

Anything involving GitHub repositories goes through the GitHub CLI (gh).
"""

import argparse
import datetime
import json
import os
import shutil
import subprocess
import sys
import tempfile
from pathlib import Path

PI_DIR = Path.home() / ".pi" / "agent"
SKILLS_DIR = PI_DIR / "skills"
AGENTS_MD = PI_DIR / "AGENTS.md"
SETTINGS_JSON = PI_DIR / "settings.json"

# Skills cloned from GitHub (override with PI_DEFAULT_SKILLS="a/b c/d")
DEFAULT_SKILLS = ["blader/humanizer"]

# pi packages (override with PI_DEFAULT_PACKAGES="npm:a git:b")
DEFAULT_PACKAGES = [
    "npm:@narumitw/pi-subagents",
    "npm:pi-hashline-edit-pro",
    "npm:@ff-labs/pi-fff",
    "npm:pi-agent-browser-native",
    "npm:pi-agent-web-access",
    "git:github.com/DietrichGebert/ponytail",
]

# Directories that never belong in an installed skill.
COPY_IGNORE = shutil.ignore_patterns(
    ".git", ".github", ".claude-plugin", "node_modules", "__pycache__"
)

# ---------------------------------------------------------------------------
# Global memory content — edit here to change what gets written.
# ---------------------------------------------------------------------------
MEMORY_CONTENT = """\
# Global instructions

These instructions apply to every session in every project. Project-level
AGENTS.md files may override them.

## Language

- Reply in the user's language; default to Simplified Chinese when unsure.
- Keep code, identifiers, commands, commit messages, and file contents in English.

## GitHub: use the GitHub CLI

- Anything involving a GitHub repository goes through `gh` first:
  - Clone: `gh repo clone owner/repo` instead of `git clone`.
  - Browse: `gh repo view owner/repo`, file contents via `gh api`.
  - Issues, PRs, releases, gists, actions: `gh issue`, `gh pr`, `gh release`,
    `gh gist`, `gh run`.
- Fall back to plain `git` only when `gh` cannot do the task.
- On auth problems, check `gh auth status` before anything else.

## Packages and skills

- Install pi packages with `pi install`; skills come from GitHub repos via `gh`.

## Working style

- Inspect existing code and callers before editing; prefer the smallest
  change that works.
- Do not add dependencies or abstractions without a concrete need.
- State file paths clearly when working with files.
"""


def log(msg):
    print(f"\033[1;34m[configure-pi]\033[0m {msg}")


def warn(msg):
    print(f"\033[1;33m[configure-pi]\033[0m {msg}", file=sys.stderr)


def err(msg):
    print(f"\033[1;31m[configure-pi]\033[0m {msg}", file=sys.stderr)


def env_list(name, default):
    return os.environ.get(name, " ".join(default)).split()


# ---------------------------------------------------------------------------
# 1. Global memory
# ---------------------------------------------------------------------------
def setup_memory(force):
    PI_DIR.mkdir(parents=True, exist_ok=True)

    if AGENTS_MD.exists():
        if not force:
            log(f"memory: {AGENTS_MD} exists, skipping (use --force to overwrite)")
            return 0
        backup = AGENTS_MD.with_name(f"AGENTS.md.bak.{datetime.datetime.now():%Y%m%d%H%M%S}")
        shutil.copy2(AGENTS_MD, backup)
        log(f"memory: backed up existing -> {backup}")

    AGENTS_MD.write_text(MEMORY_CONTENT, encoding="utf-8")
    log(f"memory: written -> {AGENTS_MD} ({MEMORY_CONTENT.count(chr(10))} lines)")
    return 0


# ---------------------------------------------------------------------------
# 2. Skills (from GitHub repos via gh)
# ---------------------------------------------------------------------------
def parse_frontmatter(skill_md):
    """Return the frontmatter block of a SKILL.md as a dict (top-level keys)."""
    text = skill_md.read_text(encoding="utf-8", errors="replace")
    lines = text.splitlines()
    if not lines or lines[0].strip() != "---":
        return {}
    meta = {}
    for line in lines[1:]:
        if line.strip() == "---":
            break
        if ":" in line and not line.startswith((" ", "\t")):
            key, _, value = line.partition(":")
            meta[key.strip()] = value.strip()
    return meta


def install_skill_repo(repo, force):
    """Clone `repo` via gh and install every SKILL.md found, into SKILLS_DIR."""
    with tempfile.TemporaryDirectory(prefix="pi-skill.") as tmp:
        workdir = Path(tmp) / "repo"
        log(f"skill: cloning {repo} (shallow) via gh ...")
        result = subprocess.run(
            ["gh", "repo", "clone", repo, str(workdir), "--", "--depth", "1"],
            capture_output=True, text=True, check=False,
        )
        if result.returncode != 0:
            err(f"skill: failed to clone {repo}. Check the repo name and 'gh auth status'.")
            if result.stderr:
                err(result.stderr.strip())
            return 1

        skill_files = sorted(workdir.rglob("SKILL.md"))
        if not skill_files:
            warn(f"skill: no SKILL.md found in {repo}.")
            return 1

        SKILLS_DIR.mkdir(parents=True, exist_ok=True)
        rc = 0
        for skill_md in skill_files:
            src_dir = skill_md.parent
            meta = parse_frontmatter(skill_md)
            name = meta.get("name") or src_dir.name
            dest_dir = SKILLS_DIR / name

            if not meta.get("name") or not meta.get("description"):
                warn(f"skill: skipping '{src_dir}' (invalid frontmatter).")
                rc = 1
                continue

            if dest_dir.exists() and not force:
                log(f"skill: '{name}' already installed, skipping (use --force to update)")
                continue

            log(f"skill: installing '{name}' -> {dest_dir}")
            if dest_dir.exists():
                shutil.rmtree(dest_dir)
            shutil.copytree(src_dir, dest_dir, ignore=COPY_IGNORE)
            line_count = len(skill_md.read_text(encoding="utf-8").splitlines())
            log(f"skill:   ✔ installed {name} (SKILL.md: {line_count} lines)")
        return rc


def setup_skills(force):
    rc = 0
    for repo in env_list("PI_DEFAULT_SKILLS", DEFAULT_SKILLS):
        if install_skill_repo(repo, force) != 0:
            rc = 1
    return rc


# ---------------------------------------------------------------------------
# 3. Packages (pi extensions via `pi install`)
# ---------------------------------------------------------------------------
def installed_package_sources():
    """Sources currently listed in ~/.pi/agent/settings.json `packages`."""
    if not SETTINGS_JSON.exists():
        return set()
    try:
        settings = json.loads(SETTINGS_JSON.read_text(encoding="utf-8"))
    except (json.JSONDecodeError, OSError) as exc:
        warn(f"packages: cannot read {SETTINGS_JSON}: {exc}")
        return set()
    sources = set()
    for entry in settings.get("packages", []):
        if isinstance(entry, str):
            sources.add(entry)
        elif isinstance(entry, dict) and isinstance(entry.get("source"), str):
            sources.add(entry["source"])
    return sources


def setup_packages(force):
    pi_bin = shutil.which("pi")
    if pi_bin is None:
        err("packages: 'pi' not found on PATH.")
        return 1

    installed = installed_package_sources()
    rc = 0
    for pkg in env_list("PI_DEFAULT_PACKAGES", DEFAULT_PACKAGES):
        if pkg in installed and not force:
            log(f"packages: {pkg} already installed, skipping (use --force to reinstall)")
            continue
        log(f"packages: installing {pkg} via pi ...")
        result = subprocess.run(
            [pi_bin, "install", pkg],
            check=False, text=True,
        )
        if result.returncode != 0:
            err(f"packages: 'pi install {pkg}' failed (exit {result.returncode}).")
            rc = 1
        else:
            log(f"packages: ✔ installed {pkg}")
    return rc


# ---------------------------------------------------------------------------
# Main
# ---------------------------------------------------------------------------
def main(argv):
    parser = argparse.ArgumentParser(
        prog="configure-pi",
        description="Configure pi in one run: global memory + skills + packages.",
    )
    parser.add_argument(
        "--force", action="store_true",
        help="overwrite existing memory, skills, and packages (backups kept)",
    )
    args = parser.parse_args(argv)

    rc = 0
    rc |= setup_memory(args.force)
    rc |= setup_skills(args.force)
    rc |= setup_packages(args.force)

    log("Done. Restart pi so memory, skills, and packages take effect.")
    return rc


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
