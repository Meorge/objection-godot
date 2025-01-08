extends Node2D

const RADIUS_DISTANCE = 25
const INITIAL_FIRST_RADIUS = 25
var first_radius: float = INITIAL_FIRST_RADIUS

var t_mid: float = 0.5

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta):
	first_radius += delta * 10
	while first_radius > INITIAL_FIRST_RADIUS + RADIUS_DISTANCE:
		first_radius -= RADIUS_DISTANCE

	t_mid += delta * 0.25
	while t_mid > 1.0:
		t_mid -= 1.0

	rotation_degrees -= delta * 3
	queue_redraw()

func get_circle(radius: float, num_verts: int) -> Array:
	var colors: PackedColorArray = []
	var verts: PackedVector2Array = []
	var rad_per_vert: float = TAU / num_verts
	for i in num_verts:
		verts.append(Vector2(cos(i * rad_per_vert), sin(i * rad_per_vert)) * radius)
		colors.append(Color(1, 1, 1, abs(cos(i * rad_per_vert))))
	verts.append(verts[0])
	colors.append(colors[0])
	return [verts, colors]

func get_line(line_no: float):
	var colors: PackedColorArray = []
	var verts: PackedVector2Array = []
	var length: float = 20
	for i in 20:
		verts.append(Vector2(cos(line_no * TAU / 6) * i * length, sin(line_no * TAU / 6) * i * length))
		colors.append(Color(1, 1, 1, get_line_pulse_color(i / 10.0)))
	return [verts, colors]

func get_line_pulse_color(t: float) -> float:
	const CENTER_OPACITY = 0.8
	const EDGE_OPACITY = 0.25
	var r: float = 0.1
	if t == 0 or t >= 1.0:
		return 0.0
	if t < t_mid - r or t > t_mid + r:
		return EDGE_OPACITY
	elif t <= t_mid:
		return remap(t, t_mid - r, t_mid, EDGE_OPACITY, CENTER_OPACITY)
	else:
		return remap(t, t_mid, t_mid + r, CENTER_OPACITY, EDGE_OPACITY)


func _draw():
	var circle_count: int = 5
	for i in circle_count:
		var radius = first_radius + i * RADIUS_DISTANCE
		var data = get_circle(radius, 16)
		var verts = data[0]
		var colors = data[1]
		draw_polyline_colors(verts, colors, 2.0, false)

	for i in 6:
		var data = get_line(i)
		var verts = data[0]
		var colors = data[1]
		draw_polyline_colors(verts, colors, 2.0, false)
		# var dir: Vector2 = Vector2(cos(i * TAU / 6), sin(i * TAU / 6))
		# draw_polyline_colors([dir * 5, dir * 200], [Color(1,1,1,0.0), Color(1,1,1,0.5)], 2.0, false)
