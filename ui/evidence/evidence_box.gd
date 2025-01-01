extends AnimatedSprite2D

@onready var evidence_holder: TextureRect = $EvidenceHolder
@onready var sound: AudioStreamPlayer = $InSound

func _ready():
	animation = &"in"
	frame = 0
	evidence_holder.visible = false

func _handle_evidence(args: Dictionary):
	var action = args.get("action", "show")

	if action == "show":
		if not args.has("res"):
			Utils.print_error("No resource provided for the evidence command")
			return
		show_evidence(args["res"])
	elif action == "hide":
		hide_evidence()
	elif action == "hide_immediate":
		evidence_holder.visible = false
		visible = false
	else:
		Utils.print_error("Unknown action \"%s\" for the evidence command")

func load_evidence_from_args(texture_path: String):
	if (texture_path.begins_with("res://")):
		return load(texture_path)
	else:
		var img := Image.load_from_file(texture_path)
		return ImageTexture.create_from_image(img)

func show_evidence(texture_path: String):
	sound.play()
	evidence_holder.texture = load_evidence_from_args(texture_path)
	visible = true
	play(&"in")
	await animation_finished
	evidence_holder.visible = true


func hide_evidence():
	evidence_holder.visible = false
	sound.play()
	play(&"out")
	await animation_finished
	visible = false
