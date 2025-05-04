extends Node2D

var all_units = JSON.parse_string(FileAccess.get_file_as_string("res://Resources/Data/AllUnits.json"))

@onready var unit_card = load("res://Scenes/Game/Assets/UI/Recruit_UI/Recruit_card_ui.tscn")

var target_room:Room

signal unit_recruit_request(Tittle:String,Price:Vector2,Effect:String,STR:int)
signal recruit_unit(Name:String,Strength:int,price:Vector2)

func _window_open(currentRoom:Room,currentMoney:Vector2):
	target_room = currentRoom
	%SelectedRoomName.text = currentRoom.Name
	for unit in all_units:
		if unit.Origin.find(currentRoom.Name) != -1:
			var inst_unit_card = unit_card.instantiate()
			inst_unit_card.position = %Placer.position
			if float(unit.Cost) > currentMoney[1]:
				inst_unit_card.get_child(0).color = Color(0.9,0.5,0.5)
				inst_unit_card.get_child(1).disabled = true
			%CardCollector.add_child(inst_unit_card)
			%Placer.position[0] += get_child(0).get_child(0).get_child(0).get_child(0).size[0]+5
			unit_recruit_request.connect(%CardCollector.get_child(%CardCollector.get_child_count()-1)._unit_recruit_request)
			unit_recruit_request.emit(unit.Unit,Vector2(0,int(unit.Cost)),unit.Power[1],int(unit.STR))
			#print("REQ sent: "+unit.Unit)
			unit_recruit_request.disconnect(%CardCollector.get_child(%CardCollector.get_child_count()-1)._unit_recruit_request)

func _recruit_unit(Name:String,Strength:int,price:Vector2):
	recruit_unit.connect(get_parent().get_parent().get_parent()._recruit_unit)
	for unit in all_units:
		if unit.Unit == Name:
			recruit_unit.emit(Name,Strength,unit.Power[0],target_room,price)


func _on_close_build_window_pressed() -> void:
	recruit_unit.connect(get_parent().get_parent().get_parent()._recruit_unit)
	recruit_unit.emit("EXIT",0,"0",Room.new(),Vector2(0,0))
	for child in get_parent().get_children():
		child.queue_free()
