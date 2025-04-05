$projectBasePath = "X:\LocalProduction\cg-production"
$aeProjectPath   = "$projectBasePath\4_images\2_post_production\after_effects"
$aeFile          = "ae-post-production.aep"
$aeOutputPath    = "$projectBasePath\1_docs\5_mail_out\0000-00-00-00-00-00"
$aeOutputFormat  = "jpg-agx"
$aeRenderConfig  = "$projectBasePath\6_technical\1_scripting\config\aeRenderConfig.psd1"
$aeJsxScript = "$projectBasePath\6_technical\1_scripting\cli-rendering-ae.jsx"

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
    [string]$compName,
    [int]$startFrame,
    [int]$endFrame,
    [string]$outputFileName
  )

  $outputPath = Join-Path $aeOutputPath $outputFileName

  Write-Host "🎞️  Rendering AE comp: $compName from $startFrame to $endFrame..."

  aerender -project "$aeProjectPath\$aeFile" `
    -comp "$compName" `
    -s $startFrame `
    -e $endFrame `
    -output "$outputPath" `
    -OMtemplate "$aeOutputFormat"
}

function Render-AllAfterEffectsComps
{
  foreach ($task in $aeTasks)
  {
    Render-AfterEffectsComp -compName $task.comp `
      -startFrame $task.start `
      -endFrame $task.end `
      -outputFileName $task.output
  }
}
