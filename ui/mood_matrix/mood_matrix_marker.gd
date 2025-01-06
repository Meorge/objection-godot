class_name MoodMatrixMarker
extends Control

@export var marker_type: MoodMatrixMarkerType

@onready var _pulse: MoodMatrixPulse = %Pulse
@onready var _border: TextureRect = %MarkerBorder
@onready var _background: TextureRect = %MarkerBackground
@onready var _face: TextureRect = %Face
@onready var _thinking_anim: AnimatedSprite2D = %ThinkingAnimation

# Called when the node enters the scene tree for the first time.
func _ready():
	_face.texture = marker_type.face_texture
	_face.modulate = marker_type.face_color_inactive
	_pulse.modulate = marker_type.background_color_active
	set_inactive()

func set_thinking():
	_face.visible = false
	_thinking_anim.visible = true

	_background.modulate = Color.BLACK

func set_inactive():
	_face.visible = true
	_thinking_anim.visible = false

	_face.modulate = marker_type.face_color_inactive
	_background.modulate = Color.BLACK

func set_active():
	_face.visible = true
	_thinking_anim.visible = false

	_face.modulate = marker_type.face_color_active
	_background.modulate = marker_type.background_color_active
	_pulse.modulate = marker_type.background_color_active

var tw: Tween = null

func do_pulse_anim():
	if tw:
		tw.kill()
	
	_pulse.sound_player.stream = marker_type.pulse_sound

	tw = create_tween()
	tw.tween_callback(_pulse.animate_pulse)
	tw.tween_property(self, "scale", Vector2.ONE * 1.1, 0.25)
	tw.tween_callback(func(): scale = Vector2.ONE)
	tw.tween_property(self, "scale", Vector2.ONE * 1.25, 0.75)
	tw.tween_callback(func(): scale = Vector2.ONE)
	return tw

func do_intro_pulse_anim():
	if tw:
		tw.kill()
	
	_pulse.sound_player.stream = null

	tw = create_tween()
	tw.tween_callback(_pulse.animate_pulse)
	tw.tween_callback(func(): scale = Vector2.ONE * 1.5)
	tw.tween_property(self, "scale", Vector2.ONE * 0.95, 0.9)
	tw.tween_property(self, "scale", Vector2.ONE, 0.1)
	return tw