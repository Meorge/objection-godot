class_name SoundPlayer
extends Node

static var instance: SoundPlayer

func _enter_tree():
	instance = self

func _ready():
	ScriptManager.register_handler("sound", _handle_sound)

func _handle_sound(args: Dictionary):
	play_sound(args["res"])

func play_sound(path: String):
	var new_player = AudioStreamPlayer.new()
	new_player.stream = Utils.load_audio(path)
	new_player.finished.connect(new_player.queue_free)
	add_child(new_player)
	new_player.play()
