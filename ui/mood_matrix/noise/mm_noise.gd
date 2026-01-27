extends Control

const ANIM_IN_DURATION = 0.3

@onready var noise_sound_player: AudioStreamPlayer = %NoiseSound

const VALID_NOISE_TYPES = ["100_0", "100_lp", "100_m", "100_s", "m_0", "m_100", "m_s", "s_0", "s_m"]

# Called when the node enters the scene tree for the first time.
func _ready():
	ScriptManager.register_handler("mood_matrix.noise.animate", _handle_mood_matrix_noise_animate)
	ScriptManager.register_handler("mood_matrix.noise.set_visible", _handle_mood_matrix_noise_set_visible)

	ScriptManager.register_handler("mood_matrix.noise.set_label", _handle_mood_matrix_noise_set_label)

	ScriptManager.register_handler("mood_matrix.noise.animate_in", _handle_mood_matrix_noise_animate_in)
	ScriptManager.register_handler("mood_matrix.noise.animate_out", _handle_mood_matrix_noise_animate_out)

	ScriptManager.register_handler("mood_matrix.noise.set_level", _handle_mood_matrix_noise_set_level)
	ScriptManager.register_handler("mood_matrix.noise.animate_level", _handle_mood_matrix_noise_animate_level)
	set_out()

## Animates the Mood Matrix noise UI in, animates its value to a new value while
## playing the corresponding sound clip, and then animates out.
func _handle_mood_matrix_noise_animate(args: Dictionary):
	# <mood_matrix.noise from="100" to="20" sound_code="100_s" />
	var start_value: int = %NoiseLine.noise_level
	if args.has("from"):
		start_value = int(args["from"])
	var end_value: int = int(args.get("to", "0"))
	var sound_code: String = args.get("sound_code", "100_0")
	await play_noise_animation(start_value, end_value, sound_code)

## Sets the Mood Matrix noise UI in without any intro animation.
func _handle_mood_matrix_noise_set_visible(args: Dictionary):
	# <mood_matrix.noise.set_visible value="true" />
	var now_visible: bool = args.get("value", "true") == "true"

	if now_visible:
		set_in()
	else:
		set_out()

## Sets the text for the Mood Matrix noise UI's "NOISE LEVEL" label.
func _handle_mood_matrix_noise_set_label(args: Dictionary):
	# <mood_matrix.noise.set_label text="NOISE LEVEL" />
	var new_text: String = args.get("text", "NOISE LEVEL")
	%NoiseLevelLabel.text = new_text

## Simply animates in the Mood Matrix noise UI.
func _handle_mood_matrix_noise_animate_in(_args: Dictionary):
	await animate_in().finished

## Simply animates out the Mood Matrix noise UI.
func _handle_mood_matrix_noise_animate_out(_args: Dictionary):
	await animate_out().finished

## Sets the noise value on the Mood Matrix noise UI.
func _handle_mood_matrix_noise_set_level(args: Dictionary):
	if not args.has("level"):
		Utils.print_error("mood_matrix.noise.set_level needs \"level\" argument")
		return
	var level: int = int(args["level"])
	%PercentLabel.text = "%s%%" % level
	%NoiseLine.set_noise_level(level)

func _handle_mood_matrix_noise_animate_level(args: Dictionary):
	# <mood_matrix.noise.animate_level from="100" to="0" />
	var start_value: int = %NoiseLine.noise_level
	if args.has("from"):
		start_value = int(args["from"])
	
	if not args.has("to"):
		Utils.print_error("mood_matrix.noise_animate_level needs \"to\" argument")
		return
	
	var end_value: int = int(args["to"])
	await animate_to_new(start_value, end_value).finished

func play_noise_animation(start_value: int, end_value: int, sound_code: String):
	if sound_code not in VALID_NOISE_TYPES:
		Utils.print_error("Sound code \"%s\" not valid for noise" % sound_code)
	else:
		noise_sound_player.stream = load("res://ui/mood_matrix/sounds/noise/kokoro_noise_%s.wav" % sound_code)
		noise_sound_player.play()
	
	%PercentLabel.text = "%s%%" % start_value
	%NoiseLine.set_noise_level(start_value)
	await animate_in().finished

	# For the looping-at-100% noise, we don't want to do any further animations.
	if sound_code == "100_lp":
		return

	# Most of the noise types involve animating the value - that's what we do here.
	await animate_to_new(start_value, end_value).finished

	# For noise types that end at 0%, the "logout" sound is played.
	if sound_code.ends_with("_0"):
		await get_tree().create_timer(0.55).timeout
		await blue_overlay().finished
		await get_tree().create_timer(1.0).timeout
		await animate_out().finished

	# For noise types that don't involve the Mood Matrix closing, we animate the
	# noise overlay out after a few seconds.
	else:
		await get_tree().create_timer(2.0).timeout
		await animate_out().finished
		return

