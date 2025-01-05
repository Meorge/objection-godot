class_name ConfettiFlake
extends Sprite2D

@export var sprites: Array[Texture2D] = []

func _ready():
    texture = sprites.pick_random()

func _process(_delta: float):
    # Adapted from a decompilation of Ace Attorney GBA
    # https://github.com/atasro2/pwaa1/blob/795f03f2c5337d01ea6ce87f6a81b53a0de2a466/src/court.c#L725
    position.x = fmod(position.x + randi_range(-3, 3), 256)
    position.y = fmod(position.y + randi_range(0, 3), 192 + 4)
