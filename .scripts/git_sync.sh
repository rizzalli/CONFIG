#!/bin/bash
set -euo pipefail

LOG_FILE="/config/.git_sync.log"

cd /config
git config --global --add safe.directory /config || true
git config --global user.name "Derryn Rizzalli"
git config --global user.email "rizzalli@users.noreply.github.com"

# Try to abort any in-progress rebase to avoid blocking
if [ -d ".git/rebase-merge" ] || [ -d ".git/rebase-apply" ]; then
  echo "[WARN] Found in-progress rebase; attempting git rebase --abort" >> "$LOG_FILE" 2>&1
  git rebase --abort >> "$LOG_FILE" 2>&1 || true
fi

# Determine branch; fall back to main if detached
BRANCH="$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo main)"
if [ -z "$BRANCH" ] || [ "$BRANCH" = "HEAD" ]; then
  echo "[WARN] Detached HEAD or unknown branch; using 'main' fallback" >> "$LOG_FILE"
  BRANCH="main"
fi

echo "---- $(date -Iseconds) START git_sync (branch: ${BRANCH}) ----" >> "$LOG_FILE"

run_and_log() {
  "$@" >> "$LOG_FILE" 2>&1
  return $?
}

if [[ -n "$(git status --porcelain)" ]]; then
  echo "[INFO] Changes detected: creating commit" >> "$LOG_FILE"
  git add . >> "$LOG_FILE" 2>&1 || true
  git commit -m "HA auto-sync: $(date -u '+%Y-%m-%d %H:%M:%S UTC')" >> "$LOG_FILE" 2>&1 || true
fi

echo "[INFO] git fetch" >> "$LOG_FILE"
run_and_log git fetch origin || true

echo "[INFO] git pull --rebase origin ${BRANCH}" >> "$LOG_FILE"
run_and_log git pull --rebase origin "$BRANCH" || true

echo "[INFO] git push origin ${BRANCH}" >> "$LOG_FILE"
run_and_log git push origin "$BRANCH" || true

echo "---- $(date -Iseconds) END git_sync ----" >> "$LOG_FILE"

exit 0
