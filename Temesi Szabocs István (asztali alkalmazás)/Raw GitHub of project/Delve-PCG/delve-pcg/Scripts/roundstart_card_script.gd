extends ColorRect

signal window_resoult
var Room_name = ""

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	window_resoult.connect(get_parent().get_parent().get_parent().get_parent().get_parent().get_parent()._roundstart_effect_response)
	Room_name = %Tittle.text

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_yes_button_pressed() -> void:
	window_resoult.emit({"Name":Room_name,"Response":true})
	queue_free()


func _on_no_button_pressed() -> void:
	window_resoult.emit({"Name":Room_name,"Response":false})
	queue_free()
