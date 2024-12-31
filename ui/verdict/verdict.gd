extends Control

@export var single_letter_label: PackedScene

const TARGET_WIDTH = 230

var whole_text: String = ""
var whole_width: float = 0.0

var groups: Array[Array] = []

enum { GROUP_BY_WORD, GROUP_BY_LETTER }

const GROUP_BY_DICT = {
	"letter": GROUP_BY_LETTER,
	"word": GROUP_BY_WORD
}

func _ready():
	ScriptManager.register_handler("verdict", _handle_verdict)

func _handle_verdict(args: Dictionary):
	var text = args["text"]
	var group_by_str = args.get("group_by", "letter")

	if not GROUP_BY_DICT.has(group_by_str):
		print_rich("[color=red][b]ERROR:[/b] The group-by strategy \"%s\" is not valid for the verdict command (must be \"letter\" or \"word\")." % group_by_str)
		return
	var group_by: int = GROUP_BY_DICT[group_by_str]

	var font_color := Utils.get_color_from_string(args.get("font_color", "white"), Color.WHITE)
	var font_outline_color: Color = Utils.get_color_from_string(args.get("font_outline_color", "black"), Color.BLACK)

	await generate_labels(
		text,
		group_by,
		font_color,
		font_outline_color
	)

func generate_labels(text: String, group_by: int, font_color: Color, font_outline_color: Color):
	scale.x = 1.0
	position.x = 0.0

	for group in groups:
		for label in group:
			if is_instance_valid(label):
				label.queue_free()
	groups.clear()

	whole_text = text
	var x_pos: float = 0

	var current_group: Array[VerdictSingleLetterLabel] = []
	for c in text:
		var l: VerdictSingleLetterLabel = single_letter_label.instantiate()
		l.text = c
		l.add_theme_color_override("font_color", font_color)
		l.add_theme_color_override("font_outline_color", font_outline_color)
		l.position.x = x_pos
		add_child(l)
		current_group.append(l)

		if group_by == GROUP_BY_LETTER or (group_by == GROUP_BY_WORD and c == " "):
			groups.append(current_group)
			current_group = []

		x_pos += l.get_width()
	
	if current_group.size() > 0:
		groups.append(current_group)

	whole_width = x_pos

	if whole_width > TARGET_WIDTH:
		# Too wide to fit on-screen, so we need to scale it down so it does fit
		var some_scale = TARGET_WIDTH / whole_width
		scale.x = some_scale
		
	position.x = (256.0 / 2.0) - (min(TARGET_WIDTH, whole_width) / 2.0)

	for group in groups:
		for label in group:
			label.animate_in()
			if group_by == GROUP_BY_LETTER and label.text != " ":
				create_tween().tween_callback(func(): SoundPlayer.instance.play_sound("res://audio/sound/sfx-guilty.wav")).set_delay(0.2)

		if group_by == GROUP_BY_WORD:
			create_tween().tween_callback(func(): SoundPlayer.instance.play_sound("res://audio/sound/sfx-guilty.wav")).set_delay(0.2)

		while not group.all(func(label: VerdictSingleLetterLabel): return label.text == " " or label.has_finished):
			await get_tree().process_frame

		if group_by == GROUP_BY_WORD:
			await get_tree().create_timer(0.4).timeout
		elif group_by == GROUP_BY_LETTER:
			await get_tree().create_timer(0.05).timeout
