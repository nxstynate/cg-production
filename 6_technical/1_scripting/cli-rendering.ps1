# PowerShell Script: CLI Rendering Automation

# Define base project path (Update this for each new project)
$projectBasePath = "X:\LocalProduction\cg-production"

# Define After Effects paths
$aePath = "$projectBasePath\4_images\2_post_production\after_effects"
$aeFile = "ae-post-production.aep"
$aeJsxScript = "$projectBasePath\6_technical\1_scripting\cli-rendering-ae.jsx"
$aeExtension = "jpeg"
$aeOutputPath = "$projectBasePath\1_docs\5_mail_out\0000-00-00-00-00-00"
$aeOutputFormat = "jpg-agx"

# Define Blender paths
$blenderFile = "$projectBasePath\3_blender"
$blenderOutputPath = "$projectBasePath\4_images\1_raw\1_stills"
$blenderRenderFormat = "OPEN_EXR"
$blenderExtension = ".blend"
$blenderPyScript = "$projectBasePath\6_technical\1_scripting\cli-rendering-blender.py" 

# Define project name
$projectName = "INSERT-PROJECT-NAME"
$projectNameIsLowerCase = $projectName.ToLower()
$projectSceneName = "insert-scene-name"

# Blender Rendering Tasks (Update for each project)
$blenderTasks = @(
     @{ 
     file = "${projectNameIsLowerCase}-${projectSceneName}${blenderExtension}";
     renderPath = "$blenderOutputPath\${projectNameIsLowerCase}-${projectSceneName}";
     fileFormat = $blenderRenderFormat;
     start = 1;
     end = 10
     }
)

# After Effects Rendering Tasks (Update for each project)
$aeTasks = @(
    @{ 
      comp = "${projectNameIsLowerCase}-${projectSceneName}";
      start = 0;
      end = 9;
      output = "${projectNameIsLowerCase}-${projectSceneName}${aeExtension}" 
      }
)

# Start Rendering
Write-Output "Rendering project: $projectName"

# Run Blender renders
foreach ($task in $blenderTasks) {
   blender42 -b "$blenderFile\$($task.file)" -P $blenderPyScript -o $($task.renderPath) -F $($task.fileFormat) -s $($task.start) -e $($task.end) -a 
}

# Run After Effects renders
foreach ($task in $aeTasks) {
    aerender -s "$aeJsxScript" -project "$aePath\$aeFile" -comp "$($task.comp)" -s $($task.start) -e $($task.end) -output "$aeOutputPath\$($task.output)" -OMtemplate "$aeOutputFormat"
}

Write-Output "$projectName rendering complete."

