class_name ForegroundParallaxEffect
extends Node2D

var tw: Tween = null

const POSITIONS_TO_OFFSETS = {
	"left": -109.0,
	"center": 0.0,
	"right": 109.0
}

# Called when the node enters the scene tree for the first time.
func _ready():
	Camera.instance.pan_will_be_performed.connect(_on_pan_will_be_performed)
	Camera.instance.cut_performed.connect(_on_cut_performed)
	global_position.x = 0.0


func _on_pan_will_be_performed(old_position: String, new_position: String):
	const ELIGIBLE_POSITIONS = ["left", "center", "right"]
	if not (old_position in ELIGIBLE_POSITIONS and new_position in ELIGIBLE_POSITIONS):
		return

	if tw:
		tw.kill()
	
	tw = create_tween()

	var new_pos: float = POSITIONS_TO_OFFSETS[new_position]
	
	tw.tween_property(self, "global_position:x", new_pos, 0.5).set_trans(Tween.TRANS_SINE)

func _on_cut_performed(new_position: String):
	global_position.x = POSITIONS_TO_OFFSETS[new_position]