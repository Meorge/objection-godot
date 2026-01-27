class_name BoxSplitter
extends Node2D

@onready var dialogue_box: RichTextLabel = %DialogueLabel

func split_text_into_blocks(text: String) -> Array[String]:
	if dialogue_box == null:
		dialogue_box = %DialogueLabel
		
	var text_blocks: Array[String] = []
	var split_text: PackedStringArray = text.split(" ")
	var current_text: String = ""

	for word in split_text:
		var new_current_text = current_text + word + " "
		dialogue_box.text = new_current_text
		if dialogue_box.get_line_count() > 3:
			current_text = current_text.strip_edges()
			text_blocks.append(current_text)
			current_text = ""
		current_text += word
		current_text += " "

	if current_text.length() > 0:
		current_text = current_text.strip_edges()
		text_blocks.append(current_text)

	return text_blocks
