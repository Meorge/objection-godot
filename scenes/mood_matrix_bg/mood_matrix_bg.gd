extends Node2D

# Largely copied and pasted from the Perceive effect code.
# TODO: Move this code into a single reusable file.

var tw: Tween = null

const IN_OR_OUT = ["in", "out", "auto"]

var _in: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	ScriptManager.register_handler("mood_matrix.bg", _handle_bg)
	modulate.a = 0.0
	_in = false

func _handle_bg(args: Dictionary):
	if tw: tw.kill()

	if args.has("set"):
		var in_or_out = args.get("set", "auto")
		if in_or_out not in IN_OR_OUT:
			Utils.print_error("Set value \"%s\" not valid for mood_matrix.bg command (must be \"in\" or \"out\")")
			return

		if in_or_out == "auto":
			if _in:
				in_or_out = "out"
			else:
				in_or_out = "in"
		
		if in_or_out == "in":
			modulate.a = 1.0
		else:
			modulate.a = 0.0

		_in = in_or_out == "in"

	elif args.has("fade"):
		var in_or_out = args.get("fade", "auto")
		if in_or_out not in IN_OR_OUT:
			Utils.print_error("Fade value \"%s\" not valid for mood_matrix.bg command (must be \"in\" or \"out\")")
			return

		if in_or_out == "auto":
			if _in:
				in_or_out = "out"
			else:
				in_or_out = "in"

		var duration = float(args.get("duration", "0.5"))
		
		tw = create_tween()
		tw.tween_property(self, "modulate:a", 1.0 if in_or_out == "in" else 0.0, duration)
		_in = in_or_out == "in"
