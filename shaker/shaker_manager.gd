class_name ShakerManager
extends Node

@onready var shakers: Array[Shaker] = [%CameraShaker, GameUI.instance.box_shaker]

static var instance: ShakerManager = null

func _enter_tree():
	instance = self

func _ready():
	ScriptManager.register_handler("shake", _handle_shake)
	
func _handle_shake(args: Dictionary):
	var this_magnitude = float(args.get("magnitude", "5.0"))
	var this_duration = float(args.get("duration", "0.3"))
	start_shake(this_magnitude, this_duration)

func start_shake(new_magnitude: float, duration: float):
	for shaker in shakers:
		shaker.start_shake(new_magnitude, duration)
