extends Control

@onready var background: TextureRect = %Background
@onready var title: Label = %Title
@onready var description: Label = %Description
@onready var thumbnail: TextureRect = %Thumbnail

@onready var in_jingle: AudioStreamPlayer = %InJingle
@onready var out_sound: AudioStreamPlayer = %OutSound

var tw: Tween = null

var _in: bool = false

func _ready():
	background.position.x = 256
	ScriptManager.register_handler("new_evidence.animate_in", _handle_new_evidence_animate_in)
	ScriptManager.register_handler("new_evidence.animate_out", _handle_new_evidence_animate_out)

func _handle_new_evidence_animate_in(args: Dictionary):
	title.text = args.get("title", "")
	description.text = args.get("description", "")
	thumbnail.texture = Utils.load_texture(args.get("res", ""))
	animate_in()

func _handle_new_evidence_animate_out(args: Dictionary):
	animate_out()

func animate_in():
	background.position.x = 256

	if tw:
		tw.kill()
	
	tw = create_tween()
	in_jingle.play()
	tw.tween_property(background, "position:x", 0.0, 23.0 / 60.0)
	_in = true

func animate_out():
	background.position.x = 0

	if tw:
		tw.kill()
	
	tw = create_tween()
	out_sound.play()
	tw.tween_property(background, "position:x", -background.size.x, 19.0 / 60.0)
	_in = false
