class_name GameUI
extends CanvasLayer

static var instance: GameUI = self

@onready var dialogue_label: RichTextLabel = %DialogueLabel
@onready var nametag_label: Label = %NametagLabel
func _enter_tree():
	instance = self