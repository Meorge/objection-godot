class_name NextArrow
extends Control


@onready var animation_player: AnimationPlayer = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	ScriptManager.register_handler("arrow.set_visible", _handle_arrow)
	visible = false
	animation_player.stop()


func _handle_arrow(args: Dictionary):
	var to_set: String = args.get("value", "true")
	if to_set == "false":
		visible = false
		animation_player.stop()
	elif to_set == "true":
		visible = true
		animation_player.play()
