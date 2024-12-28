@tool
class_name CameraPosition
extends Node2D

const GAME_WIDTH = 256
const GAME_HEIGHT = 192

@export var camera_id: String = ""
static var positions: Dictionary = {}

func _ready():
    positions[camera_id] = self

func _draw():
    if Engine.is_editor_hint():
        draw_rect(Rect2(-GAME_WIDTH / 2, -GAME_HEIGHT / 2, GAME_WIDTH, GAME_HEIGHT), Color.GREEN, false, 1.0, false)