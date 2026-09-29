#!/usr/bin/env python3
"""The status line: which model is answering, and how hard it is thinking.

Claude Code hands this script the session state as JSON on stdin and prints
whatever comes back under the prompt. Everything here is defensive: a status
line that raises leaves the prompt bare, and an unknown field is better left
out than guessed at.

The raw payload is kept in ~/.claude/statusline-last.json so the fields this
version of the CLI actually sends can be read back rather than assumed.
"""
import json
import os
import subprocess
import sys
import time

HOME = os.path.expanduser("~/.claude")

# 256-colour codes, chosen against the dark theme: the model is the thing
# being looked for, so it is the only bright thing on the line.
DIM = "\033[38;5;245m"
BRIGHT = "\033[38;5;252m"
ACCENT = "\033[38;5;73m"      # teal: the model
EFFORT = "\033[38;5;179m"     # amber: how hard it is thinking
WARN = "\033[38;5;174m"
OFF = "\033[0m"

# nec plus badge by level: the tool cuts harder as the level rises. "off" gets none.
NEC_PLUS_BADGES = {"lite": "🪶  nec plus levis", "full": "✂️  nec plus", "ultra": "🪓  nec plus ultra"}

# Plan limits as the CLI names them, with the label each gets on the line.
RATE_LIMITS = (("five_hour", "5 ore"), ("seven_day", "settimana"))
DAYS = ("lun", "mar", "mer", "gio", "ven", "sab", "dom")


def branch(cwd):
    """The current branch and whether anything is uncommitted, or None."""
    try:
        name = subprocess.run(["git", "-C", cwd, "branch", "--show-current"],
                              capture_output=True, text=True, timeout=1)
        if name.returncode != 0 or not name.stdout.strip():
            return None
        # Without the flag status rewrites the index under index.lock, and a
        # commit landing at the same moment fails.
        dirty = subprocess.run(["git", "--no-optional-locks", "-C", cwd, "status", "--porcelain"],
                               capture_output=True, text=True, timeout=1)
        return name.stdout.strip() + ("*" if dirty.stdout.strip() else "")
    except (OSError, subprocess.SubprocessError):
        return None


def main():
    try:
        raw = sys.stdin.read()
        state = json.loads(raw or "{}")
    except ValueError:
        return 0
    try:
        with open(os.path.join(HOME, "statusline-last.json"), "w") as handle:
            handle.write(raw)
    except OSError:
        pass

    parts = []

    model = state.get("model") or {}
    name = model.get("display_name") or model.get("id") or "?"
    parts.append(f"{ACCENT}◆ {name}{OFF}")

    level = ((state.get("effort") or {}).get("level")
             or (model.get("effort") or {}).get("level"))
    if level:
        parts.append(f"{EFFORT}effort {level}{OFF}")
    if state.get("fast_mode"):
        parts.append(f"{EFFORT}fast{OFF}")
    if (state.get("thinking") or {}).get("enabled") is False:
        parts.append(f"{DIM}no thinking{OFF}")

    workspace = state.get("workspace") or {}
    cwd = workspace.get("current_dir") or state.get("cwd") or os.getcwd()
    parts.append(f"{BRIGHT}{os.path.basename(cwd.rstrip('/')) or cwd}{OFF}")

    here = branch(cwd)
    if here:
        parts.append(f"{DIM}{here}{OFF}")

    # How full the window is. On a million-token model the absolute figure
    # says nothing at a glance and the share says everything.
    window = state.get("context_window") or {}
    used = window.get("used_percentage")
    if used is not None:
        colour = WARN if used >= 85 else (EFFORT if used >= 60 else DIM)
        parts.append(f"{colour}ctx {int(used)}%{OFF}")

    style = (state.get("output_style") or {}).get("name")
    if style and style != "default":
        parts.append(f"{DIM}{style}{OFF}")
    if state.get("exceeds_200k_tokens"):
        parts.append(f"{WARN}200k+{OFF}")

    # Second line: how much work is left, and how Claude is working.
    below = []

    # What is left of each plan limit and when it starts over: the share left,
    # not used, because the question is how much work still fits. A window
    # already past its reset is stale, so it is left out.
    limits = state.get("rate_limits") or {}
    for key, label in RATE_LIMITS:
        limit = limits.get(key) or {}
        spent, resets = limit.get("used_percentage"), limit.get("resets_at")
        if spent is None or not resets or resets <= time.time():
            continue
        left = max(0, 100 - int(spent))
        colour = WARN if left <= 10 else (EFFORT if left <= 30 else DIM)
        when = time.localtime(resets)
        at = time.strftime("%H:%M", when)
        if key == "seven_day":
            at = f"{DAYS[when.tm_wday]} {at}"
        below.append(f"{colour}{label} resta {left}% → {at}{OFF}")

    # Modes switched on by SessionStart hooks, each leaving a flag file.
    try:
        with open(os.path.join(HOME, ".nec-plus-active")) as handle:
            badge = NEC_PLUS_BADGES.get(handle.readline().strip() or "full")
        if badge:
            below.append(f"\033[38;5;108m{badge}{OFF}")
    except OSError:
        pass
    if os.path.exists(os.path.join(HOME, ".sine-more-active")):
        below.append(f"{WARN}⚡ sine mora{OFF}")

    # Each printed line is its own row under the prompt.
    print("\n".join(f"{DIM} · {OFF}".join(line) for line in (parts, below) if line))
    return 0


if __name__ == "__main__":
    sys.exit(main())
