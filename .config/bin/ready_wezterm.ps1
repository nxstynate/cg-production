function LaunchPanes {
  $paneNames = @("RENDER", "NOTES", "DIRECTORY")

  # Assume ready_wezterm.ps1 already cd'ed into the project root
  $projectRoot = Get-Location

  # ---------- Resolve NOTES path ----------
  $notesRel  = Join-Path "1_docs\1_project_management" "notes.md"
  $notesFull = Resolve-Path -LiteralPath $notesRel -ErrorAction SilentlyContinue
  if (-not $notesFull) {
    # Open nvim with intended path, even if the file doesn't exist yet
    $notesFull = Join-Path $projectRoot $notesRel
  }

  # ---------- Resolve render path ----------
  $renderRel  = Join-Path "6_technical\1_scripting" "renderConfigBlender.py"
  $renderFull = Resolve-Path -LiteralPath $renderRel -ErrorAction SilentlyContinue
  if (-not $renderFull) {
    # Same behavior: open the intended path even if it doesn't exist yet
    $renderFull = Join-Path $projectRoot $renderRel
  }

  foreach ($paneName in $paneNames) {
    switch ($paneName) {
      "NOTES" {
        # Spawn pane running Neovim on notes.md
        wezterm cli spawn --cwd "$projectRoot" -- nvim "$notesFull"
      }
      "RENDER" {
        # Spawn pane running Neovim on renderConfigBlender.py
        wezterm cli spawn --cwd "$projectRoot" -- nvim "$renderFull"
      }
      "DIRECTORY" {
        # Spawn pane with a PowerShell prompt showing the directory contents
        # (runs inside the new pane; leaves the shell open)
        $dirCmd = "Set-Location '$projectRoot'; Clear-Host; Get-ChildItem"
        wezterm cli spawn --cwd "$projectRoot" -- pwsh -NoLogo -NoExit -Command $dirCmd
      }
      default {
        # Fallback: plain pane at project root
        wezterm cli spawn --cwd "$projectRoot"
      }
    }

    # After each spawn, set the tab title for the most recently created pane/tab
    $json        = wezterm cli list --format json | ConvertFrom-Json
    $latestPane  = $json | Sort-Object pane_id -Descending | Select-Object -First 1
    $tabId       = $latestPane.tab_id

    wezterm cli set-tab-title --tab-id $tabId $paneName
  }

  # If you intentionally over-spawned earlier, you can remove one:
  wezterm cli kill-pane
  # wezterm cli activate-tab --tab-index 0
}
LaunchPanes
