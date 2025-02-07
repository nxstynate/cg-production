# PowerShell Script: CLI Rendering Automation

# Define base project path (Update this for each new project)
$projectBasePath = "X:\LocalProduction\cg-production"

# Define After Effects paths
$aePath = "$projectBasePath\4_images\2_post_production\after_effects"
$aeFile = "ae-post-production.aep"
$aeJsxScript = "$projectBasePath\6_technical\1_scripting\cli-rendering-ae.jsx"

# Create a new mail-out directory based on the current date/time
$aeOutputPath = "$projectBasePath\1_docs\5_mail_out\0000-00-00-00-00-00"
$aeOutputFormat = "jpg-agx"

# Define Blender paths
$blenderFile = "$projectBasePath\3_blender"
$blenderOutputPath = "$projectBasePath\4_images\1_raw\1_stills"
$blenderRenderFormat = "OPEN_EXR"

# Define project name
$projectName = "TEMPLATE_PROJECT_NAME"

# Blender Rendering Tasks (Update for each project)
$blenderTasks = @(
    # @{ file = "scene-01.blend"; renderPath = "$blenderOutputPath\scene-01"; fileFormat = $blenderRenderFormat; start = 1; end = 10 }
    # @{ file = "scene-02.blend"; renderPath = "$blenderOutputPath\scene-02"; fileFormat = $blenderRenderFormat; start = 1; end = 5 }
)

# After Effects Rendering Tasks (Update for each project)
$aeTasks = @(
    @{ comp = "comp-01"; start = 0; end = 9; output = "comp-01-.jpeg" }
)

# Start Rendering
Write-Output "Rendering project: $projectName"

# Run Blender renders
foreach ($task in $blenderTasks) {
    blender42 -b "$blenderFile\$($task.file)" -o $($task.renderPath) -F $($task.fileFormat) -s $($task.start) -e $($task.end) -a 
}

# Run After Effects renders
foreach ($task in $aeTasks) {
    aerender -s "$aeJsxScript" -project "$aePath\$aeFile" -comp "$($task.comp)" -s $($task.start) -e $($task.end) -output "$aeOutputPath\$($task.output)" -OMtemplate "$aeOutputFormat"
}

Write-Output "$projectName rendering complete."

