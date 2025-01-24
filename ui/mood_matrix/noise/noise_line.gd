extends Control

var noise_nodes_orig_order: Array[TextureRect] = []
var noise_nodes: Array[TextureRect] = []
var noise_node_multipliers: Array[float] = []

@export var small_noise_texture: Texture2D = null
@export var large_noise_texture: Texture2D = null

## How much to scale each noise texture TextureRect by.
## This is *not* the "magnitude" of the noise - use `noise_level` for that.
@export var noise_size: float = 1.0

var noise_level: int = 100

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in 20:
		var new_noise_node: TextureRect = TextureRect.new()
		add_child(new_noise_node)
		new_noise_node.expand_mode = TextureRect.EXPAND_IGNORE_SIZE

		var texture := large_noise_texture
		new_noise_node.position.x = i * texture.get_width() * noise_size
		new_noise_node.size = texture.get_size() * noise_size
		new_noise_node.texture = texture
		noise_nodes.append(new_noise_node)
		noise_nodes_orig_order.append(new_noise_node)
		noise_node_multipliers.append(randf_range(0.1, 2.0))

var min_scale: float = 0.1
var max_scale: float = 1.0
func set_noise_level(level: int):
	noise_level = level
	# For noise level of 0%, just show a flat line.
	if level == 0:
		%FlatNoise.visible = true
		for noise_node in noise_nodes:
			noise_node.visible = false
	
	else:
		%FlatNoise.visible = false
		max_scale = remap(level, 0, 100, 0.5, 2.0)
		min_scale = max_scale * 0.5
		for noise_node in noise_nodes:
			noise_node.visible = true

func _process(delta):
	# Position the first TextureRect in line at its correct position, then
	# position all subsequent ones offset from it. This ensures that even if
	# different TextureRects have different widths, they're still placed correctly
	# side-by-side.
	for i in noise_nodes.size():
		var n = noise_nodes[i]
		n.pivot_offset = n.size / 2.0
		if i == 0:
			n.position.x -= 30.0 * delta
		else:
			n.position.x = noise_nodes[i - 1].position.x + noise_nodes[i - 1].size.x

	# Scale each TextureRect by a random amount.
	# The range of posible scales depends on a random variable.
	for i in noise_nodes_orig_order.size():
		noise_nodes_orig_order[i].scale.y = randf_range(min_scale, max_scale) * noise_node_multipliers[i]

	# Loop the TextureRects back to the opposite side once they're
	# completely off-screen.
	while noise_nodes[0].position.x + noise_nodes[0].size.x < 0:
		var t: TextureRect = noise_nodes.pop_front()
		var new_x = noise_nodes[-1].position.x + noise_nodes[-1].size.x
		t.position.x = new_x
		noise_nodes.push_back(t)
