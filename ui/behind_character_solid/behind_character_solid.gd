extends ColorRect

var tw: Tween = null

var _in: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	ScriptManager.register_handler("bg", _handle_behind_character)
	_in = false
	color.a = 0.0

func _handle_behind_character(args: Dictionary):
	if tw: tw.kill()
	if args.has("set"):
		var to_set: String = args.get("set", "auto")
		if to_set == "auto":
			to_set = "in" if not _in else "out"
		
		if to_set == "out":
			_in = false
			color.a = 0.0
		elif to_set == "in":
			_in = true
			color.a = 1.0

	elif args.has("fade"):
		tw = create_tween()
		var to_set: String = args.get("fade", "auto")
		var duration: float = float(args.get("duration", 0.5))
		if to_set == "auto":
			to_set = "in" if not _in else "out"

		if to_set == "out":
			_in = false
			tw.tween_property(self, "color:a", 0.0, duration)
		elif to_set == "in":
			_in = true
			tw.tween_property(self, "color:a", 1.0, duration)

	if args.has("color"):
		var existing_a = color.a
		color = Utils.get_color_from_string(args["color"], Color.BLACK)
		color.a = existing_a
