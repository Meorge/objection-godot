class_name CharacterSpriteContainer
extends AnimatedSprite2D

@export var container_id: String = ""
static var sprite_containers: Dictionary = {}

func _ready():
    sprite_containers[container_id] = self