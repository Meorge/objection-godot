extends Label

@export var number: int
func _process(_delta):
	text = "%03d" % number