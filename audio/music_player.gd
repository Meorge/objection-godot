extends AudioStreamPlayer


# Called when the node enters the scene tree for the first time.
func _ready():
	ScriptManager.register_handler("music", _handle_music)


func _handle_music(args: Dictionary):
	var action = args.get("action", "play")
	if action == "play":
		stream = Utils.load_audio(args["res"])
		play()
	elif action == "stop":
		stop()
	else:
		Utils.print_error("Unknown action \"%s\" for the music command" % action)
