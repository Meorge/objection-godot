extends Control

@onready var animation_player: AnimationPlayer = %AnimationPlayer
@onready var label: Label = %ShutdownLabel

# Called when the node enters the scene tree for the first time.
func _ready():
	animation_player.play("RESET")
	ScriptManager.register_handler("mood_matrix.shutdown", _handle_mood_matrix_shutdown)

func _handle_mood_matrix_shutdown(args: Dictionary):
	var text: String = args.get("text", "BYE BYE")
	label.text = text
	animation_player.play("shutdown")
	await animation_player.animation_finished
