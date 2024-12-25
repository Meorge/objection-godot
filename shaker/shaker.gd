class_name Shaker
extends Node

var magnitude: float = 0.0
var remaining: float = 0.0

@export var multiplier: Vector2 = Vector2.ONE

func start_shake(new_magnitude: float, duration: float):
    magnitude = new_magnitude
    remaining = duration

func calculate_shake() -> Vector2:
    var angle = randf_range(0, TAU)
    return Vector2(int(cos(angle) * magnitude), int(sin(angle) * magnitude))

func _process(delta: float):
    remaining -= delta
    var offset := Vector2.ZERO
    if remaining > 0:
        offset = calculate_shake()
    set_offset(offset)

func set_offset(offset: Vector2):
    pass



