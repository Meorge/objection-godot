class_name Node2DShaker
extends Shaker

@onready var inner_container: Node2D = $InnerContainer

func set_offset(offset: Vector2):
    inner_container.position = offset * multiplier