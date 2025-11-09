#!/bin/bash
# Home Assistant maintenance script (manual run)
LOG="/config/maintenance.log"
DATE="$(date -u '+%Y-%m-%d %H:%M:%S UTC')"

{
  echo "===================="
  echo "Maintenance run at $DATE"
  echo "===================="

  cd /config || exit 1

  echo "- Checking /config structure"
  if [ -L /config ]; then
    echo "WARNING: /config is a symlink – unsupported."
  else
    echo "✔ /config is a real directory"
  fi

  echo "- Cleaning old HA log files"
  find /config -maxdepth 1 -type f -name "home-assistant.log.*" -exec rm -f {} \; \
    && echo "✔ Old log files removed"

  echo "- Ensuring permissions on /config"
  chmod 755 /config && echo "✔ Permissions OK"

  echo "- Verifying Git remote"
  git remote -v

  echo "- Checking auth (dry-run fetch)"
  if git fetch --dry-run >/dev/null 2>&1; then
    echo "✔ Git credentials OK"
  else
    echo "❌ ERROR: Git fetch failed – check token/remote"
  fi

  echo "- Committing any local changes"
  if [[ -n "$(git status --porcelain)" ]]; then
    git add .
    git commit -m "Auto-maintenance: $DATE"
    git push
    echo "✔ Changes pushed"
  else
    echo "✔ No changes to commit"
  fi

  echo "- Scan for suspicious temp dirs"
  for d in /config/config_* /config/homeassistant_* /config/*backup*; do
    [ -d "$d" ] && echo "WARNING: Found: $d"
  done

  echo "✔ Maintenance complete"
} >> "$LOG" 2>&1
