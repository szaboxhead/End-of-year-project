extends Node

static func generate_coordinates(grid_size : Vector2i, room_size : Vector2): #Done
	print("Generating coordinates...")
	var window_size = DisplayServer.window_get_size()
	var start_pos : Vector2 = Vector2(window_size[0]/2,room_size[1]/2)-Vector2((grid_size[0]/2)*room_size[0],0)
	var current_pos : Vector2 = start_pos
	
	var ret : Array[Room]
	
	for _width in grid_size[0]:
		for _height in grid_size[1]:
			var aRoom : Room = Room.new()
			aRoom.Coordinate = current_pos
			ret.push_back(aRoom)
			current_pos += Vector2(0,room_size[1])
		current_pos = Vector2(current_pos[0] + room_size[0],start_pos[1])
	print("Done")
	return ret

static func generate_blockers(grid_size : Vector2, rooms : Array[Room], count : int = 1): #Done
	print("Genaerating blockers...")
	var start = rooms.pick_random()
	var local_rooms = rooms
	var current_room = start
	for _x in count:
		var rand1 = int(round(randf_range(0,2)))
		match rand1:
			0:
				print("Underground river")
				if ((rooms.find(start)+1)<=floor(grid_size[0]/2)*grid_size[0]):
					print("Left")
					while current_room.Coordinate[0] != rooms[0].Coordinate[0]:
						local_rooms[rooms.find(current_room)].Name = "UNDERGROUND_RIVER"
						local_rooms[rooms.find(current_room)].Room_id = "BLOC"
						current_room = local_rooms[rooms.find(current_room)-(grid_size[1])]
					local_rooms[rooms.find(current_room)].Name = "UNDERGROUND_RIVER"
					local_rooms[rooms.find(current_room)].Room_id = "BLOC"
				elif ((rooms.find(start)+1)>ceili(grid_size[0]/2)*grid_size[0]):
					print("Right")
					while current_room.Coordinate[0] != rooms[rooms.size()-1].Coordinate[0]:
						local_rooms[rooms.find(current_room)].Name = "UNDERGROUND_RIVER"
						local_rooms[rooms.find(current_room)].Room_id = "BLOC"
						current_room = local_rooms[rooms.find(current_room)+(grid_size[1])]
					local_rooms[rooms.find(current_room)].Name = "UNDERGROUND_RIVER"
					local_rooms[rooms.find(current_room)].Room_id = "BLOC"
				else:
					print("Middle")
					var rand2 = int(round(randf_range(0,1)))
					if rand2 == 0:
						print("Left")
						while current_room.Coordinate[0] != rooms[0].Coordinate[0]:
							local_rooms[rooms.find(current_room)].Name = "UNDERGROUND_RIVER"
							local_rooms[rooms.find(current_room)].Room_id = "BLOC"
							current_room = local_rooms[rooms.find(current_room)-(grid_size[1])]
						local_rooms[rooms.find(current_room)].Name = "UNDERGROUND_RIVER"
						local_rooms[rooms.find(current_room)].Room_id = "BLOC"
					else:
						print("Right")
						while current_room.Coordinate[0] != rooms[rooms.size()-1].Coordinate[0]:
							local_rooms[rooms.find(current_room)].Name = "UNDERGROUND_RIVER"
							local_rooms[rooms.find(current_room)].Room_id = "BLOC"
							current_room = local_rooms[rooms.find(current_room)+(grid_size[1])]
						local_rooms[rooms.find(current_room)].Name = "UNDERGROUND_RIVER"
						local_rooms[rooms.find(current_room)].Room_id = "BLOC"
			1:
				print("Vulcanic shaft")
				while current_room.Coordinate[1] != rooms[grid_size[1]-1].Coordinate[1]:
					local_rooms[rooms.find(current_room)].Name = "VOLCANIC_SHAFT"
					local_rooms[rooms.find(current_room)].Room_id = "BLOC"
					current_room = local_rooms[rooms.find(current_room)+1]
				local_rooms[rooms.find(current_room)].Name = "VOLCANIC_SHAFT"
				local_rooms[rooms.find(current_room)].Room_id = "BLOC"
			2:
				print("Magma flow")
				if ((rooms.find(start)+1)<=floor(grid_size[0]/2)*grid_size[0]):
					while current_room.Coordinate[0] != rooms[0].Coordinate[0]:
						local_rooms[rooms.find(current_room)].Name = "MAGMA_FLOW"
						local_rooms[rooms.find(current_room)].Room_id = "BLOC"
						current_room = local_rooms[rooms.find(current_room)-(grid_size[1])]
					local_rooms[rooms.find(current_room)].Name = "MAGMA_FLOW"
					local_rooms[rooms.find(current_room)].Room_id = "BLOC"
					print("Left")
				elif ((rooms.find(start)+1)>ceili(grid_size[0]/2)*grid_size[0]):
					print("Right")
					while current_room.Coordinate[0] != rooms[rooms.size()-1].Coordinate[0]:
						local_rooms[rooms.find(current_room)].Name = "MAGMA_FLOW"
						local_rooms[rooms.find(current_room)].Room_id = "BLOC"
						current_room = local_rooms[rooms.find(current_room)+(grid_size[1])]
					local_rooms[rooms.find(current_room)].Name = "MAGMA_FLOW"
					local_rooms[rooms.find(current_room)].Room_id = "BLOC"
				else:
					print("Middle")
					var rand2 = int(round(randf_range(0,1)))
					if rand2 == 0:
						print("Left")
						while current_room.Coordinate[0] != rooms[0].Coordinate[0]:
							local_rooms[rooms.find(current_room)].Name = "MAGMA_FLOW"
							local_rooms[rooms.find(current_room)].Room_id = "BLOC"
							current_room = local_rooms[rooms.find(current_room)-(grid_size[1])]
						local_rooms[rooms.find(current_room)].Name = "MAGMA_FLOW"
						local_rooms[rooms.find(current_room)].Room_id = "BLOC"
					else:
						print("Right")
						while current_room.Coordinate[0] != rooms[rooms.size()-1].Coordinate[0]:
							local_rooms[rooms.find(current_room)].Name = "MAGMA_FLOW"
							local_rooms[rooms.find(current_room)].Room_id = "BLOC"
							current_room = local_rooms[rooms.find(current_room)+(grid_size[1])]
						local_rooms[rooms.find(current_room)].Name = "MAGMA_FLOW"
						local_rooms[rooms.find(current_room)].Room_id = "BLOC"
	print("Done")
	return local_rooms

