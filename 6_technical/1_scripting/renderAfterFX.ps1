$projectBasePath = "X:\LocalProduction\cg-production"
$aeProjectPath   = "$projectBasePath\4_images\2_post_production\after_effects"
$aeFile          = "ae-post-production.aep"
$aeisOutput    = "$projectBasePath\1_docs\5_mail_out\0000-00-00-00-00-00"
$aeOutputFormat  = "jpg-agx"
$aeRenderConfig  = "$projectBasePath\6_technical\1_scripting\renderConfigAfterFX.psd1"
# $aeJsxScript = "$projectBasePath\6_technical\1_scripting\cli-rendering-ae.jsx"

$aeTasks = @()
try
{
  $aeTasks = Import-PowerShellDataFile -Path $aeRenderConfig
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
    # Render-AfterEffectsComp -isComp $task.comp ` -isS $task.start ` -isE $task.end ` -isOutput $task.output -isOmTemplate  "$aeOutputFormat"
    Render-AfterEffectsComp -isComp "$($task.comp)" -isS $($task.start) -isE $($task.end) -isOutput "$($task.output)" -isOmTemplate  "$aeOutputFormat"
    # aerender -s "$aeJsxScript" -project "$aePath\$aeFile" -comp "$($task.comp)" -s $($task.start) -e $($task.end) -output "$aeOutputPath\$($task.output)" -OMtemplate "$aeOutputFormat"
    # aerender -project "$aePath\$aeFile" -comp "$($task.comp)" -s $($task.start) -e $($task.end) -output "$aeisOutput\$($task.output)" -OMtemplate "$aeOutputFormat"
  }
}

Render-AllAfterEffectsComps
