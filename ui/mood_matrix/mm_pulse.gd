class_name MoodMatrixPulse
extends Node2D

var tw: Tween = null
var intensity: float = 1.0

@onready var sound_player: AudioStreamPlayer = %PulseSound

# Called when the node enters the scene tree for the first time.
func _ready():
	%PulseNormal.visible = false
	%PulseOverload.visible = false

func animate_pulse():
	if tw:
		tw.kill()
	
	tw = create_tween()

	%PulseOverload.visible = false
	%PulseNormal.visible = true
	scale = Vector2.ONE * 0.4
	modulate.a = 1.0
	tw.tween_callback(func(): scale = Vector2.ONE * 0.4; modulate.a = 1.0)
	tw.tween_property(self, "scale", Vector2.ONE * 1.25 * intensity, 1.0)
	tw.parallel().tween_callback(sound_player.play).set_delay(0.2)
	tw.parallel().tween_property(self, "modulate:a", 0.0, 0.5).set_delay(0.5)
	tw.tween_callback(func(): %PulseNormal.visible = false)

func animate_overload_pulse():
	if tw:
		tw.kill()
	
	tw = create_tween()

	%PulseOverload.visible = true
	%PulseNormal.visible = false
	scale = Vector2.ONE
	modulate.a = 0.5

	tw.tween_callback(func(): scale = Vector2.ONE; modulate.a = 0.5)
	tw.tween_property(self, "scale", Vector2.ONE * 1.25, 0.66).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
	tw.parallel().tween_callback(sound_player.play).set_delay(0.2)
	tw.parallel().tween_property(self, "modulate:a", 0.0, 0.66)
	tw.tween_callback(func(): %PulseOverload.visible = false)

func stop_pulse():
	%PulseOverload.visible = false
	%PulseNormal.visible = false
	scale = Vector2.ONE * 0.4
	if tw:
		tw.kill()