static func where_can_place(grid_size : Vector2, rooms : Array[Room], check_room:Room, depthBetween : Vector2 = Vector2(0,grid_size[1])): #used in room generation. return with all possible continuation rooms.
	print("	Checking available neighbours for ",check_room.Coordinate,"...")
	var cords : Array[Room]
	var index_of_room : int = rooms.find(check_room)
	
	if(index_of_room+1 <= rooms.size()-1): #top check
		if ("none" == rooms[index_of_room+1].Name && rooms[index_of_room+1].Coordinate[1] > rooms[depthBetween[0]].Coordinate[1]):
			cords.push_back(rooms[index_of_room+1])
			print("		Top available: ",rooms[index_of_room+1].Coordinate)
	
	if(index_of_room-1 >= 0): #bottom check
		if ("none" == rooms[index_of_room-1].Name && rooms[index_of_room-1].Coordinate[1] <= rooms[depthBetween[1]].Coordinate[1]):
			cords.push_back( rooms[index_of_room-1])
			print("		Bottom available: ",rooms[index_of_room-1].Coordinate)
	
	if(index_of_room + grid_size[1] < rooms.size()): #right check
		if ("none" == rooms[index_of_room + grid_size[1]].Name):
			cords.push_back(rooms[index_of_room + grid_size[1]])
			print("		Right available: ",rooms[index_of_room + grid_size[1]].Coordinate)
	
	if(index_of_room - grid_size[1] >= 0): #left check
		if ("none" == rooms[index_of_room - grid_size[1]].Name):
			cords.push_back(rooms[index_of_room - grid_size[1]])
			print("		Left available: ",rooms[index_of_room - grid_size[1]].Coordinate)
	
	return cords

