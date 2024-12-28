class_name Camera
extends Camera2D

var tw: Tween = null

var current_position: String = "center"

static var instance: Camera = null

signal cut_performed(new_position: String)
signal pan_will_be_performed(old_position: String, new_position: String)

func _enter_tree():
    instance = self
    
func _ready():
    ScriptManager.register_handler("cut", _handle_cut)
    ScriptManager.register_handler("pan", _handle_pan)

func _handle_cut(args: Dictionary):
    var dest = args.get("to", "center")
    global_position = CameraPosition.positions[dest].global_position
    if tw: tw.kill()
    current_position = dest
    cut_performed.emit(current_position)

func _handle_pan(args: Dictionary):
    var dest = args.get("to", "center")

    if tw:
        tw.kill()
    
    tw = create_tween()
    var target_global_position: Vector2 = CameraPosition.positions[dest].global_position
    tw.tween_property(self, "global_position", target_global_position, 0.5).set_trans(Tween.TRANS_SINE)
    tw.tween_callback(func(): current_position = dest)
    pan_will_be_performed.emit(current_position, dest)
