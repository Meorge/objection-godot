extends Control

@onready var _happy_marker: MoodMatrixMarker = %Happy
@onready var _sad_marker: MoodMatrixMarker = %Sad
@onready var _angry_marker: MoodMatrixMarker = %Angry
@onready var _surprised_marker: MoodMatrixMarker = %Surprised

func set_markers_thinking():
	_happy_marker.set_thinking()
	_sad_marker.set_thinking()
	_angry_marker.set_thinking()
	_surprised_marker.set_thinking()

func set_markers_inactive():
	_happy_marker.set_inactive()
	_sad_marker.set_inactive()
	_angry_marker.set_inactive()
	_surprised_marker.set_inactive()