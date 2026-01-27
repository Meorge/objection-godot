class_name BehindCourtView
extends Node2D

@onready var gallery_left: AnimatedSprite2D = %GalleryLeft
@onready var gallery_right: AnimatedSprite2D = %GalleryRight

@onready var sprites: Dictionary = {
	"prosecution": %Prosecution,
	"defense": %Defense,
	"witness": %Witness,
	"judge": %Judge
}

func _ready():
	ScriptManager.register_handler("wide.gallery.set_visible", _handle_wide_gallery_set_visible)
	ScriptManager.register_handler("wide.gallery.set_animated", _handle_wide_gallery_set_animated)
	ScriptManager.register_handler("wide.set_sprite", _handle_wide_set_sprite)

func _handle_wide_gallery_set_visible(args: Dictionary):
	var true_or_false: String = args["value"]
	if not ["true", "false"].has(true_or_false):
		Utils.print_error("Value \"%s\" is not valid for wide.gallery.set_visible (must be \"true\" or \"false\"")
		return
	_set_gallery_visibility(true_or_false == "true")

func _handle_wide_gallery_set_animated(args: Dictionary):
	var true_or_false: String = args["value"]
	if not ["true", "false"].has(true_or_false):
		Utils.print_error("Value \"%s\" is not valid for wide.gallery.set_animated (must be \"true\" or \"false\")")
		return
	_set_gallery_animate(true_or_false == "true")
			

func _handle_wide_set_sprite(args: Dictionary):
	if "pos" not in args:
		Utils.print_error("pos argument not provided for wide.set_sprite")
		return

	var pos_str: String = args["pos"]  # TODO: print error if argument not present
	var sprite: Sprite2D = sprites[pos_str]  # TODO: print error if not found

	if "res" in args and args["res"] != "":
		sprite.texture = Utils.load_texture(args["res"])
	else:
		sprite.texture = null
	
	if pos_str == "witness":
		%Witness.update_position()


func _set_gallery_visibility(v: bool):
	gallery_left.visible = v
	gallery_right.visible = v

func _set_gallery_animate(v: bool):
	if v:
		gallery_left.play()
		gallery_right.play()
	else:
		gallery_left.stop()
		gallery_right.stop()