func _process(_delta):
	%PercentLabel.pivot_offset = %PercentLabel.size / 2.0

func set_out():
	%CenterContent.scale.y = 0.0
	%CenterContent.modulate.a = 0.0
	%BackgroundOverlay.modulate.a = 0.0

func set_in():
	%CenterContent.scale.y = 1.0
	%CenterContent.modulate.a = 1.0
	%BackgroundOverlay.modulate.a = 1.0

var trans_tween: Tween = null
func animate_in() -> Tween:	
	if trans_tween:
		trans_tween.kill()
	trans_tween = create_tween()
	trans_tween.tween_property(%CenterContent, "scale:y", 1.0, ANIM_IN_DURATION).set_trans(Tween.TRANS_SINE)
	trans_tween.parallel().tween_property(%CenterContent, "modulate:a", 1.0, ANIM_IN_DURATION).set_trans(Tween.TRANS_SINE)
	trans_tween.parallel().tween_property(%BackgroundOverlay, "modulate:a", 1.0, ANIM_IN_DURATION).set_trans(Tween.TRANS_SINE)
	return trans_tween

func animate_out() -> Tween:
	if trans_tween:
		trans_tween.kill()
	trans_tween = create_tween()
	trans_tween.tween_property(%CenterContent, "scale:y", 0.0, ANIM_IN_DURATION).set_trans(Tween.TRANS_SINE)
	trans_tween.parallel().tween_property(%CenterContent, "modulate:a", 0.0, ANIM_IN_DURATION).set_trans(Tween.TRANS_SINE)
	trans_tween.parallel().tween_property(%BackgroundOverlay, "modulate:a", 0.0, ANIM_IN_DURATION).set_trans(Tween.TRANS_SINE)
	return trans_tween

var number_tween: Tween = null
const NEW_PULSE_DURATION: float = 0.1
func animate_to_new(start_value: int, new_value: int) -> Tween:
	var decrease_duration = 0.9 - ANIM_IN_DURATION
	if number_tween:
		number_tween.kill()
	number_tween = create_tween()
	number_tween.tween_method(func(val): %PercentLabel.text = "%s%%" % val, start_value, new_value, decrease_duration)
	
	
	# Number pulses when it reaches its new value
	var delay_for_flash: float = decrease_duration - NEW_PULSE_DURATION * 0.5
	number_tween.parallel().tween_property(%PercentLabel, "scale", Vector2.ONE * 1.3, NEW_PULSE_DURATION).set_delay(delay_for_flash)
	number_tween.parallel().tween_property(%WhiteOverlay, "color:a", 0.5, NEW_PULSE_DURATION).set_delay(delay_for_flash)
	number_tween.parallel().tween_callback(func(): %NoiseLine.set_noise_level(new_value)).set_delay(delay_for_flash)
	number_tween.tween_property(%PercentLabel, "scale", Vector2.ONE, NEW_PULSE_DURATION * 1.5)
	number_tween.tween_property(%WhiteOverlay, "color:a", 0.0, NEW_PULSE_DURATION)

	# TODO: change noise visual

	return number_tween


var blue_pulse_tween: Tween = null
func blue_overlay() -> Tween:
	if blue_pulse_tween:
		blue_pulse_tween.kill()
	blue_pulse_tween = create_tween()
	blue_pulse_tween.tween_property(%BlueOverlay, "color:a", 0.75, 0.2)
	blue_pulse_tween.parallel().tween_property(%PercentLabel, "theme_override_colors/font_outline_color:a", 1.0, 0.2)
	blue_pulse_tween.tween_property(%BlueOverlay, "color:a", 0.0, 0.6)
	blue_pulse_tween.parallel().tween_property(%PercentLabel, "theme_override_colors/font_outline_color:a", 0.0, 0.4)
	return blue_pulse_tween
