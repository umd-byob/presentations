from pymol import stored, cmd, selector, util
session = str(os.environ["SESSION"])
name = str(os.environ["SESSIONNAME"])
sessiondir = str(os.environ["SESSIONDIR"])
frames = int(os.environ["FRAMES"])
renderers = int(os.environ["RENDERERS"])
renderer_num = int(os.environ["PBS_ARRAYID"])
renderer_num = renderer_num - 1
frames_per_renderer = frames / renderers
start_frame = 1 + (renderer_num * frames_per_renderer)
end_frame = start_frame + frames_per_renderer 
print "render.py: session:" + session + " name: " + name
print "Session directory:" + sessiondir
print "This is renderer: " + str(renderer_num) + " Responsible for frames: " + str(start_frame) + "-" + str(end_frame)
os.chdir(sessiondir)
cmd.load(session)

### Movie commands go here.
cmd.set("cartoon_ring_mode", 3)
cmd.mset("1 x%i" %(frames))
util.mroll(1, frames, 1, 'y')
## End movie commands.

cmd.viewport("800","800")
cmd.set("hash_max", 255)
cmd.set("cache_frames", 0)
cmd.set("ray_trace_fog", 0)
cmd.set("ray_trace_frames", 1)
cmd.set("ray_shadows", 0)
cmd.set("antialias", 0)
cmd.set("auto_zoom", 0)
cmd.mclear
for frame in range(start_frame, end_frame):
    print "Rendering frame: " + str(frame)
    filename = name + str("%04d" % frame) + ".png"
    print "FILENAME: " + filename
    if not os.path.exists(filename):
        cmd.mpng(name, frame, frame)
    else:
        print str(filename) + " already exists."
    cmd.mclear
