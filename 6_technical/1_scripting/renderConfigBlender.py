import bpy

ENABLED_GPU = "RTX 4080"
DISABLED_GPUS = ["Quadro T1000"]
DEVICE_TYPE = 'OPTIX'
LIGHTPATHS = 8
WIDTH = 1920
HEIGHT = 1080
PERCENT = 100
SAMPLES = 256
FRAME_RATE = 24
TRANSPARENT_BACKGROUND = False

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
    scene.render.fps = FRAME_RATE
    scene.render.fps_base = 1.0
    scene.render.film_transparent = TRANSPARENT_BACKGROUND

def configure_gpu_devices(enabled_name, disabled_names=None):
    """Enable a specific GPU by name and disable all others."""
    if disabled_names is None:
        disabled_names = []

    prefs = bpy.context.preferences.addons['cycles'].preferences

    # Set device type to 'CUDA' or 'OPTIX'
    if DEVICE_TYPE in {'CUDA', 'OPTIX'}:
        prefs.compute_device_type = DEVICE_TYPE
    else:
        raise ValueError(f"Unsupported device type: {DEVICE_TYPE}")

    # Ensure devices are detected
    bpy.context.preferences.addons['cycles'].preferences.get_devices()
    found_enabled = False

    for device in prefs.devices:
        if device.name == enabled_name:
            device.use = True
            found_enabled = True
        elif device.name in disabled_names:
            device.use = False
        else:
            device.use = False  # Disable anything not explicitly named

    if not found_enabled:
        print(f"[Warning] GPU '{enabled_name}' was not found among available devices.")

    # Summary printout
    enabled = [d.name for d in prefs.devices if d.use]
    disabled = [d.name for d in prefs.devices if not d.use]

    print(f"[Render Device: {DEVICE_TYPE}]")
    print(f"Enabled GPUs: {enabled}")
    print(f"Disabled GPUs: {disabled}")

def run():
    set_render_options()
    configure_gpu_devices(enabled=ENABLED_GPU, disabled=DISABLED_GPUS)

run()
