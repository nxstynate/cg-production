. "$PSScriptRoot\globalVariables.ps1"

$aeTasks = @()
try
{
  $aeTasks = (Import-PowerShellDataFile -Path $aeRenderConfig).RenderJobs
} catch
{
  Write-Warning "⚠️ No AE render config found. Skipping After Effects rendering."
  return
}

function Render-AfterEffectsComp
{
  param (
    [string]$isComp,
    [int]$isS,
    [int]$isE,
    [string]$isOutput,
    [string]$isOmTemplate
  )

  $isOutput = Join-Path $aeisOutput $isOutput

  Write-Host "🎞️  Rendering AE comp: $isComp from $isS to $isE..."
  aerender -project "$aeProjectPath\$aeFile" `
    -comp "$isComp" `
    -s $isS `
    -e $isE `
    -output "$isOutput" `
    -OMtemplate "$isOmTemplate"
}

function Render-AllAfterEffectsComps
{
  foreach ($task in $aeTasks)
  {
    Render-AfterEffectsComp -isComp "$($task.comp)" -isS $($task.start) -isE $($task.end) -isOutput "$($task.output)" -isOmTemplate  "$aeOutputFormat"
  }
}

Render-AllAfterEffectsComps
