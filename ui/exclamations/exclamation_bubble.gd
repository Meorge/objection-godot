class_name ExclamationBubble
extends AnimatedSprite2D

static var instance: ExclamationBubble

func _enter_tree():
	instance = self

func _ready():
	ScriptManager.register_handler("bubble", _handle_bubble)

func _handle_bubble(args: Dictionary):
	play_exclamation(args["type"])

func play_exclamation(type: String):
	play(type)