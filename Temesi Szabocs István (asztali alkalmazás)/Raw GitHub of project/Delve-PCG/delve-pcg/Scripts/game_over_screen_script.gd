extends Node2D

func _on_button_mm_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/MainMenu/main_menu.tscn")


func _on_button_ng_pressed() -> void:
	GlobalLoadData.save_to_load_path = ""
	get_tree().change_scene_to_file("res://Scenes/Game/game.tscn")
