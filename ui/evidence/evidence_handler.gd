extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	ScriptManager.register_handler("evidence.show", _handle_evidence_show)
	ScriptManager.register_handler("evidence.hide", _handle_evidence_hide)

	ScriptManager.register_handler("evidence.hide_immediate", _handle_evidence_hide_immediate)

func _handle_evidence_show(args: Dictionary):
	var side = args.get("side", "right")
	if side == "left":
		$EvidenceLeft.show_evidence(args.get("res", ""))
	elif side == "right":
		$EvidenceRight.show_evidence(args.get("res", ""))
	else:
		Utils.print_error("Unknown side \"%s\" for evidence.show" % side)

func _handle_evidence_hide(args: Dictionary):
	var side = args.get("side", "right")
	if side == "left":
		$EvidenceLeft.hide_evidence()
	elif side == "right":
		$EvidenceRight.hide_evidence()
	else:
		Utils.print_error("Unknown side \"%s\" for evidence.hide" % side)

func _handle_evidence_hide_immediate(args: Dictionary):
	var side = args.get("side", "right")
	if side == "left":
		$EvidenceLeft.hide_evidence_immediate()
	elif side == "right":
		$EvidenceRight.hide_evidence_immediate()
	else:
		Utils.print_error("Unknown side \"%s\" for evidence.hide_immediate" % side)
	
