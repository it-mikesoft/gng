## Static helpers to build SpriteFrames from our generated spritesheets.
extends Node

static func make_frames(tex_path: String, anim_name: String,
		frame_count: int, frame_w: int, frame_h: int,
		fps: float = 8.0, loop: bool = true) -> SpriteFrames:
	var tex : Texture2D = load(tex_path)
	var sf  := SpriteFrames.new()
	sf.add_animation(anim_name)
	sf.set_animation_speed(anim_name, fps)
	sf.set_animation_loop(anim_name, loop)
	for i in range(frame_count):
		var a := AtlasTexture.new()
		a.atlas  = tex
		a.region = Rect2(i * frame_w, 0, frame_w, frame_h)
		sf.add_frame(anim_name, a)
	return sf

static func add_anim(sf: SpriteFrames, tex_path: String, anim_name: String,
		frame_count: int, frame_w: int, frame_h: int,
		fps: float = 8.0, loop: bool = true) -> void:
	var tex : Texture2D = load(tex_path)
	sf.add_animation(anim_name)
	sf.set_animation_speed(anim_name, fps)
	sf.set_animation_loop(anim_name, loop)
	for i in range(frame_count):
		var a := AtlasTexture.new()
		a.atlas  = tex
		a.region = Rect2(i * frame_w, 0, frame_w, frame_h)
		sf.add_frame(anim_name, a)
