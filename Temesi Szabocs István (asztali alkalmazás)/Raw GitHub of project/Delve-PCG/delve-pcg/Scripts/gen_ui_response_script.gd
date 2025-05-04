extends ColorRect

signal window_resoult
var Room_name = ""

func close_window():
	get_parent().queue_free()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	window_resoult.connect(get_parent().get_parent().get_parent().get_parent().get_parent().get_parent().get_parent()._roundstart_effect_response)

func _get_room_name(name):
	Room_name = name

func _on_yes_pressed() -> void:
	if Room_name != "":
		window_resoult.emit({"Name":Room_name,"Response":true})
		close_window()

func _on_no_pressed() -> void:
	if Room_name != "":
		window_resoult.emit({"Name":Room_name,"Response":false})
		close_window()
