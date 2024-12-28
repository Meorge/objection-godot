extends MarginContainer

@onready var nametag_label: Label = %NametagLabel

# Called when the node enters the scene tree for the first time.
func _ready():
	ScriptManager.register_handler("nametag", _handle_nametag)
	visible = false

func _handle_nametag(args: Dictionary):
	if args.get("text", "") == "":
		visible = false
	else:
		visible = true
		nametag_label.text = args["text"]