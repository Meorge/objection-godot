extends Sprite2D


func update_position():
	if texture == null:
		return
	position = Vector2(-texture.get_width() / 2.0, -texture.get_height())

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	update_position()
