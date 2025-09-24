class_name PayneEngine
extends Node

## Payne is a simpler, higher-level engine for rendering basic conversations.

enum ParsePhase { PHASE_NONE, PHASE_CAST, PHASE_CONVERSATION }

var current_phase: ParsePhase = ParsePhase.PHASE_NONE

var characters: Dictionary = {}

# Dialog blocks have an "id" and a "text" field.
var dialog_blocks: Array[Dictionary] = []

var current_id: String = ""

var character_configs: Dictionary = {
    "acro": {},
    "adrian": {"blip": "female"},
    "angel": {"blip": "female"},
    "april": {"blip": "female"},
    "armstrong": {},
    "athena": {"pos": "left", "blip": "female"},
    "atmey": {},
    "bentrilo": {},
    "bikini": {"blip": "female"},
    "cody": {},
    "dahlia": {"blip": "female"},
    "dee": {"blip": "female"},
    "desiree": {"blip": "female"},
    "edgeworth": {
        "pos": "right",
        "blip": "male",
        "sounds": {
            "holdit": "res://ui/exclamations/exclamation_sounds/holdit-edgeworth.wav",
            "objection": "res://ui/exclamations/exclamation_sounds/objection-edgeworth.mp3",
            "takethat": "res://ui/exclamations/exclamation_sounds/takethat-edgeworth.wav"
        }
    },
    "ema": {"blip": "female"},
    "franziska": {
        "pos": "right",
        "blip": "female",
        "sounds": {
            "objection": "res://ui/exclamations/exclamation_sounds/objection-franziska.wav",
        }
    },
    "gant": {},
    "grossberg": {},
    "gumshoe": {},
    "ini": {"blip": "female"},
    "jake": {"blip": "male"},
    "judge": {"pos": "judge"},
    "judge_brother": {"pos": "judge"},
    "karma": {
        "pos": "right",
        "sounds": {
            "objection": "res://ui/exclamations/exclamation_sounds/objection-karma.mp3"
        }
    },
    "killer": {},
    "klavier": {
        "pos": "right",
        "sounds": {
            "objection": "res://ui/exclamations/exclamation_sounds/objection-klavier.wav"
        }
    },
    "lana": {"blip": "female"},
    "larry": {},
    "lisa": {"blip": "female"},
    "lotta": {"blip": "female"},
    "maggey": {"blip": "female"},
    "matt": {},
    "max": {},
    "maya": {"blip": "female"},
    "meekins": {},
    "mia_attorney": {
        "pos": "left",
        "blip": "female",
        "sounds": {
            "holdit": "res://ui/exclamations/exclamation_sounds/holdit-mia.wav",
            "objection": "res://ui/exclamations/exclamation_sounds/objection-mia.wav",
            "takethat": "res://ui/exclamations/exclamation_sounds/takethat-mia.wav"
        }
    },
    "moe": {},
    "morgan": {"blip": "female"},
    "oldbag": {"blip": "female"},
    "payne": {
        "pos": "right",
        "sounds": {
            "objection": "res://ui/exclamations/exclamation_sounds/objection-payne.mp3"
        }
    },
    "pearl": {"blip": "female"},
    "phoenix": {
        "pos": "left",
        "sounds": {
            "holdit": "res://ui/exclamations/exclamation_sounds/holdit-phoenix.mp3",
            "objection": "res://ui/exclamations/exclamation_sounds/objection-phoenix.mp3",
            "takethat": "res://ui/exclamations/exclamation_sounds/takethat-phoenix.mp3"
        }
    },
    "polly": {},
    "redd": {},
    "regina": {"blip": "female"},
    "ron": {},
    "sahwit": {},
    "sal": {},
    "terry": {},
    "tigre": {},
    "victor": {},
    "viola": {"blip": "female"},
    "wellington": {},
    "will": {},
    "yanni": {}
}

@onready var box_splitter: BoxSplitter = %BoxSplitter

func _get_character_id_from_id(id: String) -> String:
    return characters[id]["character"]

