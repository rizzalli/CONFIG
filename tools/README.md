This folder contains helper scripts for repository maintenance.

backup_config.ps1
- Creates a timestamped zip archive of the repo and copies selected configuration folders/files to a backup destination.
- Usage (PowerShell):
  cd <repo-root>
  .\tools\backup_config.ps1 -Destination 'C:\path\to\backup\dir'

Notes:
- The script will create and push a lightweight git tag named `archived-<timestamp>`.
- Make sure you run this from a machine with `git` configured and network access to push tags to origin.
- Adjust the list of files/folders inside the script if you want to include/exclude more items.