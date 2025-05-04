extends Control
var soundTween = create_tween()
var nonStop:bool = true


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	%MMenuMusic.volume_db = -80
	%MMenuMusic.play()
	soundTween.tween_property(%MMenuMusic,"volume_db",-10,1)
	
func _process(_delta):
	if nonStop:
		var x = $Camera2D.position
		var y = get_global_mouse_position()/5
		%Mountain.position = (((y+(x*-1))*-1)/20)+x
		%Cloud.position = (((y+(x*-1))*-1)/50)+x

func _on_start_pressed() -> void:
	GlobalLoadData.save_to_load_path = ""
	nonStop= false
	$Camera2D.position += Vector2(0,1800)
	await get_tree().create_timer(1.2).timeout
	get_tree().change_scene_to_file("res://Scenes/Game/game.tscn")


func _on_load_pressed() -> void:
	await get_tree().create_timer(0.1).timeout
	get_tree().change_scene_to_file("res://Scenes/MainMenu/Load_Game/Load_Game.tscn")


func _on_options_pressed() -> void:
	await get_tree().create_timer(0.1).timeout
	get_tree().change_scene_to_file("res://Scenes/MainMenu/options.tscn")


func _on_quit_pressed() -> void:
	await get_tree().create_timer(0.1).timeout
	get_tree().quit()
