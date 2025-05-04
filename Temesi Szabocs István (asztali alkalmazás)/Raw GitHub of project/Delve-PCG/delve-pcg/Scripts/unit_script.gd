extends Node2D

@onready var unit_sprite = load("res://Scenes/Game/Assets/Units/Unit_visible.tscn")

signal move_request

func get_unit(friendly : String, uName : String):
	var cords = [0,0,8,10]
	var inst_unit =unit_sprite.instantiate()
	match friendly:
		"friendly":
			cords[1] = 117
		"neutral":
			cords[1] = 128
		"hostile":
			cords[1] = 139
		_:
			cords[1] = 106
	
	
	match name:
		_:
			match friendly:
				"friendly":
					cords[0] = 281
				"neutral":
					cords[0] = 308
				"hostile":
					cords[0] = 317
				_:
					cords[0] = 326
	inst_unit.get_child(0).region_rect = Rect2(cords[0],cords[1],cords[2],cords[3])
	
	return inst_unit

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	move_request.connect(get_parent().get_parent().get_parent()._move_friendly_unit)
	var friendly
	#print ($ColorRect.color)
	match $ColorRect.color:
		Color(0,1,0,1):
			friendly = "friendly"
		Color(1,1,0,1):
			friendly = "neutral"
		Color(1,0,0,1):
			friendly = "hostile"
	
	var units : OptionButton = %Multi
	if units.item_count > 1:
		for x in units.item_count:
			%Visuals.add_child(get_unit(friendly,units.get_item_text(x)))
			#print(str(units.item_count)+" "+friendly+" units")
	else:
		#print("1 "+friendly+" unit")
		%Visuals.add_child(get_unit(friendly,%Solo.text))



func _on_move_selected_pressed() -> void:
	%Move_selected.disabled = true
	if %Solo.visible:
		move_request.emit({"ID":0,"Single":true})
	elif %Multi.visible:
		move_request.emit({"ID":%Multi.selected,"Single":true})


func _on_move_all_pressed() -> void:
	if %Solo.visible:
		move_request.emit({"ID":null,"Single":false})
	elif %Multi.visible:
		move_request.emit({"ID":null,"Single":false})


func _on_multi_item_selected(index: int) -> void:
	%Move_selected.disabled = false
