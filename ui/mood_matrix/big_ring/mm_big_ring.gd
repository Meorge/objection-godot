extends TextureRect

@export var ring_parts: Array[MoodMatrixRingNoise] = []

func _ready():
	ScriptManager.register_handler("mood_matrix.ui.set_ring_noise", _handle_mood_matrix_ui_set_ring_noise)

func _handle_mood_matrix_ui_set_ring_noise(args: Dictionary):
	var ring_noise_active = args.get("value", "true") == "true"
	if ring_noise_active:
		start_ring_noise()
	else:
		stop_ring_noise()


func start_ring_noise():
	for r in ring_parts:
		r.start_ring_noise()
	
func stop_ring_noise():
	for r in ring_parts:
		r.stop_ring_noise()
