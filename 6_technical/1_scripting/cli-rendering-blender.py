import bpy

def set_render_options():
    """Sets global render options."""
    scene = bpy.context.scene  # Define scene
    scene.render.use_motion_blur = False  # Example setting
    scene.cycles.samples = 2048

def set_gpu_device():
    """Ensures only the RTX 4080 is used for rendering and disables the Quadro T1000."""
    
    prefs = bpy.context.preferences.addons['cycles'].preferences
    prefs.compute_device_type = 'CUDA'  # Use 'OPTIX' if required

    # Disable all GPUs first
    for device in prefs.devices:
        device.use = False

    # Enable only the RTX 4080, disable Quadro T1000 explicitly
    for device in prefs.devices:
        if "RTX 4080" in device.name:
            device.use = True
        elif "Quadro T1000" in device.name:
            device.use = False  # Explicitly disable Quadro T1000

    print(f"Enabled GPU: {[d.name for d in prefs.devices if d.use]}")
    print(f"Disabled GPU: {[d.name for d in prefs.devices if not d.use]}")

def main():
    set_render_options()
    set_gpu_device()

if __name__ == "__main__":
    main()
