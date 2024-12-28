class_name NextArrow
extends Control


@onready var animation_player: AnimationPlayer = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	ScriptManager.register_handler("arrow", _handle_arrow)
	visible = false
	animation_player.stop()


func _handle_arrow(args: Dictionary):
	var action: String = args.get("action", "show")
	match action:
		"show":
			visible = true
			animation_player.play()
		"hide":
			visible = false
			animation_player.stop()
		_:
			print_rich("[color=red]ERROR: Invalid action \"%s\" for arrow command" % action)
