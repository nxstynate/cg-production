. "$PSScriptRoot\globalVariables.ps1"

function RunAfterEffects
{
  $isPathToAEFile = "$aeProjectPath\$aeFile"
  $isJSXFile = "$scriptsRoot\$aeScript"

  afterfx -r $isJSXFile
  Start-Sleep -Seconds 30  # Wait for AE to finish
}

RunAfterEffects

