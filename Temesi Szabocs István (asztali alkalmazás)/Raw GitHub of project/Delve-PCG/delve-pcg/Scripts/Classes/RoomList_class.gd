extends Node

class_name RoomList

class sepRoom:
	var Name : String = "NameMe"
	var Subtype : String = "Placeholder"
	var Price : Vector2 = Vector2(-1,-1)

var BuildableRooms : Array[sepRoom]

var file = "res://Resources/Data/AllRooms.json"
var json_as_text = FileAccess.get_file_as_string(file)
var json_as_dict = JSON.parse_string(json_as_text)

func fill_BuildableRooms():
	for room in json_as_dict:
		var temp_room = sepRoom.new()
		temp_room.Name = room.Name
		temp_room.Subtype = room.Subtype
		var cost = room.Cost.split("_")
		temp_room.Price = Vector2(int(cost[0]),int(cost[1]))
		if temp_room.Price != Vector2(-1,-1):
			BuildableRooms.push_back(temp_room)
