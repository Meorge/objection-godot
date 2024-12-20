class_name SoundPlayer
extends Node

static var instance: SoundPlayer

func _enter_tree():
	instance = self

func play_sound(path: String):
	var new_player = AudioStreamPlayer.new()
	new_player.stream = load(path)
	new_player.finished.connect(new_player.queue_free)
	add_child(new_player)
	new_player.play()
