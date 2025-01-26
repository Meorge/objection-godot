extends Node2D

# Largely copied and pasted from the Perceive effect code.
# TODO: Move this code into a single reusable file.

var tw: Tween = null

# Called when the node enters the scene tree for the first time.
func _ready():
	ScriptManager.register_handler("mood_matrix.bg.set_visible", _handle_mood_matrix_bg_set_visible)
	ScriptManager.register_handler("mood_matrix.bg.animate_in", _handle_mood_matrix_bg_animate_in)
	ScriptManager.register_handler("mood_matrix.bg.animate_out", _handle_mood_matrix_bg_animate_out)
	ScriptManager.register_handler("mood_matrix.bg.set_time_scale", _handle_mood_matrix_bg_set_time_scale)
	modulate.a = 0.0

func _handle_mood_matrix_bg_set_visible(args: Dictionary):
	if tw: tw.kill()
	var to_set: String = args.get("value", "true")
	if to_set == "false":
		modulate.a = 0.0
	elif to_set == "true":
		modulate.a = 1.0

func _handle_mood_matrix_bg_animate_in(args: Dictionary):
	if tw: tw.kill()
	var duration: float = float(args.get("duration", 0.5))
	tw.tween_property(self, "modulate:a", 1.0, duration)

func _handle_mood_matrix_bg_animate_out(args: Dictionary):
	if tw: tw.kill()
	var duration: float = float(args.get("duration", 0.5))
	tw.tween_property(self, "modulate:a", 0.0, duration)

func _handle_mood_matrix_bg_set_time_scale(args: Dictionary):
	var new_time_scale := float(args.get("value", "1.0"))
	%Lines.time_scale = new_time_scale
	var particles: GPUParticles2D = %GPUParticles2D
	particles.speed_scale = new_time_scale
