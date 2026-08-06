from pathlib import Path
from PIL import Image, ImageSequence, ImageDraw

src = Path(r'c:\git\ai-practitioner\ai-practitioner-blog\jekyll-src\assets\images\AI-Practitioner-logo-blink.gif')
im = Image.open(src)
frames = []
durations = []

# Replace the blinking orb region with the surrounding gear-center tone.
fill_box = (252, 166, 310, 224)
ring_box = (260, 174, 302, 216)

for frame in ImageSequence.Iterator(im):
    fr = frame.convert('RGBA')
    draw = ImageDraw.Draw(fr)
    draw.ellipse(fill_box, fill=(138, 176, 205, 255))
    draw.ellipse(ring_box, outline=(92, 123, 151, 255), width=4)
    frames.append(fr)
    durations.append(frame.info.get('duration', im.info.get('duration', 100)))

frames[0].save(
    src,
    save_all=True,
    append_images=frames[1:],
    duration=durations,
    loop=im.info.get('loop', 0),
    disposal=2,
)
print(f'updated {src}')
