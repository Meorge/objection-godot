class_name PayneEngine
extends Node

## Payne is a simpler, higher-level engine for rendering basic conversations.

enum ParsePhase { PHASE_NONE, PHASE_CAST, PHASE_CONVERSATION }

var current_phase: ParsePhase = ParsePhase.PHASE_NONE

var characters: Dictionary = {}

# Dialog blocks have an "id" and a "text" field.
var dialog_blocks: Array[Dictionary] = []

var current_id: String = ""
var current_anim: String = "RANDOM"
var current_evidence: String = ""

var character_configs: Dictionary = {
    "acro": {
        "anims": ["cries", "disappointed", "normal", "serious"]
    },
    "adrian": {
        "blip": "female",
        "anims": ["book", "disappointed", "normal", "scared", "serious", "surprised", "sweating", "thinking"]
    },
    "angel": {
        "blip": "female",
        "anims": ["lunch", "mad", "normal", "queen", "smiling", "sweating"]
    },
    "april": {
        "blip": "female",
        "anims": ["crying", "glaring", "normal", "side", "stiff", "thinking"]
    },
    "armstrong": {
        "anims": ["inviting", "normal", "sad", "sweating", "thinking"]
    },
    "athena": {
        "pos": "left",
        "blip": "female",
        "anims": ["confident", "defeated", "deskslam", "happy", "normal", "objection", "pumped", "screen", "shaking", "thinking"]
    },
    "atmey": {
        "anims": ["confident", "monocle", "normal", "sweating", "twitch"]
    },
    "bentrilo": {
        "anims": ["mad", "normal", "side", "side", "smack"]
    },
    "bikini": {
        "blip": "female",
        "anims": ["normal", "panic", "serious", "thinking"]
    },
    "cody": {
        "anims": ["confident", "crying", "mutter", "normal", "sword"]
    },
    "dahlia": {
        "blip": "female",
        "anims": ["crying", "hair", "hate", "normal", "sweating", "thinking"]
    },
    "dee": {
        "blip": "female",
        "anims": ["coldsmile", "confessing", "normal", "sweating"]
    },
    "desiree": {
        "blip": "female",
        "anims": ["normal", "sweating", "thinking"]
    },
    "edgeworth": {
        "pos": "right",
        "blip": "male",
        "anims": ["confident", "document", "handondesk", "normal", "pointing", "strained", "thinking"],
        "sounds": {
            "holdit": "res://ui/exclamations/exclamation_sounds/holdit-edgeworth.wav",
            "objection": "res://ui/exclamations/exclamation_sounds/objection-edgeworth.wav",
            "takethat": "res://ui/exclamations/exclamation_sounds/takethat-edgeworth.wav"
        }
    },
    "ema": {
        "blip": "female",
        "anims": ["cheerful", "confident", "disappointed", "mad", "normal", "notes", "pumped", "sad", "serious", "surprised", "thinking"]
    },
    "franziska": {
        "pos": "right",
        "blip": "female",
        "anims": ["clench", "mad", "normal", "ready", "sweating", "tisk", "withwhip"],
        "sounds": {
            "objection": "res://ui/exclamations/exclamation_sounds/objection-franziska.wav",
        }
    },
    "gant": {
        "anims": ["glare", "impatient", "normal", "smiling", "sweating", "thinking"]
    },
    "grossberg": {
        "anims": ["normal", "sweating"]
    },
    "gumshoe": {
        "anims": ["confident", "disheartened", "laughing", "mad", "normal", "pumped", "side", "thinking"]
    },
    "ini": {
        "blip": "female",
        "anims": ["mad", "normal", "spin", "sweating", "teehee", "thinking"]
    },
    "jake": {
        "blip": "male",
        "anims": ["mad", "normal", "serious", "shave", "smirk"]
    },
    "judge": {
        "pos": "judge",
        "anims": ["normal", "surprised", "warning"]
    },
    "judge_brother": {
        "pos": "judge",
        "anims": ["normal", "surprised", "warning"]
    },
    "karma": {
        "pos": "right",
        "sounds": {
            "objection": "res://ui/exclamations/exclamation_sounds/objection-karma.wav"
        },
        "anims": ["badmood", "break", "normal", "smirk", "snap", "sweat"]
    },
    "killer": {
        "anims": ["normal", "steaming", "sweating"]
    },
    "klavier": {
        "pos": "right",
        "sounds": {
            "objection": "res://ui/exclamations/exclamation_sounds/objection-klavier.wav"
        },
        "anims": ["fist-sweat", "fist", "lean", "nervous", "normal", "objection", "pounds", "snaps", "sweats", "up"]
    },
    "lana": {
        "blip": "female",
        "anims": ["forceful", "mad", "normal", "ohmy", "profile", "sideglance", "smiling", "sweating"]
    },
    "larry": {
        "anims": ["hello", "mad", "nervous", "normal", "scratch", "stylish", "thinking", "thumbsup"]
    },
    "lisa": {
        "blip": "female",
        "anims": ["normal", "smiling", "sweating"]
    },
    "lotta": {
        "blip": "female",
        "anims": ["badmood", "confident", "disappointed", "mad", "normal", "shy", "smiling", "thinking"]
    },
    "maggey": {
        "blip": "female",
        "anims": ["normal", "pumped", "sad", "shining"]
    },
    "matt": {
        "anims": ["dialing", "laughs", "normal", "onphone", "sweats", "thinking", "trueself"]
    },
    "max": {
        "anims": ["billy", "normal", "sweating", "toss1", "toss2", "whatev"]
    },
    "maya": {
        "blip": "female",
        "anims": ["cheerful", "confident", "crying", "disheartened", "mad", "normal", "pumped", "sad", "surprised", "thinking", "worried"]
    },
    "meekins": {
        "anims": ["megaphone", "punch", "sad", "saluting", "thoughtful"]
    },
    "mia_attorney": {
        "pos": "left",
        "blip": "female",
        "anims": ["confident", "handsondesk", "normal", "pointing", "sweating", "thinking"],
        "sounds": {
            "holdit": "res://ui/exclamations/exclamation_sounds/holdit-mia.wav",
            "objection": "res://ui/exclamations/exclamation_sounds/objection-mia.wav",
            "takethat": "res://ui/exclamations/exclamation_sounds/takethat-mia.wav"
        }
    },
    "moe": {
        "anims": ["mad", "normal", "sad", "serious", "tsk"]
    },
    "morgan": {
        "blip": "female",
        "anims": ["glare", "normal", "sad", "sleeve"]
    },
    "oldbag": {
        "blip": "female",
        "anims": ["inlove", "mad", "normal", "teasing", "teehee"]
    },
    "payne": {
        "pos": "right",
        "anims": ["confident", "normal", "sweating"],
        "sounds": {
            "objection": "res://ui/exclamations/exclamation_sounds/objection-payne.wav"
        }
    },
    "pearl": {
        "blip": "female",
        "anims": ["cheerful", "cries", "disappointed", "fight", "normal", "shy", "sparkle", "surprised", "thinking"]
    },
    "phoenix": {
        "pos": "left",
        "anims": ["coffee", "confident", "document", "handsondesk", "normal", "pointing", "sheepish", "sweating", "thinking"],
        "sounds": {
            "holdit": "res://ui/exclamations/exclamation_sounds/holdit-phoenix.wav",
            "objection": "res://ui/exclamations/exclamation_sounds/objection-phoenix.wav",
            "takethat": "res://ui/exclamations/exclamation_sounds/takethat-phoenix.wav"
        }
    },
    "polly": {
        "anims": ["normal"]
    },
    "redd": {
        "anims": ["mymy", "normal", "shouting", "sweating", "thinking"]
    },
    "regina": {
        "blip": "female",
        "anims": ["confident", "happy", "normal", "sad", "sparkles", "thinking"]
    },
    "ron": {
        "anims": ["emphatic", "normal", "shouting", "sweating", "thinking"]
    },
    "sahwit": { "anims": ["glaring", "normal", "twitching"]},
    "sal": { "anims": ["mad", "normal", "thinking", "wiggle", "worried"]},
    "terry": { "anims": ["normal", "sad", "serious", "thinking"]},
    "tigre": { "anims": ["compliant", "mad", "normal", "roar", "shameless", "simpering"]},
    "victor": { "anims": ["mad", "normal", "shy", "side", "sweating"]},
    "viola": { "blip": "female", "anims": ["crying", "heehee", "normal"] },
    "wellington": { "anims": ["mad", "normal", "sweating", "twitch"]},
    "will": { "anims": ["hanky", "nervous", "normal", "thinking"] },
    "yanni": { "anims": ["angry", "normal", "side", "thoughtful"]}
}

