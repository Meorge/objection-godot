extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	ScriptManager.register_handler("evidence", _handle_evidence)

func _handle_evidence(args: Dictionary):
	var side = args.get("side", "right")
	if side == "left":
		$EvidenceLeft._handle_evidence(args)
		return
	elif side == "right":
		$EvidenceRight._handle_evidence(args)
	else:
		Utils.print_error("Unknown side \"%s\" for the evidence command" % side)
	