static func generate_room(rName : String, depth : Vector2, size : int, grid_size : Vector2, rooms : Array[Room],start : Room , buildable:bool=false, is_hidden : bool = true): #generate room.
	print("   Generating ",rName)
	var local_rooms = rooms
	var tryes = 0
	if depth[1] == grid_size[1]:
		depth -= Vector2(0,1)
	while (!(start.Coordinate[1] >= local_rooms[depth[0]].Coordinate[1] && start.Coordinate[1] < local_rooms[depth[1]].Coordinate[1]) || start.Name != 'none'):
		print("     Wrong start! Regenerating...")
		print("    !("+str(start.Coordinate[1])+" >= "+str(local_rooms[depth[0]].Coordinate[1])+" && "+str(start.Coordinate[1])+" < "+str(local_rooms[depth[1]].Coordinate[1])+") || "+start.Name+" != 'none')")
		tryes+=1
		if tryes >= 1000:
			print("      Too many tryes, dropping room")
			return local_rooms
		start = local_rooms.pick_random()
	var current_room = start
	
	var roomId :String = str(start.Coordinate[0])+"_"+str(start.Coordinate[1])+rName.substr(0,3)
	print("   with id: ",roomId)
	
	var room_size = 0
	
	if size:
		room_size = round(randf_range(1,size))
	else :
		room_size = 0
	
	local_rooms[local_rooms.find(current_room)].Name = rName
	local_rooms[local_rooms.find(current_room)].Room_id = roomId
	local_rooms[local_rooms.find(current_room)].Hidden = is_hidden
	local_rooms[local_rooms.find(current_room)].Buildable = buildable
	var current_size = 1
	for _y in room_size:
		var ret = where_can_place(grid_size,local_rooms,current_room,depth)
		if (ret.size()>0):
			var picked = ret.pick_random()
			local_rooms[local_rooms.find(picked)].Name = rName
			local_rooms[local_rooms.find(picked)].Room_id = roomId
			local_rooms[local_rooms.find(picked)].Buildable = buildable
			current_size +=1
			current_room = picked
		elif (ret.size()<=0 && current_size >= 2):
			break
		elif (ret.size()<=0 && current_size < 2):
			local_rooms = rooms
	return local_rooms

static func generate_start(grid_size : Vector2, rooms : Array[Room]):
	print("Generating entrance...")
	var top_center
	
	if int(grid_size[0])%2 ==0:
		top_center = rooms[grid_size[0]*grid_size[1]/2]
	else:
		top_center = rooms[(grid_size[0]*grid_size[1]/2)-grid_size[1]/2]
	
	var local_rooms = rooms
	var depth = Vector2(0,grid_size[1])
	
	local_rooms = generate_room("ENTRANCE",depth,0,grid_size,local_rooms,top_center,true,false)
	print("Done")
	return local_rooms
	
static func generate_end(grid_size : Vector2, rooms : Array[Room]):
	print("Generating void cristal...")
	var start : Room = rooms.pick_random()
	var available : Array[Room]
	for room in rooms:
		if (room.Name == "none"):
			available.push_back(room)
	start = available.pick_random()
	var local_rooms = rooms
	var depth = Vector2(7,grid_size[1])
	
	local_rooms = generate_room("VOID_CRYSTAL",depth,0,grid_size,local_rooms,start)
	print("Done")
	return local_rooms

static func generate_size6(grid_size : Vector2, rooms : Array[Room], count : int): #Done
	print("Generating size 6 rooms...")
	var local_rooms = rooms
	var depth : Vector2 = Vector2(7,grid_size[1])
	var available : Array[Room]
	for room in rooms:
		if (room.Name == "none"):
			available.push_back(room)
	var start = available.pick_random()
	
	if (grid_size[1] > depth[0]):
		for x in count:
			local_rooms = generate_room("HALLS_OF_THE_LICH_KING",depth,5,grid_size,local_rooms,start)
	print("Done")
	return local_rooms

