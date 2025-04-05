# PowerShell Script: CLI Rendering Automation
$projectBasePath = "X:\LocalProduction\cg-production"
$projectName = "INSERT-PROJECT-NAME"
$projectNameIsLowerCase = $projectName.ToLower()
$projectSceneName = "produciton-render-master"
$aeExtension = "jpeg"
$aeFile = "ae-post-production.aep"
$aeJsxScript = "$projectBasePath\6_technical\1_scripting\cli-rendering-ae.jsx"
$aePath = "$projectBasePath\4_images\2_post_production\after_effects"
$aeOutputFormat = "jpg-agx"
$aeOutputPath = "$projectBasePath\1_docs\5_mail_out\0000-00-00-00-00-00"
$blenderFile = "$projectBasePath\3_blender"
$blenderExtension = ".blend"
$blenderOutputPath = "$projectBasePath\4_images\1_raw\1_stills"
$blenderPyScript = "$projectBasePath\6_technical\1_scripting\cli-rendering-blender.py" 
$blenderRenderFormat = "OPEN_EXR"

$blenderTasks = @(
     @{ file = "${projectSceneName}${blenderExtension}"; renderPath = "$blenderOutputPath\${projectSceneName}";
     fileFormat = $blenderRenderFormat; start = 1; end = 10 }
)

$aeTasks = @(
    @{ comp = "${projectSceneName}"; start = 0; end = 9; output = "${projectSceneName}${aeExtension}" }
)

# Start Rendering
Write-Output "Rendering project: $projectName"

foreach ($task in $blenderTasks) {
   blender42 -b "$blenderFile\$($task.file)" --python $blenderPyScript -o $($task.renderPath) -F $($task.fileFormat) -s $($task.start) -e $($task.end) -a
}

foreach ($task in $aeTasks) {
    aerender -project "$aePath\$aeFile" -comp "$($task.comp)" -s $($task.start) -e $($task.end) -output "$aeOutputPath\$($task.output)" -OMtemplate "$aeOutputFormat"
    #aerender -s "$aeJsxScript" -project "$aePath\$aeFile" -comp "$($task.comp)" -s $($task.start) -e $($task.end) -output "$aeOutputPath\$($task.output)" -OMtemplate "$aeOutputFormat"
}

Write-Output "$projectName rendering complete."
