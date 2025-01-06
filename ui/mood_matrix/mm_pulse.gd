class_name MoodMatrixPulse
extends Node2D

var tw: Tween = null

@onready var sound_player: AudioStreamPlayer = %PulseSound

# Called when the node enters the scene tree for the first time.
func _ready():
	visible = false

func animate_pulse():
	if tw:
		tw.kill()
	
	tw = create_tween()
	
	visible = true
	tw.tween_callback(func(): scale = Vector2.ONE * 0.4; modulate.a = 1.0)
	tw.tween_property(self, "scale", Vector2.ONE * 1.25, 1.0)
	tw.parallel().tween_callback(sound_player.play).set_delay(0.2)
	tw.parallel().tween_property(self, "modulate:a", 0.0, 0.5).set_delay(0.5)

func stop_pulse():
	visible = false
	if tw:
		tw.kill()