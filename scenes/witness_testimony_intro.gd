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

	ScriptManager.register_handler("bigtext", _handle_big_text)

func _handle_big_text(args: Dictionary):
	var color: Color
	if ScriptManager.colors.has(args.get("color", "aa-witintro-blue")):
		color = ScriptManager.colors[args["color"]]
	else:
		color = Color.from_string(args["color"], ScriptManager.colors["aa-witintro-blue"])

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
	tw.tween_property(top_label, "position:x", top_label_dest_x, 14.0 / 60.0)
	tw.parallel().tween_property(bottom_label, "position:x", bottom_label_dest_x, 14.0 / 60.0)
	tw.tween_callback(func(): flash_overlay.color.a = 1.0)
	tw.tween_interval(2.0 / 60.0)
	tw.tween_property(flash_overlay, "color:a", 0.0, 8.0 / 60.0)
	tw.tween_interval(1.5)

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