func generate_xml() -> String:
    var output_xml: Array[String] = []
    
    # Start music
    output_xml.append("<music.play res=\"res://audio/music/pwr/cross-moderato.mp3\"/>\n")

    var prev_char_id: String = ""

    for block in dialog_blocks:
        var user: Dictionary = characters[block["id"]]
        

        var char_id = _get_character_id_from_id(block["id"])
        var char_config: Dictionary = character_configs[char_id]

        if block.has("bubble_type"):
            var bubble_type = block["bubble_type"]
            var sound_path = char_config.get("sounds", {}).get(bubble_type, "res://audio/sound/objection-generic.wav")
            
            output_xml.append("<box.set_visible value=\"false\"/>")
            output_xml.append("<flash />")
            output_xml.append("<sound.play res=\"%s\" />" % [sound_path])
            output_xml.append("<bubble.animate type=\"%s\" />" % [bubble_type])
            output_xml.append("<wait duration=\"1.5\"/>")
            output_xml.append("<play />")
            continue

        var char_pos = char_config.get("pos", "center")
        var char_blip = char_config.get("blip", "male")
        var char_res = char_config.get("res", "res://characters/%s/%s.tres" % [char_id, char_id])

        var display_name: String = user["display_name"]

        # Set text box for character
        output_xml.append("<nametag.set_text text=\"%s\" />" % [display_name])
        # Set character idle animation
        output_xml.append("<sprite.set pos=\"%s\" res=\"%s\" anim=\"normal-idle\"/>\n" % [char_pos, char_res])

        # Cut camera to this character's position
        output_xml.append("<camera.cut to=\"%s\" />\n" % [char_pos])

        # Short wait before starting text box
        output_xml.append("<wait duration=\"0.5\"/>")

        # Start character talking animation
        output_xml.append("<sprite.set pos=\"%s\" anim=\"normal-talk\" />\n" % [char_pos])

        # Talk
        output_xml.append("<box.set_visible value=\"true\"/>\n")
        output_xml.append("<blip.set type=\"%s\" />" % [char_blip])
        output_xml.append(block["text"])
        output_xml.append("")

        # End character talking animation once text is done
        output_xml.append("<sprite.set pos=\"%s\" anim=\"normal-idle\" />\n" % [char_pos])
        output_xml.append("<blip.set type=\"none\" />\n")

        output_xml.append("<arrow.set_visible/>\n")
        output_xml.append("<wait duration=\"2.0\"/>\n")

        output_xml.append("<arrow.set_visible value=\"false\"/>\n")
        output_xml.append("<sound.play res=\"res://audio/sound/sfx-pichoop.wav\" />")
        output_xml.append("<play/>\n")
        output_xml.append("\n")

        prev_char_id = char_id
    
    var xml_str: String = "".join(output_xml).strip_edges()
    return xml_str

func parse(xml_str: String):
    var p := XMLParser.new()
    p.open_buffer(xml_str.to_utf8_buffer())

    while p.read() != ERR_FILE_EOF:
        match p.get_node_type():
            XMLParser.NODE_ELEMENT:
                _parse_element(p)
            XMLParser.NODE_ELEMENT_END:
                _parse_element_end(p)
            XMLParser.NODE_TEXT:
                _parse_element_text(p)


func _parse_element(p: XMLParser):
    match current_phase:
        ParsePhase.PHASE_NONE:
            match p.get_node_name():
                "payne":
                    pass
                "cast":
                    current_phase = ParsePhase.PHASE_CAST
                "conversation":
                    current_phase = ParsePhase.PHASE_CONVERSATION

        ParsePhase.PHASE_CAST:
            if p.get_node_name() == "character":
                var attributes := {}
                for attr_i in p.get_attribute_count():
                    attributes[p.get_attribute_name(attr_i)] = p.get_attribute_value(attr_i)
                
                var id: String = attributes.get("id", "user")
                var display_name: String = attributes.get("display_name", "User")
                var character: String = attributes.get("character", "phoenix")
                characters[id] = {"display_name": display_name, "character": character}

        ParsePhase.PHASE_CONVERSATION:
            if p.get_node_name() == "dialog":
                var attributes := {}
                for attr_i in p.get_attribute_count():
                    attributes[p.get_attribute_name(attr_i)] = p.get_attribute_value(attr_i)
                
                current_id = attributes["id"]
            elif p.get_node_name() == "objection":
                dialog_blocks.append({"id": p.get_named_attribute_value_safe("id"), "bubble_type": "objection"})
            elif p.get_node_name() == "holdit":
                dialog_blocks.append({"id": p.get_named_attribute_value_safe("id"), "bubble_type": "holdit"})
            elif p.get_node_name() == "takethat":
                dialog_blocks.append({"id": p.get_named_attribute_value_safe("id"), "bubble_type": "takethat"})


func _parse_element_text(p: XMLParser):
    match current_phase:
        ParsePhase.PHASE_CONVERSATION:
            var raw_text = p.get_node_data().strip_edges()
            if raw_text.length() <= 0:
                return
            var text_blocks = box_splitter.split_text_into_blocks(raw_text)
            for block in text_blocks:
                dialog_blocks.append({"id": current_id, "text": block.strip_edges()})


func _parse_element_end(p: XMLParser):
    match current_phase:
        ParsePhase.PHASE_CAST:
            if p.get_node_name() == "cast":
                current_phase = ParsePhase.PHASE_NONE
                return
            
        ParsePhase.PHASE_CONVERSATION:
            if p.get_node_name() == "dialog":
                return

            if p.get_node_name() == "conversation":
                current_phase = ParsePhase.PHASE_NONE
                return

