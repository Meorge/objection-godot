extends MarginContainer

@onready var nametag_label: Label = %NametagLabel

# Called when the node enters the scene tree for the first time.
func _ready():
	ScriptManager.register_handler("nametag.set_text", _handle_nametag_set_text)
	visible = false

func _handle_nametag_set_text(args: Dictionary):
	if args.get("text", "") == "":
		visible = false
	else:
		visible = true
		nametag_label.text = args["text"]