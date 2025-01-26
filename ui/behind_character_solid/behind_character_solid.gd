extends ColorRect

var tw: Tween = null

# Called when the node enters the scene tree for the first time.
func _ready():
	ScriptManager.register_handler("bg.set_visible", _handle_bg_set_visible)
	ScriptManager.register_handler("bg.set_color", _handle_bg_set_color)
	ScriptManager.register_handler("bg.animate_in", _handle_bg_animate_in)
	ScriptManager.register_handler("bg.animate_out",_handle_bg_animate_out)
	color.a = 0.0

func _handle_bg_set_visible(args: Dictionary):
	if tw: tw.kill()
	var to_set: String = args.get("value", "true")
	if to_set == "false":
		color.a = 0.0
	elif to_set == "true":
		color.a = 1.0

func _handle_bg_set_color(args: Dictionary):
	if "value" not in args:
		Utils.print_error("value argument not provided for bg.set_color")
		return
	var existing_a = color.a
	color = Utils.get_color_from_string(args["value"], Color.BLACK)
	color.a = existing_a

func _handle_bg_animate_in(args: Dictionary):
	if tw: tw.kill()
	tw = create_tween()
	var duration: float = float(args.get("duration", 0.5))
	tw.tween_property(self, "color:a", 1.0, duration)

func _handle_bg_animate_out(args: Dictionary):
	if tw: tw.kill()
	tw = create_tween()
	var duration: float = float(args.get("duration", 0.5))
	tw.tween_property(self, "color:a", 0.0, duration)
