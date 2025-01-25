extends AudioStreamPlayer


# Called when the node enters the scene tree for the first time.
func _ready():
	ScriptManager.register_handler("music.play", _handle_music_play)
	ScriptManager.register_handler("music.stop", _handle_music_stop)

func _handle_music_play(args: Dictionary):
	if "res" in args and args["res"] != "":
		stream = Utils.load_audio(args["res"])
	play()

func _handle_music_stop(_args: Dictionary):
	stop()

