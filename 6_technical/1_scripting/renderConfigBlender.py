import bpy

ENABLED_GPU = "RTX 4080"
DISABLED_GPUS = ["Quadro T1000"]
LIGHTPATHS = 8
WIDTH = 1920
HEIGHT = 1080
PERCENT = 100
SAMPLES = 32

def set_render_options():
    """Sets global render options."""
    scene = bpy.context.scene
    paths = bpy.context.scene.cycles
    paths.max_bounces = LIGHTPATHS
    paths.diffuse_bounces = LIGHTPATHS
    paths.glossy_bounces = LIGHTPATHS
    paths.transparent_max_bounces = LIGHTPATHS
    paths.transmission_bounces = LIGHTPATHS
    paths.volume_bounces = LIGHTPATHS
    paths.use_fast_gi = False
    scene.render.engine = 'CYCLES'
    scene.render.resolution_x = WIDTH
    scene.render.resolution_y = HEIGHT
    scene.render.resolution_percentage = PERCENT  # 100% = full resolution
    scene.render.use_motion_blur = False
    scene.cycles.samples = SAMPLES
    scene.view_layers[0].cycles.use_denoising = True
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
    set_render_options()
    configure_gpu_devices(enabled=ENABLED_GPU, disabled=DISABLED_GPUS)

run()
