extends Window

@onready var room_placement_sript = load("res://Scripts/room_placement.gd")

signal empty_room(room:Room)
var current_room :Room
var empty_price : int = -1

func _on_close_requested() -> void:
	queue_free()

func _on_focus_exited() -> void:
	queue_free()

func _on_empty_room_pressed() -> void:
	empty_room.connect(get_parent().get_parent().get_parent()._empty_room)
	empty_room.emit(current_room,empty_price)
	if %Separator.visible == false:
		%Separator.visible = true
		%Empty_room.visible = false
		

func _current_room(cRoom:Room):
	current_room = cRoom
		
	%Img.set_region_rect(room_placement_sript.roomImage(cRoom.Name))
	
	if cRoom.Status.size() > 0:
		%Separator.visible = false
		%Empty_room.text = "Emty "+ cRoom.Status[0] +" for xxx"
		%Empty_room.visible = true
		
		
		
		if cRoom.Status[0].contains("GAS"):
			%Empty_room.text = "Empty "+ cRoom.Status[0] +" for 10R"
			empty_price = 10
		elif cRoom.Status[0].contains("WATER"):
			%Empty_room.text = "Empty "+ cRoom.Status[0] +" for 5R"
			empty_price = 5
		elif cRoom.Status[0].contains("LAVA"):
			%Empty_room.text = "Empty "+ cRoom.Status[0] +" for 20R"
			empty_price = 20
		
	else:
		%Separator.visible = true
		%Empty_room.visible = false
