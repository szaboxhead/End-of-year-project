extends Node2D

var filepath : String
var type : String

signal save_to_cloud()
signal save_to_file()

signal delete()


func _ready() -> void:
	if GlobalAllTimeData.login["UID"] != null && GlobalAllTimeData.login["Pass"] != null:
		%Save.disabled = false

func _on_button_pressed() -> void:
	#print(type)
	match type:
		"cloud":
			save_to_file.connect(get_parent().get_parent().get_parent()._local_save_requset)
			var split = filepath.split('/')
			save_to_file.emit(split[split.size()-1].replace(".json",""))
			save_to_file.disconnect(get_parent().get_parent().get_parent()._local_save_requset)
		"local":
			GlobalLoadData.save_to_load_path = filepath
			get_tree().change_scene_to_file("res://Scenes/Game/game.tscn")
		

func _recieve_file_path(path,save_loc)->void:
	filepath = path
	type = save_loc
	match save_loc:
		"cloud":
			%Save.visible = false
			%Delete.position += Vector2(0,30)
			$ColorRect/Button.text = "Save to Local"
			
			
			


func _on_save_pressed():
	save_to_cloud.connect(get_parent().get_parent().get_parent()._save_requset)
	var split = filepath.split('/')
	save_to_cloud.emit(split[split.size()-1].replace(".json",""))
	save_to_cloud.disconnect(get_parent().get_parent().get_parent()._save_requset)


func _on_delete_pressed():
	delete.connect(get_parent().get_parent().get_parent()._delete_requset)
	var split = filepath.split('/')
	delete.emit(split[split.size()-1].replace(".json",""),type)