static func generate_size4(grid_size : Vector2, rooms : Array[Room],count : int): #Done
	print("Generating size 4 rooms...")
	var size4_rooms : Array[String] = ["UNDERGROUND_FOREST","CAVERN","UNDERGROUND_LAKE","MONSTER_VILLAGE"]
	var available : Array[Room]
	var local_rooms = rooms
	var depth1 : Vector2 = Vector2(0,1)
	var depth2 : Vector2 = Vector2(2,6)
	var depth3 : Vector2 = Vector2(6,grid_size[1])
	for room in rooms:
		if (room.Name == "none"):
			available.push_back(room)
	for _x in count:
		
		var start = available.pick_random()
		
		if (start.Coordinate[1] <= rooms[depth1[1]].Coordinate[1]): # If in layer 0-1
			print("  Generating in layer 0-1...")
			var ranName = size4_rooms[round(randf_range(0,2))]
			local_rooms = generate_room(ranName,depth1,3,grid_size,local_rooms,start)
			
		elif (start.Coordinate[1] <= rooms[depth2[1]].Coordinate[1] && start.Coordinate[1] > rooms[depth2[0]].Coordinate[1]): # If in layer 1-7
			print("  Generating in layer 1-7...")
			var ranName = size4_rooms[round(randf_range(1,3))]
			local_rooms = generate_room(ranName,depth2,3,grid_size,local_rooms,start)
			
		elif (start.Coordinate[1] > rooms[depth3[0]].Coordinate[1]): # If in layer 7...
			print("  Generating in layer 7-...")
			var ranName = size4_rooms[round(randf_range(1,3))]
			local_rooms = generate_room(ranName,depth3,3,grid_size,local_rooms,start)
		
		else:
			print("  ",start.Coordinate[1]," out of range")
			
	print("Done")
	return local_rooms
	
static func generate_WYRD(grid_size : Vector2, rooms : Array[Room],count : int): #Done
	print("Generating WYRD rooms...")
	var WYRD_rooms : Array[String] = ["MEAT_CAVE","MOLE_VILLAGE","SMART CREATURE"]
	var available : Array[Room]
	var local_rooms = rooms
	var depth1 : Vector2 = Vector2(0,1)
	var depth2 : Vector2 = Vector2(2,6)
	var depth3 : Vector2 = Vector2(6,grid_size[1])
	for room in rooms:
		if (room.Name == "none"):
			available.push_back(room)
	for _x in count:
		
		var start = available.pick_random()

		
		if (start.Coordinate[1] <= rooms[depth1[1]].Coordinate[1]): # If in layer 0-1
			print("  Generating in layer 0-1...")
			var ranName = WYRD_rooms[round(randf_range(0,WYRD_rooms.size()-1))]
			local_rooms = generate_room(ranName,depth1,0,grid_size,local_rooms,start)
			
		elif (start.Coordinate[1] <= rooms[depth2[1]].Coordinate[1] && start.Coordinate[1] > rooms[depth2[0]].Coordinate[1]): # If in layer 1-7
			print("  Generating in layer 1-7...")
			var ranName = WYRD_rooms[round(randf_range(0,WYRD_rooms.size()-1))]
			local_rooms = generate_room(ranName,depth2,0,grid_size,local_rooms,start)
			
		elif (start.Coordinate[1] > rooms[depth3[0]].Coordinate[1]): # If in layer 7...
			print("  Generating in layer 7-...")
			var ranName = WYRD_rooms[round(randf_range(0,WYRD_rooms.size()-1))]
			local_rooms = generate_room(ranName,depth3,0,grid_size,local_rooms,start)
		
		else:
			print("  ",start.Coordinate[1]," out of range")
			
	print("Done")
	return local_rooms
	
