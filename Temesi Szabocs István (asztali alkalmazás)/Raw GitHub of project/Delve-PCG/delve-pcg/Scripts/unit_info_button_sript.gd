extends Button

@onready var U_info = load("res://Scenes/Game/Assets/UI/Info_UI/Info_card_unit.tscn")

@onready var AllUnits_as_dict = JSON.parse_string(FileAccess.get_file_as_string("res://Resources/Data/AllUnits.json"))

func _on_pressed() -> void:
	var inst_u_info = U_info.instantiate()
	inst_u_info.position = get_global_mouse_position()
	for unit in AllUnits_as_dict:
		if unit.Unit == $".".text:
			inst_u_info.title = unit.Unit
			inst_u_info.get_child(0).get_child(1).text = unit.Power[0]+" "+unit.Power[1]
	get_parent().get_parent().get_parent().get_parent().add_child(inst_u_info)
