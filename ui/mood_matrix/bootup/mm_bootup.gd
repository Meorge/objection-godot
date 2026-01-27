extends Control

signal sound_should_be_played
signal white_flash

func emit_play_sound_signal():
	sound_should_be_played.emit()

func emit_white_flash_signal():
	white_flash.emit()
