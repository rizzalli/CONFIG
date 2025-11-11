#!/bin/bash
set -euo pipefail

LOG_FILE="/config/.git_sync.log"

cd /config
git config --global --add safe.directory /config || true
git config --global user.name "Derryn Rizzalli"
git config --global user.email "rizzalli@users.noreply.github.com"
BRANCH="$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo main)"

echo "---- $(date -Iseconds) START git_sync (branch: ${BRANCH}) ----" >> "$LOG_FILE"

run_and_log() {
  # Run command, capture stdout/stderr, append to log. Return exit code.
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

# Keep exit status 0 so Home Assistant automation doesn't treat this as a failure
exit 0
