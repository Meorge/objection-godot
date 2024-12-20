class_name ExclamationBubble
extends AnimatedSprite2D

static var instance: ExclamationBubble

func _enter_tree():
	instance = self

func play_exclamation(type: String):
	play(type)