class_name MoodMatrixRingNoise
extends TextureRect

@export var textures: Array[Texture2D] = []

var current_index: int = 0

var timer: Timer = null

func _ready():
	timer = Timer.new()
	timer.wait_time = 0.07
	timer.timeout.connect(_on_timer_timeout)
	add_child(timer)
	stop_ring_noise()

func start_ring_noise():
	timer.start()

func stop_ring_noise():
	timer.stop()
	texture = textures[0]

func _on_timer_timeout():
	var r := randf()
	if current_index == 0:
		# Currently at 0 level; it's a bit unlikely to start noise.
		if r < 0.85:
			# Likely to not start.
			pass
		else:
			# Less likely to start.
			current_index += 1
	elif current_index < textures.size() - 1:
		# Currently at one of the middle levels.
		if r < 0.40:
			current_index -= 1
		elif r < 0.60:
			pass
		else:
			current_index += 1
	else:
		# Currently at max level; we can stay here or go back down.
		if r < 0.9:
			current_index -= 1
		else:
			pass
	texture = textures[current_index]
