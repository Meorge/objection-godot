extends Control

var tw: Tween = null

const BOX_POS_OUT_Y = 76
const ANIM_TIME = 18.0 / 60.0

@onready var box_text: RichTextLabel = %DialogueLabel

func _ready():
	ScriptManager.register_handler("box.set_visible", _handle_box_set_visible)
	ScriptManager.register_handler("box.animate_in", _handle_box_animate_in)
	ScriptManager.register_handler("box.animate_out", _handle_box_animate_out)

func _handle_box_set_visible(args: Dictionary):
	if tw: tw.kill()
	var to_set: String = args.get("value", "true")
	if to_set == "false":
		global_position = Vector2(0, BOX_POS_OUT_Y)
		box_text.visible = false
	elif to_set == "true":
		global_position = Vector2.ZERO
		box_text.visible = true

func _handle_box_animate_in(_args: Dictionary):
	if tw: tw.kill()
	tw = create_tween()
	tw.tween_property(self, "global_position:y", 0, ANIM_TIME)
	tw.tween_callback(func(): box_text.visible = true)

func _handle_box_animate_out(_args: Dictionary):
	if tw: tw.kill()
	tw = create_tween()
	tw.tween_callback(func(): box_text.visible = false)
	tw.tween_property(self, "global_position:y", BOX_POS_OUT_Y, ANIM_TIME)
