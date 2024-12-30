class_name VerdictSingleLetterLabel
extends Label

const ANIMATE_DURATION = 0.21
var tw: Tween = null
var has_finished: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	visible = false

func get_width():
	return get_character_bounds(0).size.x

func animate_in():
	if tw:
		tw.kill()
	
	tw = create_tween()

	visible = true
	pivot_offset = get_character_bounds(0).size / 2.0
	scale = Vector2.ONE * (8.0 / 3.0)
	tw.tween_property(self, "scale", Vector2.ONE, ANIMATE_DURATION)
	tw.tween_callback(func(): has_finished = true)
