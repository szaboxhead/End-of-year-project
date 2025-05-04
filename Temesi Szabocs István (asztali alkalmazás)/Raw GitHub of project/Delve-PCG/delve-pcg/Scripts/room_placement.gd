extends Node

static func checkTopLeft(rooms: Array[Room], room : Room,grid_size: Vector2):
	var rIdx = rooms.rfind(room)
	if rIdx - grid_size[1]-1 >= 0:
		if rooms[rIdx].Room_id == rooms[rIdx-grid_size[1]-1].Room_id:
			return true
	return false

static func checkLeft(rooms: Array[Room], room : Room,grid_size: Vector2):
	var rIdx = rooms.rfind(room)
	if rIdx - grid_size[1] >= 0:
		if rooms[rIdx].Room_id == rooms[rIdx-grid_size[1]].Room_id:
			return true
	return false

static func checkBottomLeft(rooms: Array[Room], room : Room,grid_size: Vector2):
	var rIdx = rooms.rfind(room)
	if rIdx - grid_size[1]+1 >= 0:
		if rooms[rIdx].Room_id == rooms[rIdx-grid_size[1]+1].Room_id:
			return true
	return false

static func checkBottom(rooms: Array[Room], room : Room,_grid_size: Vector2):
	var rIdx = rooms.rfind(room)
	if rIdx + 1 < rooms.size():
		if rooms[rIdx].Room_id == rooms[rIdx + 1].Room_id:
			return true
	return false

static func checkBottomRight(rooms: Array[Room], room : Room,grid_size: Vector2):
	var rIdx = rooms.rfind(room)
	if rIdx + grid_size[1]+2 < rooms.size():
		if rooms[rIdx].Room_id == rooms[rIdx + grid_size[1]+1].Room_id:
			return true
	return false

static func checkRight(rooms: Array[Room], room : Room,grid_size: Vector2):
	var rIdx = rooms.rfind(room)
	if rIdx + grid_size[1] < rooms.size():
		if rooms[rIdx].Room_id == rooms[rIdx + grid_size[1]].Room_id:
			return true
	return false
	
static func checkTopRight(rooms: Array[Room], room : Room,grid_size: Vector2):
	var rIdx = rooms.rfind(room)
	if rIdx + grid_size[1]-1 < rooms.size():
		if rooms[rIdx].Room_id == rooms[rIdx + grid_size[1]-1].Room_id:
			return true
	return false

static func checkTop(rooms: Array[Room], room : Room,_grid_size: Vector2):
	var rIdx = rooms.rfind(room)
	if rIdx - 1 >= 0:
		if rooms[rIdx].Room_id == rooms[rIdx-1].Room_id:
			return true
	return false

