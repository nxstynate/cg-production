import bpy
import sys
import os

def set_render_options(scene):
    """Sets global render options."""

    scene.render.engine = 'CYCLES'
    scene.cycles.samples = 256
    scene.cycles.preview_samples = 32
    scene.cycles.use_adaptive_sampling = True
    scene.cycles.adaptive_threshold = 0.01
    scene.cycles.denoiser = 'OPTIX'  # Or 'OPENIMAGE' or 'NONE'
    scene.view_layers["View Layer"].cycles.denoising_data_pass = True
    scene.render.film_transparent = True

    scene.cycles.max_bounces = 12
    scene.cycles.diffuse_bounces = 4
    scene.cycles.glossy_bounces = 4
    scene.cycles.transmission_bounces = 4
    scene.cycles.volume_bounces = 2

    scene.render.use_motion_blur = True
    scene.render.motion_blur_shutter = 0.5

    scene.render.filter_type = 'GAUSSIAN'
    scene.render.filter_size = 1.5

    scene.render.resolution_x = 1920
    scene.render.resolution_y = 1080
    scene.render.resolution_percentage = 100

    scene.frame_start = 1
    scene.frame_end = 250  # Example frame range

def render_scene(blend_file):
    """Renders the specified blend file."""

    try:
        bpy.ops.wm.open_mainfile(filepath=blend_file)
    except Exception as e:
        print(f"Error opening blend file: {e}")
        return

    scene = bpy.context.scene
    set_render_options(scene)

    directory = os.path.dirname(blend_file) + "\\render_output"
    if not os.path.exists(directory):
        os.makedirs(directory)
    scene.render.filepath = directory + "\\"  # Output relative to blend file

    print(f"Rendering {blend_file} to: {bpy.path.abspath(bpy.context.scene.render.filepath)}")

    try:
       # bpy.ops.render.render(write_still=True)  # For single frame render
        bpy.ops.render.render(animation=True)  # For animation render
        print(f"Rendering of {blend_file} complete.")
    except Exception as e:
        print(f"Error during rendering: {e}")


if __name__ == "__main__":
    if len(sys.argv) > 2:  # Check for blend file argument
        blend_file = sys.argv[2]
        render_scene(blend_file)
    else:
        print("Usage: blender -b <blend_file> -P <python_script>")
        print("Example: blender -b my_scene.blend -P render_blender.py")
