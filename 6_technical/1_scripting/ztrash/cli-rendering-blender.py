import bpy

ENABLED_GPU = "RTX 4080"
DISABLED_GPUS = ["Quadro T1000"]

def set_render_options(scene):
    """Sets global render options."""
    scene.render.use_motion_blur = False
    scene.cycles.samples = 128
    scene.view_layers[0].cycles.use_denoising = True
    scene.use_persistent_data = False
    scene.render.use_placeholder = False
    scene.render.use_overwrite = True

def configure_gpu_devices(enabled, disabled):
    """Enables and disables specific GPU devices by name."""
    prefs = bpy.context.preferences.addons['cycles'].preferences
    prefs.compute_device_type = 'OPTIX'
    for device in prefs.devices:
        device.use = device.name == enabled and device.name not in disabled
    print(f"Enabled GPU: {[d.name for d in prefs.devices if d.use]}")
    print(f"Disabled GPU: {[d.name for d in prefs.devices if not d.use]}")

def run():
    scene = bpy.context.scene
    set_render_options(scene)
    configure_gpu_devices(enabled=ENABLED_GPU, disabled=DISABLED_GPUS)

run()
