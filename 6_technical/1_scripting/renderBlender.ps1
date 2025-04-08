. "$PSScriptRoot\globalVariables.ps1"
$blenderTasks = Import-PowerShellDataFile -Path $blenderRenderConfig

function Clear-ExistingEXRs
{
  param (
    [string]$sceneName
  )
  $pattern = "$sceneName*.exr"
  $searchPath = $blenderOutputPath
  $exrFiles = Get-ChildItem -Path $searchPath -Filter $pattern -File -ErrorAction SilentlyContinue
  if ($exrFiles.Count -gt 0)
  {
    Write-Host "🧹 Deleting $($exrFiles.Count) EXR files matching '$pattern' in $searchPath..."
    $exrFiles | Remove-Item -Force
  } else
  {
    Write-Host "✅ No EXR files matching '$pattern' in $searchPath."
  }
}

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

  # 🧹 Delete old EXRs before rendering
  Clear-ExistingEXRs -sceneName $sceneName

  Write-Host "Rendering $sceneName from $startFrame to $endFrame..."
  blender42 -b "$blendFullPath" `
    --python "$blenderPyScript" `
    -o "$renderOutPath" `
    -F "$fileFormat" `
    -s $startFrame `
    -e $endFrame `
    -a
}

function RunMain
{
  Get-ChildItem -Path $blenderRootPath -Directory | ForEach-Object {
    $projectFolder = $_.FullName
    $sceneName     = $_.Name
    $renderFolder  = Join-Path $projectFolder "4_render"

    if ($blenderTasks.ContainsKey($sceneName))
    {
      $task = $blenderTasks[$sceneName]
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
    } else
    {
      Write-Warning "No config entry found for scene: $sceneName"
    }
  }
}

RunMain
