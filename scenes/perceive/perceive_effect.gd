extends AnimatedSprite2D

var tw: Tween = null

# Called when the node enters the scene tree for the first time.
func _ready():
	ScriptManager.register_handler("perceive.set_visible", _handle_perceive_set_visible)
	ScriptManager.register_handler("perceive.animate_in", _handle_perceive_animate_in)
	ScriptManager.register_handler("perceive.animate_out", _handle_perceive_animate_out)
	modulate.a = 0.0

func _handle_perceive_set_visible(args: Dictionary):
	if tw: tw.kill()
	var to_set: String = args.get("value", "true")
	if to_set == "false":
		modulate.a = 0.0
	elif to_set == "true":
		modulate.a = 1.0

func _handle_perceive_animate_in(args: Dictionary):
	if tw: tw.kill()
	tw = create_tween()
	var duration: float = float(args.get("duration", 0.5))
	tw.tween_property(self, "modulate:a", 1.0, duration)

func _handle_perceive_animate_out(args: Dictionary):
	if tw: tw.kill()
	tw = create_tween()
	var duration: float = float(args.get("duration", 0.5))
	tw.tween_property(self, "modulate:a", 0.0, duration)
