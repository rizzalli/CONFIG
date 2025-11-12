<#
Simple backup script for Home Assistant CONFIG repo.
Creates a timestamped ZIP of the repo root and copies selected folders to a destination folder.
Usage (PowerShell):
  cd <repo-root>
  .\tools\backup_config.ps1 -Destination 'C:\Users\rizza\OneDrive\HA-Backup'
#>
param(
  [string]$Destination = "C:\Users\rizza\OneDrive\HA-Backup",
  [string]$RepoRoot = "$(Get-Location)"
)

$ts = (Get-Date).ToString('yyyyMMdd_HHmmss')
$zipName = "CONFIG_backup_$ts.zip"
$zipPath = Join-Path -Path $Destination -ChildPath $zipName

# Ensure destination exists
if (-not (Test-Path -Path $Destination)) {
  New-Item -ItemType Directory -Path $Destination -Force | Out-Null
}

Write-Host "Creating ZIP archive: $zipPath"
Compress-Archive -Path "$RepoRoot\*" -DestinationPath $zipPath -Force

# Files/folders to copy
$items = @(
  'dashboards',
  'blueprints',
  'custom_components',
  'www',
  'automations.yaml',
  'scripts.yaml',
  'sensors.yaml',
  'secrets.yaml',
  'configuration.yaml',
  'utility_meter.yaml',
  'templates.yaml',
  '.scripts'
)

$copyDest = Join-Path -Path $Destination -ChildPath "CONFIG_files_$ts"
New-Item -ItemType Directory -Path $copyDest -Force | Out-Null

foreach ($item in $items) {
  $src = Join-Path -Path $RepoRoot -ChildPath $item
  if (Test-Path -Path $src) {
    Write-Host "Copying: $item"
    Copy-Item -Path $src -Destination $copyDest -Recurse -Force -ErrorAction SilentlyContinue
  } else {
    Write-Host "Skipped (not found): $item"
  }
}

# Create a lightweight git tag for the snapshot
$tag = "archived-$ts"
Write-Host "Creating git tag: $tag"
git -C $RepoRoot tag -a $tag -m "Archive before migration $ts"
Write-Host "Pushing tag to origin"
git -C $RepoRoot push origin $tag

Write-Host "Backup complete. Archive: $zipPath"
Write-Host "Files copied to: $copyDest"