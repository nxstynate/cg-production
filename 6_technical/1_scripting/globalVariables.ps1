# renderGlobals.ps1

# $projectBasePath = "X:\LocalProduction\cg-production"
$projectBasePath = (Resolve-Path "$PSScriptRoot\..\..").Path

# Shared paths
$scriptsRoot = "$projectBasePath\6_technical\1_scripting"

# Extensions:
$fileExtensionBlender = ".blend"
$fileExtensionsAE = "jpeg"

# After Effects paths
$aeProjectPath    = "$projectBasePath\4_images\2_post_production\after_effects"
$aeFile           = "ae-post-production.aep"
$aeisOutput       = "$projectBasePath\1_docs\5_mail_out\0000-00-00-00-00-00"
$aeOutputFormat   = "jpg-agx"
$aeRenderConfig   = "$scriptsRoot\sceneConfigAfterFX.psd1"
$aeScript = "main.jsx"

# Blender paths
$blenderRootPath     = "$projectBasePath\3_blender"
$blenderOutputPath   = "$projectBasePath\4_images\1_raw\1_stills"
$blenderPyScript     = "$scriptsRoot\renderConfigBlender.py" 
$blenderRenderFormat = "OPEN_EXR_MULTILAYER"
$blenderRenderConfig = "$scriptsRoot\sceneConfigBlender.psd1"

