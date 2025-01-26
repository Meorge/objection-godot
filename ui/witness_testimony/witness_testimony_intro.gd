class_name WitnessTestimonyIntro
extends Control

static var instance: WitnessTestimonyIntro

## The blue color used for the "Witness Testimony" text.
const COLOR_BLUE := Color8(43, 24, 245)

## The red color used for the "Cross Examination" text.
const COLOR_RED := Color8(230, 51, 35)

@onready var top_label: Label = %TopLabel
@onready var bottom_label: Label = %BottomLabel
@onready var flash_overlay: ColorRect = %FlashOverlay
@onready var sound: AudioStreamPlayer = %WitnessTestimonyIntroSound

enum AnimateDirection {
	## Move the top text right, and the bottom text left.
	## Used for the "Witness Testimony" text.
	ANIMATE_LR,

	## Move the top text upwards, and the bottom text downwards.
	## Used for the "Cross Examination" text.
	ANIMATE_UD
}

func _enter_tree():
	instance = self
	
func _ready():
	top_label.visible = false
	bottom_label.visible = false
	set_shine_offset(10.0)

	ScriptManager.register_handler("big_title.play", _handle_big_title_play)

func _handle_big_title_play(args: Dictionary):
	var color := Utils.get_color_from_string(args.get("color", "aa-witintro-blue"), Color.BLACK)

	var dir = {
		"lr": WitnessTestimonyIntro.AnimateDirection.ANIMATE_LR,
		"ud": WitnessTestimonyIntro.AnimateDirection.ANIMATE_UD
	}.get(args["dir"], "lr")

	WitnessTestimonyIntro.instance.set_text(
		args["top"],
		args["bottom"],
		color,
		dir
	)

func set_text(top: String, bottom: String, color: Color, animate_direction: AnimateDirection):
	flash_overlay.color.a = 0.0
	top_label.text = top
	bottom_label.text = bottom

	top_label.visible = false
	bottom_label.visible = false
	set_shine_offset(10.0)

	top_label.add_theme_color_override("font_color", color)
	bottom_label.add_theme_color_override("font_color", color)

	await get_tree().process_frame
	var top_label_width = top_label.size.x
	var bottom_label_width = bottom_label.size.x

	top_label.visible = true
	bottom_label.visible = true

	var top_label_dest_x = 256 / 2 - top_label_width / 2
	var bottom_label_dest_x = 256 / 2 - bottom_label_width / 2


	top_label.position.x = 0 - top_label_width
	bottom_label.position.x = 256 + bottom_label_width

	# We need to figure out where to place them offscreen,
	# so that once we tween them in, they move at the intended speed.
	var tw := create_tween()
	tw.tween_callback(sound.play)
	tw.tween_interval(10.0 / 60.0)
	tw.tween_property(top_label, "position:x", top_label_dest_x, 14.0 / 60.0)
	tw.parallel().tween_property(bottom_label, "position:x", bottom_label_dest_x, 14.0 / 60.0)
	tw.tween_callback(func(): flash_overlay.color.a = 1.0)
	tw.tween_interval(2.0 / 60.0)
	tw.tween_property(flash_overlay, "color:a", 0.0, 8.0 / 60.0)

	# Gloss shine (stripe that moves across)
	tw.tween_method(set_shine_offset, 1.0, -1.0, 35.0 / 60.0)

	# Shine in to near-white.
	tw.tween_method(set_font_color, color, Color.WHITE, 9.0 / 60.0)

	# Hold on lit-up color.
	tw.tween_interval(4.0 / 60.0)

	# Return to original color.
	tw.tween_method(set_font_color, Color.WHITE, color, 9.0 / 60.0)

	# I counted 64 frames from the end of the shine to the beginning of the
	# shift out, but it doesn't line up with the sound effect.
	tw.tween_interval(25.0 / 60.0)

	match animate_direction:
		AnimateDirection.ANIMATE_LR:
			var top_label_out_x = 256
			var bottom_label_out_x = 0 - bottom_label_width
			tw.tween_property(top_label, "position:x", top_label_out_x, 20.0 / 60.0) \
				.set_ease(Tween.EASE_IN) \
				.set_trans(Tween.TRANS_SINE)
			tw.parallel().tween_property(bottom_label, "position:x", bottom_label_out_x, 20.0 / 60.0) \
				.set_ease(Tween.EASE_IN) \
				.set_trans(Tween.TRANS_SINE)
		AnimateDirection.ANIMATE_UD:
			var top_label_out_y = 0 - top_label.size.y
			var bottom_label_out_y = 192 + top_label.size.y
			tw.tween_property(top_label, "position:y", top_label_out_y, 20.0 / 60.0) \
				.set_ease(Tween.EASE_IN) \
				.set_trans(Tween.TRANS_SINE)
			tw.parallel().tween_property(bottom_label, "position:y", bottom_label_out_y, 20.0 / 60.0) \
				.set_ease(Tween.EASE_IN) \
				.set_trans(Tween.TRANS_SINE)

	tw.tween_callback(func(): top_label.visible = false; bottom_label.visible = false)

func set_font_color(color: Color):
	top_label.add_theme_color_override("font_color", color)
	bottom_label.add_theme_color_override("font_color", color)

func set_shine_offset(offset: float):
	var m: ShaderMaterial = top_label.material
	m.set_shader_parameter("x_offset", offset)

	m = bottom_label.material
	m.set_shader_parameter("x_offset", offset)