class_name MoodMatrixOverloadTint
extends ColorRect

func _ready():
	stop_tints()

var tint_tween: Tween = null
func set_tints(new_colors: Array[Color]):
	if tint_tween != null:
		tint_tween.kill()

	if new_colors.size() == 0:
		stop_tints()
		return
		
	tint_tween = create_tween()

	for c in new_colors:
		tint_tween.tween_callback(func():
			color = c
			color.a = 0.25
		)
		tint_tween.tween_interval(3.0)
	if new_colors.size() == 1:
		tint_tween.tween_callback(func():
			color = Color.WHITE
			color.a = 0.0
		)
		tint_tween.tween_interval(3.0)
	tint_tween.set_loops(-1)

func stop_tints():
	if tint_tween != null:
		tint_tween.kill()
	
	color = Color.WHITE
	color.a = 0.0