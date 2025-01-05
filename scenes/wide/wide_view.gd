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
    ScriptManager.register_handler("wide.gallery", _handle_gallery)
    ScriptManager.register_handler("wide.character", _handle_court)

func _handle_gallery(args: Dictionary):
    if args.has("set"):
        var in_or_out: String = args["set"]
        if not ["in", "out"].has(in_or_out):
            Utils.print_error("Value \"%s\" is not valid for wide.gallery set argument (must be \"in\" or \"out\"")
            return
        _set_gallery_visibility(in_or_out == "in")

    if args.has("animate"):
        var true_or_false: String = args["animate"]
        if not ["true", "false"].has(true_or_false):
            Utils.print_error("Value \"%s\" is not valid for wide.gallery animate argument (must be \"true\" or \"false\")")
            return
        _set_gallery_animate(true_or_false == "true")
            

func _handle_court(args: Dictionary):
    var pos_str: String = args["pos"]  # TODO: print error if argument not present
    var sprite: Sprite2D = sprites[pos_str]  # TODO: print error if not found
    sprite.texture = Utils.load_texture(args["res"])
    
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