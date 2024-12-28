class_name VoiceBlipPlayer
extends AudioStreamPlayer

static var instance: VoiceBlipPlayer

## The amount of time to wait between blips.
@export var blip_delay := 0.05

var __should_play := true

enum Gender { MALE, FEMALE, TYPEWRITER }

@export var male_blip: AudioStream
@export var female_blip: AudioStream
@export var typewriter_blip: AudioStream

func _enter_tree():
	instance = self

func start_blips(gender: Gender):
	match gender:
		Gender.MALE:
			stream = male_blip
		Gender.FEMALE:
			stream = female_blip
		Gender.TYPEWRITER:
			stream = typewriter_blip
	__should_play = true

func play_blip():
	if not __should_play:
		return
	if playing:
		return
	play()

func stop_blips():
	__should_play = false
