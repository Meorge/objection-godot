class_name ScriptManager
extends Node

# Actions

# More sprite locations

# Verdict
# - verdict <text> <color>
# - verdict show <index>
# - verdict clear

# Gavel slam
# - gavel <frame>

var handlers := {
	"blip.set": _handle_blip_set,
	"sprite.set": _handle_sprite_set,
	"wait": _handle_wait,
	"set_text_speed": _handle_set_text_speed,
}

static var instance: ScriptManager

@onready var dialogue_label: RichTextLabel = GameUI.instance.dialogue_label
@onready var nametag_label: Label = GameUI.instance.nametag_label
@onready var camera: Camera2D = %Camera

const TEXT_SPEED_DEFAULT = 30.0
var text_speed: float = TEXT_SPEED_DEFAULT

static func register_handler(tag_name: String, handler: Callable):
	if instance == null:
		Utils.print_error("ScriptManager doesn't exist")
		return
	if tag_name in instance.handlers.keys():
		Utils.print_error("Handler for \"%s\" already exists" % tag_name)
		return
	instance.handlers[tag_name] = handler

func _enter_tree():
	instance = self

# Called when the node enters the scene tree for the first time.
func _ready():
	await get_tree().process_frame
	_display_text()

func _display_text():
	var path: String = "res://script.xml"

	var use_feenie: bool = false

	for arg in OS.get_cmdline_user_args():
		if arg == "--feenie":
			use_feenie = true
		elif arg.begins_with("--render-script="):
			path = arg.get_slice("=", 1)
			if (path[0] == "\"" and path[-1] == "\"") or (path[0] == "'" and path[-1] == "'"):
				path = path.substr(1, path.length() - 2)

	if not FileAccess.file_exists(path):
		Utils.print_error("File at \"%s\" cannot be found." % path)
		get_tree().quit(0)
		return

	print_rich("Running script at \"%s\"..." % path)

	var f := FileAccess.open(path, FileAccess.READ)

	var xml_str: String = ""
	if use_feenie:
		xml_str = %FeenieEngine.generate_xml(f.get_as_text().replace("\n", ""))
	else:
		xml_str = f.get_as_text().replace("\n", "")

	var text_bits := parse_xml_str(xml_str)

	# Start with a blank text box.
	dialogue_label.text = ""
	dialogue_label.clear()

	# All of the text is added to the dialogue label at once.
	var command_bits: Array[Dictionary] = []
	while not text_bits.is_empty():
		# Parse up until we get an clearbox command.
		var bit = text_bits.pop_front()

		if bit.has("text"):
			dialogue_label.append_text(bit["text"])
		elif bit.has("command"):
			if bit["command"] == "color":
				_handle_color(bit.get("args", {}), bit.get("end", false))
			elif bit["command"] == "play":
				# This box is done, so move onto the playing step.
				await _play_textbox(command_bits)
				if not text_bits.is_empty():
					dialogue_label.text = ""
					dialogue_label.clear()
					command_bits.clear()
			else:
				# This is a command to play at a certain index.
				command_bits.append(bit)
	get_tree().quit(0)


func _handle_color(args: Dictionary, is_end: bool):
	if not is_end:
		dialogue_label.push_color(Utils.get_color_from_string(args.get("value", "white"), Color.WHITE))
	else:
		dialogue_label.pop()


func _play_textbox(command_bits: Array[Dictionary]):
	dialogue_label.visible_characters = 0
	while dialogue_label.visible_characters < dialogue_label.get_total_character_count():
		await _handle_command(command_bits)
		await get_tree().create_timer(1 / text_speed).timeout
		dialogue_label.visible_characters += 1
		VoiceBlipPlayer.instance.play_blip()
	await _handle_command(command_bits)


func _handle_command(text_bits: Array[Dictionary]):
	for bit in text_bits:
		if not bit.has("index"):
			continue
		if bit["index"] != dialogue_label.visible_characters:
			continue

		if handlers.has(bit["command"]):
			var handler: Callable = handlers[bit["command"]]
			await handler.call(bit["args"])


func _handle_blip_set(args: Dictionary):
	match args["type"]:
		"male":
			VoiceBlipPlayer.instance.start_blips(VoiceBlipPlayer.Gender.MALE)
		"female":
			VoiceBlipPlayer.instance.start_blips(VoiceBlipPlayer.Gender.FEMALE)
		"typewriter":
			VoiceBlipPlayer.instance.start_blips(VoiceBlipPlayer.Gender.TYPEWRITER)
		"none":
			VoiceBlipPlayer.instance.stop_blips()
		_:
			Utils.print_error("Invalid blip type \"%s\" provided" % args["type"])


func _handle_sprite_set(args: Dictionary):
	var sprite_to_change: CharacterSpriteContainer = CharacterSpriteContainer.sprite_containers[args["pos"]]

	if args.has("res"):
		sprite_to_change.sprite_frames = load(args["res"])
	sprite_to_change.animation = args["anim"]
	sprite_to_change.frame = 0
	sprite_to_change.play()

func _handle_wait(args: Dictionary):
	if "duration" not in args:
		Utils.print_error("duration not provided for wait")
		return
	await get_tree().create_timer(float(args["duration"])).timeout

func _handle_set_text_speed(args: Dictionary):
	var new_speed := float(args.get("value", "1.0")) * TEXT_SPEED_DEFAULT
	text_speed = new_speed

static func parse_xml_str(xml_str: String) -> Array[Dictionary]:
	var p := XMLParser.new()
	var e := p.open_buffer(xml_str.to_utf8_buffer())
	var bits: Array[Dictionary] = []
	var text_index: int = 0
	while p.read() != ERR_FILE_EOF:
		match p.get_node_type():
			XMLParser.NODE_ELEMENT:
				var attributes := {}
				for attr_i in p.get_attribute_count():
					attributes[p.get_attribute_name(attr_i)] = p.get_attribute_value(attr_i)
				bits.append({ "command": p.get_node_name(), "args": attributes, "index": text_index })
				if p.get_node_name() == "play":
					text_index = 0
			XMLParser.NODE_ELEMENT_END:
				bits.append({ "command": p.get_node_name(), "end": true, "index": text_index })
			XMLParser.NODE_TEXT:
				bits.append({ "text": p.get_node_data() })
				text_index += p.get_node_data().length()
	return bits
