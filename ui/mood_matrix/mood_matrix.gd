extends Control

@onready var _happy_marker: MoodMatrixMarker = %Happy
@onready var _sad_marker: MoodMatrixMarker = %Sad
@onready var _angry_marker: MoodMatrixMarker = %Angry
@onready var _surprised_marker: MoodMatrixMarker = %Surprised

func _ready():
	ScriptManager.register_handler("mood_matrix.ui", _handle_mood_matrix_ui)
	ScriptManager.register_handler("mood_matrix.emotion", _handle_mood_matrix_emotion)

	%Bootup.sound_should_be_played.connect(%BeginSound.play)
	%Bootup.white_flash.connect(func():
		var a = create_tween()
		%WhiteFlash.visible = true
		%WhiteFlash.color.a = 0.0
		a.tween_property(%WhiteFlash, "color:a", 1.0, 0.09)
	)

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
	%WhiteFlash.visible = false
	%WhiteFlash.color.a = 0.0
	$AnimationPlayer.play("markers_in")
	await $AnimationPlayer.animation_finished

func animate_bootup():
	var bootup_anim: AnimationPlayer = %Bootup.get_node("AnimationPlayer")
	bootup_anim.play("intro")
	await bootup_anim.animation_finished
	bootup_anim.play("RESET")

func _handle_mood_matrix_ui(args: Dictionary):
	## Options:
	## - animate="bootup"
	var animate = args.get("animate", "in")
	if animate == "bootup":
		await animate_bootup()
	if animate == "emotions_in":
		await animate_markers_in()

func _handle_mood_matrix_emotion(args: Dictionary):
	# <mood_matrix.emotion type="happy" intensity="3" />
	var markers = {
		"happy": _happy_marker,
		"sad": _sad_marker,
		"angry": _angry_marker,
		"surprised": _surprised_marker
	}
	
	var emotion_str = args.get("type", "")
	if emotion_str not in markers:
		Utils.print_error("Emotion \"%s\" doesn't exist in Mood Matrix" % emotion_str)
		return

	var marker = markers[emotion_str]
	var intensity = float(args.get("intensity", "1"))

	marker.set_pulse(intensity)
	
	
