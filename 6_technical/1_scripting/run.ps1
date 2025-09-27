
function runMain
{
  & ./renderBlender.ps1
  & ./aeScript.ps1
  Write-Host "Waiting for After Effects to finish..."
  while (Get-Process -Name "AfterFX" -ErrorAction SilentlyContinue)
  {
    Start-Sleep -Seconds 1
  }
  Write-Host "After Effects closed. Starting next render..."
  & ./clear_mailout.ps1
  & ./renderAfterFX.ps1
  & ./config_folders.ps1
}

runMain
