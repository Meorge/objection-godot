extends Control

var tw: Tween = null

const BOX_POS_OUT_Y = 76
const ANIM_TIME = 18.0 / 60.0

@onready var box_text: RichTextLabel = %DialogueLabel

func _ready():
	ScriptManager.register_handler("box", _handle_box)

func _handle_box(args: Dictionary):
	if args.has("set"):
		if args["set"] == "in":
			global_position = Vector2.ZERO
			box_text.visible = true
		elif args["set"] == "out":
			global_position = Vector2(0, BOX_POS_OUT_Y)
			box_text.visible = false
		else:
			print_rich("[color=red]ERROR: Unknown setting \"%s\" for setting box visibility (accepted values are \"in\" and \"out\")" % args["set"])
	elif args.has("anim"):
		if args["anim"] == "in":
			if tw: tw.kill()
			tw = create_tween()
			tw.tween_property(self, "global_position:y", 0, ANIM_TIME)
			tw.tween_callback(func(): box_text.visible = true)
		elif args["anim"] == "out":
			if tw: tw.kill()
			tw = create_tween()
			tw.tween_callback(func(): box_text.visible = false)
			tw.tween_property(self, "global_position:y", BOX_POS_OUT_Y, ANIM_TIME)
		else:
			print_rich("[color=red]ERROR: Unknown setting \"%s\" for setting box animation (accepted values are \"in\" and \"out\")" % args["set"])