static func generate_size2(grid_size : Vector2, rooms : Array[Room],count : int): #Done
	print("Generating size 2 rooms...")
	var size2_rooms : Array[String] = ["CRYSTAL_CAVERN","GAS-FILLED_CHAMBER","HIVE_OF_CREATURES","CAVERN_WITH_LARGE_CREATURE","ABANDONED_MINE"]
	var available : Array[Room]
	var local_rooms = rooms
	var depth1 : Vector2 = Vector2(0,1)
	var depth2 : Vector2 = Vector2(2,6)
	var depth3 : Vector2 = Vector2(6,grid_size[1])
	for room in rooms:
		if (room.Name == "none"):
			available.push_back(room)
	for _x in count:
		
		var start = available.pick_random()
		
		if (start.Coordinate[1] <= rooms[depth1[1]].Coordinate[1]): # If in layer 0-1
			print("  Generating in layer 0-1...")
			var ranName = size2_rooms[round(randf_range(0,3))]
			local_rooms = generate_room(ranName,depth1,1,grid_size,local_rooms,start)
			
		elif (start.Coordinate[1] <= rooms[depth2[1]].Coordinate[1] && start.Coordinate[1] > rooms[depth2[0]].Coordinate[1]): # If in layer 1-7
			print("  Generating in layer 1-7...")
			var ranName = size2_rooms[round(randf_range(0,size2_rooms.size()-1))]
			local_rooms = generate_room(ranName,depth2,1,grid_size,local_rooms,start)
			
		elif (start.Coordinate[1] > rooms[depth3[0]].Coordinate[1]): # If in layer 7...
			print("  Generating in layer 7-...")
			var ranName = size2_rooms[round(randf_range(0,size2_rooms.size()-1))]
			local_rooms = generate_room(ranName,depth3,1,grid_size,local_rooms,start)
		
		else:
			print("  ",start.Coordinate[1]," out of range")
			
	print("Done")
	return local_rooms
	
static func generate_size1(grid_size : Vector2, rooms : Array[Room],count : int):
	print("Generating size 1 rooms...")
	var size1_rooms : Array[String] = ["WISHING_WELL","BURRIED_TEMPLE","DEMON_PORAL","GOLEM_FORGE","SLUMBERING_WYRM"]
	var available : Array[Room]
	var local_rooms = rooms
	var depth1 : Vector2 = Vector2(0,1)
	var depth2 : Vector2 = Vector2(2,6)
	var depth3 : Vector2 = Vector2(6,grid_size[1])
	for room in rooms:
		if (room.Name == "none"):
			available.push_back(room)
	for _x in count:
		
		var start = available.pick_random()
		
		if (start.Coordinate[1] <= rooms[depth1[1]].Coordinate[1]): # If in layer 0-1
			print("  Generating in layer 0-1...")
			var ranName = size1_rooms[round(randf_range(0,2))]
			local_rooms = generate_room(ranName,depth1,0,grid_size,local_rooms,start)
			
		elif (start.Coordinate[1] <= rooms[depth2[1]].Coordinate[1] && start.Coordinate[1] > rooms[depth2[0]].Coordinate[1]): # If in layer 1-7
			print("  Generating in layer 1-7...")
			var ranName = size1_rooms[round(randf_range(0,size1_rooms.size()-1))]
			local_rooms = generate_room(ranName,depth2,0,grid_size,local_rooms,start)
			
		elif (start.Coordinate[1] > rooms[depth3[0]].Coordinate[1]): # If in layer 7...
			print("  Generating in layer 7-...")
			var ranName = size1_rooms[round(randf_range(0,size1_rooms.size()-1))]
			local_rooms = generate_room(ranName,depth3,0,grid_size,local_rooms,start)
		
		else:
			print("  ",start.Coordinate[1]," out of range")
			
	print("Done")
	return local_rooms

static func generate_ResAndTra(_grid_size : Vector2, rooms : Array[Room]):
	print("Generating size Resources and Trade Goods rooms...")
	var ResAndTra : Array[String] = ["RESOURCE","TRADE_GOOD"]
	var available : Array[Room]
	var local_rooms = rooms
	for room in rooms:
		if (room.Name == "none"):
			available.push_back(room)
			
	for roomx in available:
		print("  Generating in layer all...")
		var room = local_rooms.rfind(roomx)
		var randName = ResAndTra.pick_random()
		print("   Generating "+randName)
		
		
		local_rooms[room].Name = randName
		var roomId :String = str(local_rooms[room].Coordinate[0])+"_"+str(local_rooms[room].Coordinate[1])+local_rooms[room].Name.substr(0,3)
		local_rooms[room].Room_id = roomId
		print("   with id: "+roomId)
		
	print("Done")
	return local_rooms
