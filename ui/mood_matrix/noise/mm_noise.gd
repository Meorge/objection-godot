extends Control

const ANIM_IN_DURATION = 0.3

@onready var noise_sound_player: AudioStreamPlayer = %NoiseSound

const VALID_NOISE_TYPES = ["100_0", "100_lp", "100_m", "100_s", "m_0", "m_100", "m_s", "s_0", "s_m"]

# Called when the node enters the scene tree for the first time.
func _ready():
	set_out()
	await get_tree().create_timer(3.0).timeout
	play_noise_animation(100, 20, "100_s")

func play_noise_animation(start_value: int, end_value: int, sound_code: String):
	if sound_code not in VALID_NOISE_TYPES:
		Utils.print_error("Sound code \"%s\" not valid for noise" % sound_code)
	else:
		noise_sound_player.stream = load("res://ui/mood_matrix/sounds/noise/kokoro_noise_%s.wav" % sound_code)
		noise_sound_player.play()
	
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

func _process(delta):
	%PercentLabel.pivot_offset = %PercentLabel.size / 2.0

func set_out():
	%CenterContent.scale.y = 0.0
	%CenterContent.modulate.a = 0.0
	%BackgroundOverlay.modulate.a = 0.0

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