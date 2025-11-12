#!/bin/bash
set -euo pipefail

cd /config
git config --global --add safe.directory /config || true
git config --global user.name "Derryn Rizzalli"
git config --global user.email "rizzalli@users.noreply.github.com"

# Try to abort any in-progress rebase to avoid blocking
if [ -d ".git/rebase-merge" ] || [ -d ".git/rebase-apply" ]; then
  echo "[WARN] Found in-progress rebase; attempting git rebase --abort" >&2 || true
  git rebase --abort || true
fi

# Determine branch; fall back to main if detached
BRANCH="$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo main)"
if [ -z "$BRANCH" ] || [ "$BRANCH" = "HEAD" ]; then
  echo "[WARN] Detached HEAD or unknown branch; using 'main' fallback" >&2
  BRANCH="main"
fi

echo "---- $(date -Iseconds) START git_sync (branch: ${BRANCH}) ----"

if [[ -n "$(git status --porcelain)" ]]; then
  echo "[INFO] Changes detected: creating commit"
  git add . || true
  git commit -m "HA auto-sync: $(date -u '+%Y-%m-%d %H:%M:%S UTC')" || true
fi

echo "[INFO] git fetch"
git fetch origin || true

echo "[INFO] git pull --rebase origin ${BRANCH}"
git pull --rebase origin "$BRANCH" || true

echo "[INFO] git push origin ${BRANCH}"
git push origin "$BRANCH" || true

echo "---- $(date -Iseconds) END git_sync ----"

exit 0
