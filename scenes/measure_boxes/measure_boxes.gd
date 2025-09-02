extends Node2D

@onready var dialogue_box: RichTextLabel = %DialogueLabel

# Called when the node enters the scene tree for the first time.
func _ready():
    var my_text := "Hello, my name is Malcolm. I like to write code on the computer. I am very tired while writing this, which is why it sucks so bad."

    var output = split_text_into_blocks(my_text)
    print(output)

func split_text_into_blocks(text: String) -> Array[String]:
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

