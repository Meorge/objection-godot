class_name Utils

static var colors := {
	"aa-text-red": Color8(240, 112, 56),
	"aa-text-blue": Color8(104, 192, 240),
	"aa-text-green": Color8(0, 240, 0),

	"aa-witintro-red": Color8(230, 51, 35),
	"aa-witintro-blue": Color8(43, 24, 245),

	"aa-flashtestimony": Color8(0, 192, 56),
}

## Given a color as a string, return the corresponding Color.
## Works for HTML color codes, built-in color names, and Ace Attorney-specific
## color names (provided up above in `colors`).
static func get_color_from_string(string: String, default: Color) -> Color:
	if colors.has(string):
		return colors[string]
	else:
		return Color.from_string(string, default)

## Prints text to the output with error label and styling.
static func print_error(string: String):
	print_rich("[color=red][b]ERROR:[/b] " + string)

## Loads a texture, either part of the project or externally, from the given path.
##
## Written by LuisMayo for PR #18, and moved here for reusability.
static func load_texture(path: String) -> ImageTexture:
	if (path.begins_with("res://")):
		return load(path)
	else:
		var img := Image.load_from_file(path)
		return ImageTexture.create_from_image(img)
