extends Node2D

var magnitude: float = 0.0
var remaining: float = 0.0

@onready var inner_container: Node2D = $InnerContainer
@onready var bubble_display: Sprite2D = %BubbleDisplay

const BUILTIN_BUBBLES = {
	"objection": preload("res://ui/exclamations/objection.png"),
	"holdit": preload("res://ui/exclamations/holdit.png"),
	"takethat": preload("res://ui/exclamations/takethat.png")
}

enum { STATE_WAITING, STATE_SHAKING, STATE_STILL }
var _state: int = STATE_WAITING

# Called when the node enters the scene tree for the first time.
func _ready():
	ScriptManager.register_handler("bubble.animate", _handle_bubble_animate)

func _handle_bubble_animate(args: Dictionary):
	var type = args.get("type", "objection")
	magnitude = float(args.get("magnitude", "4.0"))

	# Load texture into sprite
	if BUILTIN_BUBBLES.has(type):
		var texture = BUILTIN_BUBBLES[type]
		bubble_display.texture = texture
	else:
		Utils.print_error("Bubble type \"%s\" does not exist (must be \"objection\", \"holdit\", or \"takethat\")")
		return

	_state = STATE_SHAKING
	remaining = 0.5

func calculate_shake() -> Vector2:
	var angle = randf_range(0, TAU)
	return Vector2(int(cos(angle) * magnitude), int(sin(angle) * magnitude))

func _process(delta: float):
	match _state:
		STATE_WAITING:
			visible = false
			return
		STATE_SHAKING:
			visible = true
			remaining -= delta
			var offset := Vector2.ZERO
			if remaining > 0:
				offset = calculate_shake()
			else:
				remaining = 0.5
				_state = STATE_STILL
			inner_container.position = offset
			return
		STATE_STILL:
			visible = true
			remaining -= delta
			if remaining <= 0.0:
				visible = false
				_state = STATE_WAITING


