extends AnimatedSprite2D

@onready var evidence_holder: TextureRect = $EvidenceHolder
@onready var sound: AudioStreamPlayer = $InSound

func _ready():
	animation = &"in"
	frame = 0
	evidence_holder.visible = false

func show_evidence(texture_path: String):
	sound.play()
	evidence_holder.texture = Utils.load_texture(texture_path)
	visible = true
	play(&"in")
	await animation_finished
	evidence_holder.visible = true

func hide_evidence():
	evidence_holder.visible = false
	sound.play()
	play(&"out")
	await animation_finished
	visible = false

func hide_evidence_immediate():
	evidence_holder.visible = false
	visible = false