static func connection(rooms: Array[Room], room : Room,grid_size: Vector2):
	var sides = [checkTopLeft(rooms,room,grid_size),checkLeft(rooms,room,grid_size),checkBottomLeft(rooms,room,grid_size),checkBottom(rooms,room,grid_size),checkBottomRight(rooms,room,grid_size),checkRight(rooms,room,grid_size),checkTopRight(rooms,room,grid_size),checkTop(rooms,room,grid_size)]
	#print(str(room.Coordinate)+" : "+str(sides))
	match sides:
		[_, false, _, true, true, true, _, false]: #0:0
			return Rect2(0,0,130,90)
		[_, true, true, true, true, true, _, false]: #1:0
			return Rect2(130,0,130,90)
		[_, true, true, true, _, false, _, false]: #2:0
			return Rect2(260,0,130,90)
		[_, false, _, true, false, true, _, false]: #3:0
			return Rect2(390,0,130,90)
		[_, true, false, true, _, false, _, false]: #4:0
			return Rect2(520,0,130,90)
		[false, false, false, true, false, true, true, true]: #5:0
			return Rect2(650,0,130,90)
		[false, true, false, true, true, true, false, false]: #6:0
			return Rect2(780,0,130,90)
			
		[false, false, false, true, true, true, true, true]: #0:1
			return Rect2(0,90,130,90)
		[true, true, true, true, true, true, true, true]: #1:1
			return Rect2(130,90,130,90)
		[true, true, true, true, false, false, false, true]: #2:1
			return Rect2(260,90,130,90)
		[_, false, _, false, _, true, false, true]: #3:1
			return Rect2(390,90,130,90)
		[false, true, _, false, _, false, _, true]: #4:1
			return Rect2(520,90,130,90)
		[true, true, false, false, false, true, false, true]: #5:1
			return Rect2(650,90,130,90)
		[false, true, true, true, false, false, false, true]: #6:1
			return Rect2(780,90,130,90)
			
		[_, false, _, false, _, true, true, true]: #0:2
			return Rect2(0,180,130,90)
		[true, true, false, false, false, true, true, true]: #1:2
			return Rect2(130,180,130,90)
		[true, true, _, false, _, false, _, true]: #2:2
			return Rect2(260,180,130,90)
		[true, true, true, true, false, true, true, true]: #3:2
			return Rect2(390,180,130,90)
		[true, true, false, true, true, true, true, true]: #4:2
			return Rect2(520,180,130,90)
		[false, true, true, true, false, true, false, false]: #5:2
			return Rect2(650,180,130,90)
		[true, true, false, true, false, false, _, true]: #6:2
			return Rect2(780,180,130,90)
			
		[_, false, _, false, _, true, _, false]: #0:3
			return Rect2(0,270,130,90)
		[_, true, _, false, _, true, _, false]: #1:3
			return Rect2(130,270,130,90)
		[_, true, _, false, _, false, _, false]: #2:3
			return Rect2(260,270,130,90)
		[true, true, true, true, true, true, false, true]: #3:3
			return Rect2(390,270,130,90)
		[false, true, true, true, true, true, true, true]: #4:3
			return Rect2(520,270,130,90)
		[false, false, false, true, true, true, false, true]: #5:3
			return Rect2(650,270,130,90)
		[false, true, false, false, false, true, true, true]: #6:3
			return Rect2(780,270,130,90)
			
		[_, false, _, true, _, false, _, false]: #0:4
			return Rect2(0,360,130,90)
			
		[_, false, _, true, _, false, _, true]: #0:5
			return Rect2(0,450,130,90)
			
		[_, false, _, false, _, false, _, true]: #0:6
			return Rect2(0,540,130,90)
		
		
	
	return Rect2(130,360,130,90)

