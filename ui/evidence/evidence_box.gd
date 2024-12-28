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
			print_rich("[color=red]ERROR: No resource provided for the evidence command")
			return
		show_evidence(args["res"])
	elif action == "hide":
		hide_evidence()
	elif action == "hide_immediate":
		evidence_holder.visible = false
		visible = false
	else:
		print_rich("[color=red]ERROR: Unknown action \"%s\" for the evidence command")


func show_evidence(texture_path: String):
	sound.play()
	evidence_holder.texture = load(texture_path)
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
