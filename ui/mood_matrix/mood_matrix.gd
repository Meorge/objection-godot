extends Control

@onready var _happy_marker: MoodMatrixMarker = %Happy
@onready var _sad_marker: MoodMatrixMarker = %Sad
@onready var _angry_marker: MoodMatrixMarker = %Angry
@onready var _surprised_marker: MoodMatrixMarker = %Surprised

func _ready():
	animate_markers_in()

func _handle_mood_matrix(args: Dictionary):
	pass

func set_markers_thinking():
	_happy_marker.set_thinking()
	_sad_marker.set_thinking()
	_angry_marker.set_thinking()
	_surprised_marker.set_thinking()

func set_markers_inactive():
	_happy_marker.set_inactive()
	_sad_marker.set_inactive()
	_angry_marker.set_inactive()
	_surprised_marker.set_inactive()

func set_markers_active():
	_happy_marker.set_active()
	_sad_marker.set_active()
	_angry_marker.set_active()
	_surprised_marker.set_active()

func do_intro_pulse():
	_happy_marker.do_intro_pulse_anim()
	_sad_marker.do_intro_pulse_anim()
	_angry_marker.do_intro_pulse_anim()
	_surprised_marker.do_intro_pulse_anim()

func animate_markers_in():
	$AnimationPlayer.play("markers_in")
	await $AnimationPlayer.animation_finished

	_happy_marker.set_active()

	while true:
		await _happy_marker.do_pulse_anim().finished
		# await get_tree().create_timer(0.1).timeout
	