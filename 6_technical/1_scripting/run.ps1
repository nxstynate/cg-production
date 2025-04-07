
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
  & ./renderAfterFX.ps1
}

runMain
