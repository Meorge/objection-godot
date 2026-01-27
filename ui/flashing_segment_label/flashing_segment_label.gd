class_name FlashingSegmentLabel
extends Label

## The time the label has been in its current state.
var t: float = 0.0

## The amount of time to spend with the label visible.
var _time_in: float = 1.0

## The amount of time to spend with the label invisible.
var _time_out: float = 0.5

# Called when the node enters the scene tree for the first time.
func _ready():
	text = ""
	ScriptManager.register_handler("segment_title.set", _handle_segment_title_set)

func _handle_segment_title_set(args: Dictionary):
	var new_text = args.get("text", "")

	var font_color := Utils.get_color_from_string(args.get("font_color", "white"), Color.WHITE)
	var font_outline_color := Utils.get_color_from_string(args.get("font_outline_color", "aa-flashtestimony"), Color.WHITE)

	var time_in = float(args.get("time_in", "1.433"))
	var time_out = float(args.get("time_out", "0.34"))

	_time_in = time_in
	_time_out = time_out

	t = time_in

	update_text(new_text, font_color, font_outline_color)

func _process(delta):
	t -= delta
	while t < 0.0:
		if visible:
			visible = false
			t += _time_out
		else:
			visible = true
			t += _time_in

func update_text(new_text: String, font_color: Color, font_outline_color: Color):
	text = new_text
	add_theme_color_override("font_color", font_color)
	add_theme_color_override("font_outline_color", font_outline_color)