@onready var box_splitter: BoxSplitter = %BoxSplitter

func _get_character_id_from_id(id: String) -> String:
    return characters[id]["character"]

func generate_xml() -> String:
    var output_xml: Array[String] = []
    
    # Start music
    output_xml.append("<music.play res=\"res://audio/music/pwr/cross-moderato.wav\"/>\n")

    var prev_evidence: String = ""
    var evidence_side: String = ""

    for block_i in dialog_blocks.size():
        var block = dialog_blocks[block_i]
        if block["type"] == "music":
            if block["music"] == "stop":
                output_xml.append("<music.stop />")
                continue
            else:
                output_xml.append("<music.play res=\"%s\" />" % [block["music"]])
                continue

        elif block["type"] == "bubble":
            var user: Dictionary = characters[block["id"]]
            var char_id = _get_character_id_from_id(block["id"])
            var char_config: Dictionary = character_configs[char_id]

            var bubble_type = block["bubble_type"]
            var sound_path = char_config.get("sounds", {}).get(bubble_type, "res://audio/sound/objection-generic.wav")

            output_xml.append("<evidence.hide_immediate side=\"%s\" />" % [evidence_side])
            output_xml.append("<box.set_visible value=\"false\"/>")
            output_xml.append("<flash />")
            output_xml.append("<sound.play res=\"%s\" />" % [sound_path])
            output_xml.append("<bubble.animate type=\"%s\" />" % [bubble_type])
            output_xml.append("<wait duration=\"1.5\"/>")
            output_xml.append("<play />")
            continue

        elif block["type"] == "gavel":
            var num_slams = int(block["slams"])
            output_xml.append("<box.set_visible value=\"false\"/>")
            output_xml.append("<camera.cut to=\"gavel\" />")
            output_xml.append("<gavel.animate num=\"%s\" />" % [num_slams])
            output_xml.append("<play />")
            continue

        elif block["type"] == "newevidence":
            output_xml.append("<arrow.set_visible/>\n")

            output_xml.append("<wait duration=\"1.0\" />")

            output_xml.append("<new_evidence.animate_in title=\"%s\" description=\"%s\" res=\"%s\" />" % [block.get("title", ""), block.get("description", ""), block.get("res", "")])
            output_xml.append("<wait duration=\"4.0\" />")
            output_xml.append("<arrow.set_visible value=\"false\"/>\n")
            output_xml.append("<sound.play res=\"res://audio/sound/sfx-pichoop.wav\" />")
            output_xml.append("<new_evidence.animate_out />")
            output_xml.append("<play/>\n")
            output_xml.append("\n")

        elif block["type"] == "text":
            var user: Dictionary = characters[block["id"]]
            var char_id = _get_character_id_from_id(block["id"])
            var char_config: Dictionary = character_configs[char_id]

            var char_pos = char_config.get("pos", "center")
            var char_blip = char_config.get("blip", "male")
            var char_res = char_config.get("res", "res://characters/%s/%s.tres" % [char_id, char_id])
            var display_name: String = user["display_name"]

            var char_anim = block.get("anim", "RANDOM")
            if char_anim == "RANDOM":
                var anims: Array = char_config["anims"]
                char_anim = anims.pick_random()

            var evidence: String = block.get("evidence", "")

            # Hide any existing evidence
            if evidence == "" and prev_evidence == "":
                output_xml.append("<evidence.hide_immediate side=\"%s\" />" % [evidence_side])
            elif prev_evidence != "":
                output_xml.append("<evidence.hide side=\"%s\" />" % [evidence_side])

            # Set text box for character
            output_xml.append("<nametag.set_text text=\"%s\" />" % [display_name])
            # Set character idle animation
            output_xml.append("<sprite.set pos=\"%s\" res=\"%s\" anim=\"%s-idle\"/>\n" % [char_pos, char_res, char_anim])

            # Cut camera to this character's position
            output_xml.append("<camera.cut to=\"%s\" />\n" % [char_pos])

            # Short wait before starting text box
            output_xml.append("<wait duration=\"0.5\"/>")

            # Start character talking animation
            output_xml.append("<sprite.set pos=\"%s\" anim=\"%s-talk\" />\n" % [char_pos, char_anim])

            # If this box has evidence, then display it.
            if evidence != "" and evidence != prev_evidence:
                evidence_side = "left" if char_pos == "right" else "right"
                output_xml.append("<evidence.show res=\"%s\" side=\"%s\" />" % [block["evidence"], evidence_side])
                
            # Talk
            output_xml.append("<box.set_visible value=\"true\"/>\n")
            output_xml.append("<blip.set type=\"%s\" />" % [char_blip])
            output_xml.append(block["text"])
            output_xml.append("")

            # End character talking animation once text is done
            output_xml.append("<sprite.set pos=\"%s\" anim=\"%s-idle\" />\n" % [char_pos, char_anim])
            output_xml.append("<blip.set type=\"none\" />\n")

            if dialog_blocks.size() > block_i + 1 and dialog_blocks[block_i + 1]["type"] != "newevidence":
                output_xml.append("<arrow.set_visible/>\n")
                output_xml.append("<wait duration=\"2.0\"/>\n")

                output_xml.append("<arrow.set_visible value=\"false\"/>\n")
                output_xml.append("<sound.play res=\"res://audio/sound/sfx-pichoop.wav\" />")
                output_xml.append("<play/>\n")
                output_xml.append("\n")

            prev_evidence = evidence
    
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
                var id: String = p.get_named_attribute_value_safe("id")
                if id == "": id = "user"

                var display_name: String = p.get_named_attribute_value_safe("display_name")
                if display_name == "": display_name = "User"

                var character: String = p.get_named_attribute_value_safe("character")
                if character == "": character = "phoenix"
                
                characters[id] = {"display_name": display_name, "character": character}

        ParsePhase.PHASE_CONVERSATION:
            if p.get_node_name() == "dialog":
                current_id = p.get_named_attribute_value_safe("id")
                if current_id == "": current_id = "user"

                current_anim = p.get_named_attribute_value_safe("anim")
                if current_anim == "": current_anim = "RANDOM"

                current_evidence = p.get_named_attribute_value_safe("evidence")

            elif p.get_node_name() == "objection":
                dialog_blocks.append({
                    "type": "bubble",
                    "id": p.get_named_attribute_value_safe("id"),
                    "bubble_type": "objection"
                })
            elif p.get_node_name() == "holdit":
                dialog_blocks.append({
                    "type": "bubble",
                    "id": p.get_named_attribute_value_safe("id"),
                    "bubble_type": "holdit"
                })
            elif p.get_node_name() == "takethat":
                dialog_blocks.append({
                    "type": "bubble",
                    "id": p.get_named_attribute_value_safe("id"),
                    "bubble_type": "takethat"
                })
            elif p.get_node_name() == "stopmusic":
                dialog_blocks.append({
                    "type": "music",
                    "music": "stop"
                })
            elif p.get_node_name() == "startmusic":
                dialog_blocks.append({
                    "type": "music",
                    "music": p.get_named_attribute_value_safe("res")
                })
            elif p.get_node_name() == "gavel":
                dialog_blocks.append({
                    "type": "gavel",
                    "slams": p.get_named_attribute_value_safe("slams")
                })
            elif p.get_node_name() == "newevidence":
                dialog_blocks.append({
                    "type": "newevidence",
                    "title": p.get_named_attribute_value("title"),
                    "description": p.get_named_attribute_value_safe("description"),
                    "res": p.get_named_attribute_value_safe("res")
                })


func _parse_element_text(p: XMLParser):
    match current_phase:
        ParsePhase.PHASE_CONVERSATION:
            var raw_text = p.get_node_data().strip_edges()
            if raw_text.length() <= 0:
                return
            var text_blocks = box_splitter.split_text_into_blocks(raw_text)
            for block in text_blocks:
                dialog_blocks.append({
                    "type": "text",
                    "id": current_id,
                    "text": block.strip_edges(),
                    "anim": current_anim,
                    "evidence": current_evidence
                })


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

