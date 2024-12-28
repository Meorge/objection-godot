class_name ControlShaker
extends Shaker

@onready var inner_container: Control = $InnerContainer

func set_offset(offset: Vector2):
    inner_container.position = offset * multiplier