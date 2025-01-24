class_name MoodMatrixMarker
extends Control

@export var marker_type: MoodMatrixMarkerType

@onready var _pulse: MoodMatrixPulse = %Pulse
@onready var _border: TextureRect = %MarkerBorder
@onready var _background: TextureRect = %MarkerBackground
@onready var _overloaded_gradient: TextureRect = %MarkerOverloadedGradient
@onready var _face: TextureRect = %Face
@onready var _overloaded_face: TextureRect = %OverloadedFace
@onready var _overload_pulse: Node2D = %OverloadPulse
@onready var _thinking_anim: AnimatedSprite2D = %ThinkingAnimation

# Called when the node enters the scene tree for the first time.
func _ready():
	_face.texture = marker_type.face_texture
	_face.modulate = marker_type.face_color_inactive
	_overloaded_face.modulate = marker_type.face_color_inactive
	_pulse.modulate = marker_type.background_color_active
	_overloaded_gradient.modulate = marker_type.background_color_active
	_overloaded_gradient.visible = false
	_overload_pulse.modulate = marker_type.background_color_active
	set_inactive()

func set_thinking():
	if tw:
		tw.kill()
	_face.visible = false
	_overloaded_face.visible = false
	_thinking_anim.visible = true
	_overloaded_gradient.visible = false

	_background.modulate = Color.BLACK

func set_inactive():
	if tw:
		tw.kill()
	
	_face.visible = true
	_overloaded_face.visible = false
	_thinking_anim.visible = false
	_overloaded_gradient.visible = false

	_face.modulate = marker_type.face_color_inactive
	_background.modulate = Color.BLACK

func set_active():
	if tw:
		tw.kill()
	_face.visible = true
	_overloaded_face.visible = false
	_thinking_anim.visible = false
	_overloaded_gradient.visible = false

	_face.modulate = marker_type.face_color_active
	_background.modulate = marker_type.background_color_active
	_pulse.modulate = marker_type.background_color_active

func set_overloaded():
	_face.visible = false
	_overloaded_face.visible = true
	_thinking_anim.visible = false
	_overloaded_gradient.visible = true
	_background.modulate = Color.WHITE

var tw: Tween = null

var repeat_tw: Tween = null
func set_pulse(intensity: float, do_overload: bool = false):
	if repeat_tw:
		repeat_tw.kill()

	_pulse.intensity = intensity
	if intensity == 0:
		set_inactive()
		return
	elif intensity < 0:
		set_thinking()
		return

	
	set_active()
	repeat_tw = create_tween()
	repeat_tw.tween_callback(func(): do_pulse_anim(do_overload))
	repeat_tw.tween_interval(1.0)
	repeat_tw.set_loops(-1)

func do_pulse_anim(do_overload: bool = false):
	if tw:
		tw.kill()
	
	_pulse.sound_player.stream = marker_type.pulse_sound

	tw = create_tween()
	tw.tween_callback(_pulse.animate_overload_pulse if do_overload else _pulse.animate_pulse)
	tw.tween_property(%PrimaryScaler, "scale", Vector2.ONE * 1.1, 0.25)
	tw.tween_callback(func(): %PrimaryScaler.scale = Vector2.ONE)
	tw.tween_property(%PrimaryScaler, "scale", Vector2.ONE * 1.25, 0.75)
	tw.tween_callback(func(): %PrimaryScaler.scale = Vector2.ONE)
	return tw

func do_intro_pulse_anim():
	if tw:
		tw.kill()
	
	_pulse.sound_player.stream = null

	tw = create_tween()
	tw.tween_callback(_pulse.animate_pulse)
	tw.tween_callback(func(): %PrimaryScaler.scale = Vector2.ONE * 1.5)
	tw.tween_property(%PrimaryScaler, "scale", Vector2.ONE * 0.95, 0.9)
	tw.tween_property(%PrimaryScaler, "scale", Vector2.ONE, 0.1)
	return tw

func animate_overload():
	var overload_tw := create_tween()
	var pulse_tw = animate_overload_pulse()
	overload_tw.tween_callback(set_overloaded)
	overload_tw.tween_callback(animate_overload_waves)
	overload_tw.tween_property(%PrimaryScaler, "scale", Vector2.ONE * 1.5, 3.66).set_trans(Tween.TRANS_CIRC).set_ease(Tween.EASE_IN)
	overload_tw.tween_callback(set_active)
	overload_tw.tween_callback(func(): %PrimaryScaler.scale = Vector2.ONE * 1.6)
	overload_tw.tween_property(%PrimaryScaler, "scale", Vector2.ONE, 0.33)
	overload_tw.tween_callback(func(): pulse_tw.kill())

func animate_overload_pulse():
	var pulse_tw := create_tween()
	pulse_tw.tween_property(%SecondaryScaler, "scale", Vector2.ONE * 1.1, 0.1)
	pulse_tw.tween_property(%SecondaryScaler, "scale", Vector2.ONE, 0.1)
	pulse_tw.set_loops(-1)
	return pulse_tw

func animate_overload_waves():
	var x_scale_tween := create_tween()
	%OverloadPulse1.scale.x = 1.0
	%OverloadPulse2.scale.x = 1.0
	const WAVE_SCALE_DURATION = 0.33
	x_scale_tween.tween_property(%OverloadPulse1, "scale:x", 0.6, WAVE_SCALE_DURATION)
	x_scale_tween.parallel().tween_property(%OverloadPulse2, "scale:x", 0.6, WAVE_SCALE_DURATION)
	x_scale_tween.tween_property(%OverloadPulse1, "scale:x", 1.0, WAVE_SCALE_DURATION)
	x_scale_tween.parallel().tween_property(%OverloadPulse2, "scale:x", 1.0, WAVE_SCALE_DURATION)
	x_scale_tween.set_loops(-1)

	var overload_waves_tween := create_tween()
	%OverloadPulse.visible = true
	%OverloadPulse.scale = Vector2.ONE * 0.5
	overload_waves_tween.tween_property(%OverloadPulse, "scale", Vector2.ONE * 2.0, 3.66).set_trans(Tween.TRANS_CIRC).set_ease(Tween.EASE_IN)
	overload_waves_tween.parallel().tween_property(%OverloadPulse, "rotation", TAU * 4, 3.66)
	overload_waves_tween.tween_callback(x_scale_tween.kill)
	overload_waves_tween.tween_callback(func(): %OverloadPulse.visible = false)
