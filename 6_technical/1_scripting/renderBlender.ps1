$projectBasePath     = "X:\LocalProduction\cg-production"
$blenderRootPath     = "$projectBasePath\3_blender"
$blenderOutputPath   = "$projectBasePath\4_images\1_raw\1_stills"
$blenderPyScript     = "$projectBasePath\6_technical\1_scripting\renderConfigBlender.py" 
$blenderRenderFormat = "OPEN_EXR_MULTILAYER"
$renderConfigPath    = "$projectBasePath\6_technical\1_scripting\renderConfig.psd1"

$blenderTasks = Import-PowerShellDataFile -Path $renderConfigPath

function Render-BlenderScene
{
  param (
    [string]$blendFullPath,
    [string]$sceneName,
    [int]$startFrame,
    [int]$endFrame,
    [string]$fileFormat = $blenderRenderFormat
  )

  $renderOutPath = Join-Path $blenderOutputPath $sceneName

  Write-Host "Rendering $sceneName from $startFrame to $endFrame..."
  blender42 -b "$blendFullPath" `
    --factory-startup `
    --python "$blenderPyScript" `
    -o "$renderOutPath" `
    -F "$fileFormat" `
    -s $startFrame `
    -e $endFrame `
    -a
}

# Loop through each folder in the blender root (e.g., nikePortland, nikeChicago)
Get-ChildItem -Path $blenderRootPath -Directory | ForEach-Object {
  $projectFolder = $_.FullName
  $sceneName = $_.Name  # this will be used for output folder name
  $renderFolder = Join-Path $projectFolder "4_render"

  foreach ($task in $blenderTasks)
  {
    $blendFilePath = Join-Path $renderFolder $task.file

    if (Test-Path $blendFilePath)
    {
      Render-BlenderScene -blendFullPath $blendFilePath `
        -sceneName $sceneName `
        -startFrame $task.start `
        -endFrame $task.end
    } else
    {
      Write-Warning "Missing: $blendFilePath"
    }
  }
}
