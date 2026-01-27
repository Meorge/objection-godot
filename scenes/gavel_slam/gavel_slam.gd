class_name GavelSlam
extends Node2D

@onready var gavel_slam_sound: AudioStreamPlayer = %GavelSlamSound
@export var frames: Array[Sprite2D] = []

var delay_between_slams: float = 0.2
var finish_wait_time: float = 0.4

func _ready():
	ScriptManager.register_handler("gavel.animate", _handle_gavel_animate)

func _handle_gavel_animate(args: Dictionary):
	delay_between_slams = float(args.get("between", "0.17"))
	finish_wait_time = float(args.get("after", "0.766"))
	await play_slams(int(args.get("num", "1")))

func _display_frame(index: int):
	for frame in frames:
		frame.visible = false
	if index > 0:
		frames[index - 1].visible = true

func _slam_effect():
	gavel_slam_sound.play()
	if ShakerManager.instance:
		ShakerManager.instance.start_shake(3.0, 0.2)

func play_slams(num_slams: int):
	if num_slams == 1:
		await single_slam()
	else:
		await first_slam()
		for i in num_slams - 2:
			await middle_slam()
		await last_slam()

func single_slam():
	_display_frame(0)
	await get_tree().create_timer(0.3).timeout
	_display_frame(1)
	await get_tree().create_timer(0.04).timeout
	_display_frame(2)
	await get_tree().create_timer(0.04).timeout
	_display_frame(3)
	_slam_effect()
	await get_tree().create_timer(1.0).timeout

func first_slam():
	_display_frame(0)
	await get_tree().create_timer(0.3).timeout
	_display_frame(1)
	await  get_tree().create_timer(0.04).timeout
	_display_frame(3)
	_slam_effect()
	await get_tree().create_timer(delay_between_slams).timeout

func middle_slam():
	_display_frame(2)
	await get_tree().create_timer(0.04).timeout
	_display_frame(1)
	await get_tree().create_timer(0.17).timeout
	_display_frame(3)
	_slam_effect()
	await get_tree().create_timer(delay_between_slams).timeout

func last_slam():
	_display_frame(2)
	await get_tree().create_timer(0.04).timeout
	_display_frame(1)
	await get_tree().create_timer(0.17).timeout
	_display_frame(2)
	await get_tree().create_timer(0.04).timeout
	_display_frame(3)
	_slam_effect()
	await get_tree().create_timer(finish_wait_time).timeout
