class_name MoodMatrixMarker
extends Node

@export var marker_type: MoodMatrixMarkerType

@onready var _border: TextureRect = %MarkerBorder
@onready var _background: TextureRect = %MarkerBackground
@onready var _face: TextureRect = %Face
@onready var _thinking_anim: AnimatedSprite2D = %ThinkingAnimation

# Called when the node enters the scene tree for the first time.
func _ready():
	_face.texture = marker_type.face_texture
	_face.modulate = marker_type.face_color_inactive
	set_inactive()

func set_thinking():
	_face.visible = false
	_thinking_anim.visible = true

func set_inactive():
	_face.visible = true
	_thinking_anim.visible = false