static func roomImage(name:String):
	match name:
		"ENTRANCE": 
			return	Rect2(0, 0, 32, 18)
		"BARRACKS": 
					return	Rect2(35, 0, 32, 18)
		"CANNON_OUTPOST": 
					return	Rect2(70, 0, 32, 18)
		"FORGE": 
					return	Rect2(105, 0, 32, 18)
		"MASON": 
					return	Rect2(140, 0, 32, 18)
		"INN": 
					return	Rect2(175, 0, 32, 18)
		"KENNEL": 
					return	Rect2(210, 0, 32, 18)
		"LABORATORY": 
					return	Rect2(245, 0, 32, 18)
		"LIBRARY": 
					return	Rect2(280, 0, 32, 18)
		"PRISON": 
					return	Rect2(315, 0, 32, 18)
		"DORMS": 
					return	Rect2(0, 21, 32, 18)
		"HOSPITAL": 
					return	Rect2(35, 21, 32, 18)
		"KITCHEN": 
					return	Rect2(70, 21, 32, 18)
		"OVERSEERS_OFFICE": 
					return	Rect2(105, 21, 32, 18)
		"SHRINE": 
					return	Rect2(140, 21, 32, 18)
		"STOCKPILE": 
					return	Rect2(175, 21, 32, 18)
		"STOREHOUSE": 
					return	Rect2(210, 21, 32, 18)
		"TEMPLE": 
					return	Rect2(245, 21, 32, 18)
		"TREASURY": 
					return	Rect2(280, 21, 32, 18)
		"PUMP": 
					return	Rect2(315, 21, 32, 18)
		"INVENTORS_LAB": 
					return	Rect2(0, 42, 32, 18)
		"BREEDER": 
					return	Rect2(35, 42, 32, 18)
		"DAMAGE_TRAPS": 
					return	Rect2(70, 42, 32, 18)
		"STOPPING_TRAPS": 
					return	Rect2(105, 42, 32, 18)
		"UNDERGROUND_FOREST": 
					return	Rect2(140, 42, 32, 18)
		"NATURAL_MAGIC_CAVE": 
					return	Rect2(175, 42, 32, 18)
		"UNDERGROUND_RIVER": 
					return	Rect2(210, 42, 32, 18)
		"CAVERN": 
					return	Rect2(245, 42, 32, 18)
		"CRYSTAL_CAVERN": 
					return	Rect2(280, 42, 32, 18)
		"MAGMA_FLOW": 
					return	Rect2(315, 42, 32, 18)
		"UNDERGROUND_LAKE": 
					return	Rect2(0, 63, 32, 18)
		"HIVE_OF_CREATURES": 
					return	Rect2(35, 63, 32, 18)
		"VOLCANIC_SHAFT": 
					return	Rect2(70, 63, 32, 18)
		"MONSTER_VILLAGE": 
					return	Rect2(105, 63, 32, 18)
		"FORGOTTEN_CRYPTS": 
					return	Rect2(140, 63, 32, 18)
		"WISHING_WELL": 
					return	Rect2(175, 63, 32, 18)
		"SEALED_ROOM": 
					return	Rect2(210, 63, 32, 18)
		"ABANDONED_MINE": 
					return	Rect2(245, 63, 32, 18)
		"BURRIED_TEMPLE": 
					return	Rect2(280, 63, 32, 18)
		"ABANDONED_ROOM": 
					return	Rect2(315, 63, 32, 18)
		"ANCHIENT_LIBRARY": 
					return	Rect2(0, 84, 32, 18)
		"DEMON_PORAL": 
					return	Rect2(35, 84, 32, 18)
		"GOLEM_FORGE": 
					return	Rect2(70, 84, 32, 18)
		"SLUMBERING_WYRM": 
					return	Rect2(105, 84, 32, 18)
		"HALLS_OF_THE_LICH_KING": 
					return	Rect2(140, 84, 32, 18)
		"BONE_CAVE": 
					return	Rect2(175, 84, 32, 18)
		"SLIME_CAVE": 
					return	Rect2(210, 84, 32, 18)
		"MEAT_CAVE": 
					return	Rect2(245, 84, 32, 18)
		"NUT_&_SQUIRELL_CAVE": 
					return	Rect2(280, 84, 32, 18)
		"GOD_MUSHROOM_CAVE": 
					return	Rect2(315, 84, 32, 18)
		"TIME_CRYSTALS": 
					return	Rect2(0, 105, 32, 18)
		"LIVING_FOSSILS": 
					return	Rect2(35, 105, 32, 18)
		"MOLE_VILLAGE": 
					return	Rect2(70, 105, 32, 18)
		"CRYSTAL_DWARFT_WITH_ARTEFACT": 
					return	Rect2(105, 105, 32, 18)
		"SMART_CREATURE": 
					return	Rect2(140, 105, 32, 18)
		"WHISTLING_CAVE": 
					return	Rect2(175, 105, 32, 18)
		"REALM_OF_LOST_THINGS": 
					return	Rect2(210, 105, 32, 18)
		"VOID_CRISTAL": 
					return	Rect2(245, 105, 32, 18)
		
		_:
			return	Rect2(245, 42, 32, 18)

static func place_unit(room:Room,inst_unit,inst_room):
	inst_unit.position = Vector2(0,0)
	
	if room.Units.size() > 1:
		inst_unit.get_child(0).get_child(0).visible = false
		inst_unit.get_child(0).get_child(1).visible = true
		for unit in room.Units:
			#print(unit.Name," is ",unit.Placed)
			if unit.Moved == false:
				inst_unit.get_child(0).get_child(1).add_item(unit.Name+"_"+str(unit.Str)+"Str 🟩")
			else:
				inst_unit.get_child(0).get_child(1).add_item(unit.Name+"_"+str(unit.Str)+"Str 🟥")
			#print(unit.Name," is placed into options")
			unit.Placed = true
		
		match room.Units[0].Hostile:
			"Yes":
				inst_unit.get_child(0).color = Color(1,0,0)
				inst_unit.get_child(1).visible = false
				inst_unit.get_child(2).visible = false
			"No":
				inst_unit.get_child(0).color = Color(0,1,0)
				inst_unit.get_child(1).visible = true
				inst_unit.get_child(2).visible = true
			"Neutral":
				inst_unit.get_child(0).color = Color(1,1,0)
				inst_unit.get_child(1).visible = false
				inst_unit.get_child(2).visible = false
				
		inst_room.get_child(0).get_child(5).add_child(inst_unit)
		print("Placed multiple units...")

	elif room.Units.size() == 1:
		inst_unit.get_child(0).get_child(1).visible = false
		inst_unit.get_child(0).get_child(0).visible = true
		inst_unit.get_child(1).visible = false
		if room.Units[0].Moved == false:
			inst_unit.get_child(0).get_child(0).text = room.Units[0].Name+"_"+str(room.Units[0].Str)+"Str 🟩"
		else:
			inst_unit.get_child(0).get_child(0).text = room.Units[0].Name+"_"+str(room.Units[0].Str)+"Str 🟥"
		room.Units[0].Placed = true
		match room.Units[0].Hostile:
			"Yes":
				inst_unit.get_child(0).color = Color(1,0,0)
				inst_unit.get_child(1).visible = false
				inst_unit.get_child(2).visible = false
			"No":
				inst_unit.get_child(0).color = Color(0,1,0)
				inst_unit.get_child(1).visible = true
				inst_unit.get_child(2).visible = true
			"Neutral":
				inst_unit.get_child(0).color = Color(1,1,0)
				inst_unit.get_child(1).visible = false
				inst_unit.get_child(2).visible = false
		inst_room.get_child(0).get_child(5).add_child(inst_unit)
		print("Placed a unit...")
	return room
	
