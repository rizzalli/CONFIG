#!/bin/bash
set -euo pipefail

cd /config
git config --global --add safe.directory /config || true
git config --global user.name "Derryn Rizzalli"
git config --global user.email "rizzalli@users.noreply.github.com"
BRANCH="$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo main)"

if [[ -n "$(git status --porcelain)" ]]; then
  git add .
  git commit -m "HA auto-sync: $(date -u '+%Y-%m-%d %H:%M:%S UTC')"
fi

git fetch origin || true
git pull --rebase origin "$BRANCH" || true
git push origin "$BRANCH"
