# renderGlobals.ps1

# $projectBasePath = "X:\LocalProduction\cg-production"
$projectBasePath = (Resolve-Path "$PSScriptRoot\..\..").Path

# Shared paths
$renderConfigRoot = "$projectBasePath\6_technical\1_scripting"

# After Effects paths
$aeProjectPath    = "$projectBasePath\4_images\2_post_production\after_effects"
$aeFile           = "ae-post-production.aep"
$aeisOutput       = "$projectBasePath\1_docs\5_mail_out\0000-00-00-00-00-00"
$aeOutputFormat   = "jpg-agx"
$aeRenderConfig   = "$renderConfigRoot\sceneConfigAfterFX.psd1"

# Blender paths
$blenderRootPath     = "$projectBasePath\3_blender"
$blenderOutputPath   = "$projectBasePath\4_images\1_raw\1_stills"
$blenderPyScript     = "$renderConfigRoot\renderConfigBlender.py"
$blenderRenderFormat = "OPEN_EXR_MULTILAYER"
$blenderRenderConfig = "$renderConfigRoot\sceneConfigBlender.psd1"