static func remove_units(room:Room):
	for unit in room.Pointer.get_child(0).get_child(5).get_children():
		unit.queue_free()

static func place_status(room:Room,inst_status,inst_room):
	inst_status.position = Vector2(0,0)
	for status in room.Status:
		inst_status.get_child(0).get_child(0).text += status+"_"
		inst_room.get_child(0).get_child(6).add_child(inst_status)
		#print("Placed room condition...")
		room.Status_placed = true
	return room

static func remove_status(room:Room):
	for status in room.Pointer.get_child(0).get_child(6).get_children():
		status.queue_free()

static func temp_place(rooms: Array[Room], temp_room, temp_unit, temp_status, room_collector:Object ,grid_size: Vector2):
	var local_rooms = rooms
	for room in local_rooms:
		if room.Name != "none":
			var inst_room = temp_room.instantiate()
			var inst_unit = temp_unit.instantiate()
			var inst_status = temp_status.instantiate()
			
			inst_room.position = room.Coordinate
			inst_room.get_child(0).get_child(0).text = room.Name
			inst_room.get_child(0).get_child(1).text = str(room.Coordinate)
			inst_room.get_child(0).get_child(2).text = str(room.Room_id)
			inst_room.get_child(0).get_child(3).region_rect = connection(rooms,room,grid_size)
			inst_room.get_child(0).get_child(3).get_child(0).set_visible(room.Hidden)
			inst_room.get_child(0).get_child(7).set_region_rect(roomImage(room.Name))

			
			if room.Units.size() > 0:
				room = place_unit(room,inst_unit,inst_room)
			
			if room.Status.size()> 0:
				room = place_status(room,inst_status,inst_room)
			
			local_rooms[local_rooms.find(room)].Pointer = inst_room
			room_collector.add_child(inst_room)
	return local_rooms

static func redraw(rooms: Array[Room], temp_unit, temp_status, grid_size: Vector2,room_collector : Node2D):
	var all_rooms = room_collector.get_children()
	for room in rooms:
		remove_units(room)
		remove_status(room)
		for placed_room in all_rooms:
			if room.Pointer == placed_room:
				var inst_unit = temp_unit.instantiate()
				var inst_status = temp_status.instantiate()
				
				placed_room.get_child(0).get_child(0).text = room.Name
				placed_room.get_child(0).get_child(1).text = str(room.Coordinate)
				placed_room.get_child(0).get_child(2).text = str(room.Room_id)
				placed_room.get_child(0).get_child(2).text = str(room.Room_id)
				if room.Buildable == true:
					placed_room.get_child(0).get_child(3).region_rect = Rect2(520,450,130,90)
				else:
					placed_room.get_child(0).get_child(3).region_rect = connection(rooms,room,grid_size)
				placed_room.get_child(0).get_child(3).get_child(0).set_visible(room.Hidden)
				placed_room.get_child(0).get_child(7).set_region_rect(roomImage(room.Name))
				
				if room.Units.size() > 0:
					room = place_unit(room,inst_unit,placed_room)
				
				if room.Status.size()> 0:
					room = place_status(room,inst_status,placed_room)
				else:
					pass
	return rooms
