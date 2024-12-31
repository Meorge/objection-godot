class_name Utils

static var colors := {
	"aa-text-red": Color8(240, 112, 56),
	"aa-text-blue": Color8(104, 192, 240),
	"aa-text-green": Color8(0, 240, 0),

	"aa-witintro-red": Color8(230, 51, 35),
	"aa-witintro-blue": Color8(43, 24, 245),

	"aa-flashtestimony": Color8(0, 192, 56),
}

static func get_color_from_string(string: String, default: Color) -> Color:
	if colors.has(string):
		return colors[string]
	else:
		return Color.from_string(string, default)

