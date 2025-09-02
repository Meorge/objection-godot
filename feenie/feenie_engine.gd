extends Node

## Feenie is a simpler, higher-level engine for rendering basic conversations.

enum ParsePhase { PHASE_NONE, PHASE_CAST, PHASE_CONVERSATION }

var current_phase: ParsePhase = ParsePhase.PHASE_NONE

var characters: Dictionary = {}

var dialog_blocks: Array[Dictionary] = []
var current_dialog: Dictionary = {}

func _ready():
    var f := FileAccess.open("res://feenie_test.xml", FileAccess.READ)
    parse(f.get_as_text().replace("\n", ""))
    print(dialog_blocks)


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
                "feenie":
                    print("Starting parsing of Feenie script")
                "cast":
                    current_phase = ParsePhase.PHASE_CAST
                "conversation":
                    current_phase = ParsePhase.PHASE_CONVERSATION

        ParsePhase.PHASE_CAST:
            if p.get_node_name() == "character":
                var attributes := {}
                for attr_i in p.get_attribute_count():
                    attributes[p.get_attribute_name(attr_i)] = p.get_attribute_value(attr_i)
                
                var id: String = attributes["id"]
                var display_name: String = attributes["display_name"] # TODO: currently required
                var character: String = attributes["character"] # TODO: currently required
                characters[id] = {"display_name": display_name, "character": character}

        ParsePhase.PHASE_CONVERSATION:
            if p.get_node_name() == "dialog":
                var attributes := {}
                for attr_i in p.get_attribute_count():
                    attributes[p.get_attribute_name(attr_i)] = p.get_attribute_value(attr_i)
                
                var id: String = attributes["id"]
                current_dialog["id"] = id


func _parse_element_text(p: XMLParser):
    match current_phase:
        ParsePhase.PHASE_CONVERSATION:
            current_dialog["text"] = p.get_node_data()


func _parse_element_end(p: XMLParser):
    match current_phase:
        ParsePhase.PHASE_CAST:
            if p.get_node_name() == "cast":
                current_phase = ParsePhase.PHASE_NONE
                return
            
        ParsePhase.PHASE_CONVERSATION:
            if p.get_node_name() == "dialog":
                dialog_blocks.append(current_dialog)
                current_dialog = {}

            if p.get_node_name() == "conversation":
                current_phase = ParsePhase.PHASE_NONE
                return

