import bpy
import os
import shutil

def set_render_options():
    """Sets global render options."""
    scene = bpy.context.scene  # Define scene
    scene.render.use_motion_blur = False  # Example setting
    bpy.context.scene.cycles.samples = 2048

def set_gpu_device():
    """Ensures only the RTX 4080 is used for rendering and disables the Quadro T1000."""
    
    prefs = bpy.context.preferences.addons['cycles'].preferences
    prefs.compute_device_type = 'OPTIX'  # Use 'CUDA' if required

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
        
def get_frame_filepaths(output_path, ext, start, end):
    return [
        output_path.replace("####", str(frame).zfill(4)) + ext
        for frame in range(start, end + 1)
    ]

def backup_existing_frames(output_path, ext, start, end, backup_path):
    os.makedirs(backup_path, exist_ok=True)
    paths = get_frame_filepaths(output_path, ext, start, end)
    for path in paths:
        if os.path.exists(path):
            print(f"Backing up {path}")
            shutil.move(path, os.path.join(backup_path, os.path.basename(path)))

def restore_failed_frames(output_path, ext, start, end, backup_path):
    paths = get_frame_filepaths(output_path, ext, start, end)
    for path in paths:
        if not os.path.exists(path):
            filename = os.path.basename(path)
            backup_file = os.path.join(backup_path, filename)
            if os.path.exists(backup_file):
                print(f"Restoring missing frame: {filename}")
                shutil.move(backup_file, path)

def cleanup_backup_if_successful(output_path, ext, start, end, backup_path):
    paths = get_frame_filepaths(output_path, ext, start, end)
    all_exist = all(os.path.exists(path) for path in paths)
    if all_exist:
        print("All frames rendered successfully. Deleting backup.")
        shutil.rmtree(backup_path)
    else:
        print("Some frames failed to render. Attempting restore.")
        restore_failed_frames(output_path, ext, start, end, backup_path)

def handle_safe_render():
    scene = bpy.context.scene
    output_path = bpy.path.abspath(scene.render.filepath)
    ext = scene.render.file_extension.lower()
    start = scene.frame_start
    end = scene.frame_end
    backup_path = output_path.rstrip("\\/") + "_temp_backup"

    print("Render output path:", output_path)
    print("Current blend file:", bpy.data.filepath)

    try:
        backup_existing_frames(output_path, ext, start, end, backup_path)

        # 🔥 Start the render
        bpy.ops.render.render(animation=True)

        # Check and restore if necessary
        cleanup_backup_if_successful(output_path, ext, start, end, backup_path)
    finally:
        # ✅ Always clean up the backup folder if it exists
        if os.path.exists(backup_path):
            print("Final cleanup: Removing backup directory.")
            shutil.rmtree(backup_path, ignore_errors=True)

def run():
    set_render_options()
    set_gpu_device()
    handle_safe_render()

run()
