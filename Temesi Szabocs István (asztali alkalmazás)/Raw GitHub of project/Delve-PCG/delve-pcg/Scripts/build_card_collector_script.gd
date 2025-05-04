extends Node2D

var card_width
var buildable_types:Array[String]
var built_room_list:Dictionary
var current_currency:Vector2
var placer_start_position
var selected_room:Room
var isStorehouse : bool
@onready var Card = load("res://Scenes/Game/Assets/UI/Build_UI/Build_card_ui.tscn")
@onready var TempRoom = load("res://Scenes/Game/Assets/Rooms/TemplateRoom.tscn")
@onready var FilterButton = load("res://Scenes/Game/Assets/UI/Build_UI/Filter_button_ui.tscn")

var full_rooms = JSON.parse_string(FileAccess.get_file_as_string("res://Resources/Data/AllRooms.json"))

signal fill_room(roomData:Dictionary,can_build:bool)
signal build_room_resp(Name:String,Target:Room)



func _input(event: InputEvent) -> void:
	if event.is_action("mouse_wheel_up"):
		$Card_bg/HScrollBar.value +=1
	
	if event.is_action("mouse_wheel_down"):
		$Card_bg/HScrollBar.value -=1


func _on_h_scroll_bar_value_changed(value: float) -> void:
	%Card_collector.offset = Vector2(card_width*-value,0)
	
func _on_get_data(rRoom:Room,currency:Vector2,built_rooms:Dictionary,storehouse:bool):
	built_room_list = built_rooms
	current_currency = currency
	placer_start_position = %Placer.position
	selected_room = rRoom
	isStorehouse = storehouse
	var rooms:Array
	for room in full_rooms:
		if room.Cost != "-1_-1":
			rooms.push_back(room)
	
	$Card_bg/HScrollBar.max_value = rooms.size()-4
	for room in rooms:
		if buildable_types.find(room.Subtype) == -1:
			buildable_types.push_back(room.Subtype)
		var inst_Card = Card.instantiate()
		
		card_width = inst_Card.get_child(0).size[0]
		inst_Card.position = %Placer.position
		%Placer.position += Vector2(inst_Card.get_child(0).size[0]+5,0)
		%Card_collector.add_child(inst_Card)
		
		fill_room.connect(%Card_collector.get_child(%Card_collector.get_child_count()-1)._room_build_request)
		if room.Subtype == "TRAP" and built_room_list.FORGE.size()==0:
			fill_room.emit(room,false,isStorehouse)
			fill_room.disconnect(%Card_collector.get_child(%Card_collector.get_child_count()-1)._room_build_request)
		elif room.Subtype == "BARRICADE" and built_room_list.MASON.size()==0:
			fill_room.emit(room,false,isStorehouse)
			fill_room.disconnect(%Card_collector.get_child(%Card_collector.get_child_count()-1)._room_build_request)
		elif (current_currency[0] >= int(room.Cost.split('_')[0]) and current_currency[1] >= int(room.Cost.split('_')[1])) and !isStorehouse : 
			fill_room.emit(room,true,isStorehouse)
			fill_room.disconnect(%Card_collector.get_child(%Card_collector.get_child_count()-1)._room_build_request)
		elif (current_currency[0] >= int(room.Cost.split('_')[0]) and current_currency[1] >= floor(int(room.Cost.split('_')[1])/2)) and isStorehouse : 
			fill_room.emit(room,true,isStorehouse)
			fill_room.disconnect(%Card_collector.get_child(%Card_collector.get_child_count()-1)._room_build_request)
		else:
			fill_room.emit(room,false,isStorehouse)
			fill_room.disconnect(%Card_collector.get_child(%Card_collector.get_child_count()-1)._room_build_request)
		
		
	
	for filter in buildable_types:
		var button = FilterButton.instantiate()
		button.text = filter
		%Filter_button_collector.add_child(button)
		
	var inst_TempRoom = TempRoom.instantiate()
	inst_TempRoom.position = %TempRoomPlacer.position
	inst_TempRoom.get_child(0).get_child(0).text = str(selected_room.Coordinate)
	inst_TempRoom.get_child(0).get_child(1).text = str(selected_room.Name)
	inst_TempRoom.get_child(0).get_child(2).text = str(selected_room.Room_id)
	%TempRoomPlacer.add_child(inst_TempRoom)
	
func _on_filter_pressed(filter:String):
	for child in %Card_collector.get_children():
		child.queue_free()
	
	%Placer.position = placer_start_position
	
	var rooms:Array
	for room in full_rooms:
		if room.Cost != "-1_-1" and room.Subtype == filter:
			rooms.push_back(room)
	
	for room in rooms:
		if buildable_types.find(room.Subtype) == -1:
			buildable_types.push_back(room.Subtype)
		var inst_Card = Card.instantiate()
		
		card_width = inst_Card.get_child(0).size[0]
		inst_Card.position = %Placer.position
		%Placer.position += Vector2(inst_Card.get_child(0).size[0]+5,0)
		%Card_collector.add_child(inst_Card)
		
		fill_room.connect(%Card_collector.get_child(%Card_collector.get_child_count()-1)._room_build_request)
		if room.Subtype == "TRAP" and built_room_list.FORGE.size()==0:
			fill_room.emit(room,false,isStorehouse)
			fill_room.disconnect(%Card_collector.get_child(%Card_collector.get_child_count()-1)._room_build_request)
		elif room.Subtype == "BARRICADE" and built_room_list.MASON.size()==0:
			fill_room.emit(room,false,isStorehouse)
			fill_room.disconnect(%Card_collector.get_child(%Card_collector.get_child_count()-1)._room_build_request)
		elif (current_currency[0] >= int(room.Cost.split('_')[0]) and current_currency[1] >= int(room.Cost.split('_')[1])) and !isStorehouse : 
			fill_room.emit(room,true,isStorehouse)
			fill_room.disconnect(%Card_collector.get_child(%Card_collector.get_child_count()-1)._room_build_request)
		elif (current_currency[0] >= int(room.Cost.split('_')[0]) and current_currency[1] >= floor(int(room.Cost.split('_')[1])/2)) and isStorehouse : 
			fill_room.emit(room,true,isStorehouse)
			fill_room.disconnect(%Card_collector.get_child(%Card_collector.get_child_count()-1)._room_build_request)
		else:
			fill_room.emit(room,false,isStorehouse)
			fill_room.disconnect(%Card_collector.get_child(%Card_collector.get_child_count()-1)._room_build_request)

func _build_room(Name:String,price:Vector2):
	build_room_resp.connect(get_parent().get_parent().get_parent()._build_room)
	build_room_resp.emit(Name,selected_room,price)
	pass


func _on_close_build_window_pressed() -> void:
	build_room_resp.connect(get_parent().get_parent().get_parent()._build_room)
	build_room_resp.emit("EXIT",Room.new(),Vector2(-1,-1))
	for child in get_parent().get_children():
		child.queue_free()
