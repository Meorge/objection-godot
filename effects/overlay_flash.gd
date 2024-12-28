extends ColorRect

var remaining: float = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	ScriptManager.register_handler("flash", _handle_flash)
	visible = false

func _handle_flash(args: Dictionary):
	remaining = float(args.get("duration", "0.15"))

func _process(delta):
	if remaining > 0:
		visible = true
		remaining -= delta
	else:
		visible = false


