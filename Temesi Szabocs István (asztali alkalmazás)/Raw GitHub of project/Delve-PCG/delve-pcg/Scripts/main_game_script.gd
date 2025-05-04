extends Node2D

@onready var tempRoom = load("res://Scenes/Game/Assets/Rooms/TemplateRoom.tscn")
@onready var tempUnit = load("res://Scenes/Game/Assets/Units/TemplateUnit.tscn")
@onready var tempStatus = load("res://Scenes/Game/Assets/Conditions/TemplateConditions.tscn")

@onready var generation_scripts = load("res://Scripts/room_generation.gd")
@onready var placement_scripts = load("res://Scripts/room_placement.gd")
@onready var fluff = load("res://Scripts/fluff_script.gd")


@onready var RS_collector_winodw = load("res://Scenes/Game/Assets/UI/Roundstart_UI/Roundstart_collector_ui.tscn")
@onready var Build_options_window = load("res://Scenes/Game/Assets/UI/Build_UI/Build_card_collector_ui.tscn")
@onready var Recruit_window = load("res://Scenes/Game/Assets/UI/Recruit_UI/Recruit_card_collector_UI.tscn")
@onready var Save_window = load("res://Scenes/Game/Assets/UI/Save_UI/save_window_ui.tscn")
@onready var Info_window = load("res://Scenes/Game/Assets/UI/Info_UI/Info_card.tscn")
@onready var U_button = load("res://Scenes/Game/Assets/UI/Info_UI/Unit_info_button.tscn")
@onready var Unit_Info_window = load("res://Scenes/Game/Assets/UI/Info_UI/Info_card_unit.tscn")

@onready var Log_blu = load("res://Scenes/Game/Assets/UI/In_Game_log_UI/Log_blu_ui.tscn")
@onready var Log_grn = load("res://Scenes/Game/Assets/UI/In_Game_log_UI/Log_grn_ui.tscn")
@onready var Log_red = load("res://Scenes/Game/Assets/UI/In_Game_log_UI/Log_red_ui.tscn")
@onready var Log_wht = load("res://Scenes/Game/Assets/UI/In_Game_log_UI/Log_wht_ui.tscn")

@onready var currency_change_floater = load("res://Scenes/Game/Assets/UI/Fluff_elements/Currency_change_floater.tscn")

@onready var AllUnits = "res://Resources/Data/AllUnits.json"
@onready var AllUnits_as_text = FileAccess.get_file_as_string(AllUnits)
@onready var AllUnits_as_dict = JSON.parse_string(AllUnits_as_text)

@onready var AllRooms = "res://Resources/Data/AllRooms.json"
@onready var AllRooms_as_text = FileAccess.get_file_as_string(AllRooms)
@onready var AllRooms_as_dict = JSON.parse_string(AllRooms_as_text)

var soundTween = create_tween()

var grid_size = Vector2(13,10)
const ROOM_SIZE = Vector2i(130,90)
var current_room
var room_intaraction_room
var astar_grid = AStarGrid2D.new()
var start_time = 0
var entrance : Room

signal BuildOpened(currentRoom:Room,currentMoney:Vector2)
signal open_roundstart_UI_elements(effects:Array[Dictionary])
signal RecruitOpened(currentRoom:Room,currentMoney:Vector2)
signal saveRequest(state:GameState,room_list:Array[Room])
signal sendToClearRoom(room:Room)

signal room_choosen
signal combat_turn_done

var room_list : Array[Room]
var all_rooms : Array
var built_room_list = {
	"BARRACKS":[],
	"CANNON_OUTPOST":[],
	"FORGE":[],
	"MASON":[],
	"INN":[],
	"KENNEL":[],
	"LABORATORY":[],
	"LIBRARY":[],
	"PRISON":[],
	"DORMS":[],
	"HOSPITAL":[],
	"KITCHEN":[],
	"MUSEUM":[],
	"OVERSEERS_OFFICE":[],
	"SHRINE":[],
	"STOCKPILE":[],
	"STOREHOUSE":[],
	"TEMPLE":[],
	"TREASURY":[],
	"DRAWBRIDGE":[],
	"ELEVATOR":[],
	"PUMP":[],
	"TRACKS":[],
	"INVENTOR’S_LAB":[],
	"BREEDER":[]
	}
	
var state = GameState.new()
var enabeled_bonuses = {
	"UNDERGROUND_FOREST":false, 	# triggers at every round start, has UI element
	"CRYSTAL_CAVERN":false, 		# triggers at every round start
	"FORGOTTEN_CRYPTS":false,		# triggers once, can recruit when cleared
	"WISHING_WELL":false,			# triggers at every round start, has UI element
	"DEMON_PORAL":false, 			# triggers at every round start, has UI element
	"GOLEM_FORGE":false, 			# triggers once, can recruit when cleared
	"SLUMBERING_WYRM":false, 		# triggers at every round start, has UI element
	"TIME_CRYSTALS":false, 			# triggers when in combat
	"MOLE_VILLAGE":false, 			# triggers at every round start 
	"SMART_CREATURE":false, 		# triggers at every round start, has UI element
	"WHISTLING_CAVE":false, 		# triggers when in combat
	"REALM_OF_LOST_THINGS":false, 	# triggers at every round start
	"LABORATORY":false,				# triggers at every round start
	"STOCKPILE":false,				# triggers at every round start
	"TREASURY":false,				# triggers at every round start
	"PRISON":false,					# triggers at every round start
	}
var roundstart_effect_dict :Array[Dictionary]
var roundstart_effect_return : Array[Dictionary]

func log_msg(MsgColor:String,Msg:String):
	if $Camera2D/Event_Log/Log_BG/VBoxContainer.get_children().size() <= 20:
		match MsgColor.substr(0,1).to_lower():
			"r":
				var inst_log=Log_red.instantiate()
				inst_log.text = Msg
				$Camera2D/Event_Log/Log_BG/VBoxContainer.add_child(inst_log)
			"g":
				var inst_log = Log_grn.instantiate()
				inst_log.text = Msg
				$Camera2D/Event_Log/Log_BG/VBoxContainer.add_child(inst_log)
			"b":
				var inst_log = Log_blu.instantiate()
				inst_log.text = Msg
				$Camera2D/Event_Log/Log_BG/VBoxContainer.add_child(inst_log)
			"w":
				var inst_log = Log_wht.instantiate()
				inst_log.text = Msg
				$Camera2D/Event_Log/Log_BG/VBoxContainer.add_child(inst_log)
	else:
		for x in $Camera2D/Event_Log/Log_BG/VBoxContainer.get_children().size() - 20:
			$Camera2D/Event_Log/Log_BG/VBoxContainer.get_child(x).queue_free()
		match MsgColor.substr(0,1).to_lower():
			"r":
				var inst_log=Log_red.instantiate()
				inst_log.text = Msg
				$Camera2D/Event_Log/Log_BG/VBoxContainer.add_child(inst_log)
			"g":
				var inst_log = Log_grn.instantiate()
				inst_log.text = Msg
				$Camera2D/Event_Log/Log_BG/VBoxContainer.add_child(inst_log)
			"b":
				var inst_log = Log_blu.instantiate()
				inst_log.text = Msg
				$Camera2D/Event_Log/Log_BG/VBoxContainer.add_child(inst_log)
			"w":
				var inst_log = Log_wht.instantiate()
				inst_log.text = Msg
				$Camera2D/Event_Log/Log_BG/VBoxContainer.add_child(inst_log)

func read_json(Json:String):
	return JSON.parse_string(FileAccess.get_file_as_string(Json))

func gen_room_id(room:Room):
	return str(room.Coordinate[0])+"_"+str(room.Coordinate[1])+room.Name.substr(0,3)

func new_game():
	change_stage(0)
	reload_currency()
	trade_close()
	room_list.clear()
	var children = %RoomCollector.get_children()
	for child in children:
		child.free()
	roundstart_effect_dict.clear()
	
	room_list = generation_scripts.generate_coordinates(grid_size,ROOM_SIZE)
	room_list = generation_scripts.generate_blockers(grid_size,room_list)
	room_list = generation_scripts.generate_start(grid_size,room_list)
	room_list = generation_scripts.generate_end(grid_size,room_list)
	room_list = generation_scripts.generate_size6(grid_size,room_list,1)
	room_list = generation_scripts.generate_WYRD(grid_size,room_list,floor(((grid_size[0]*grid_size[1])*0.05)))
	room_list = generation_scripts.generate_size4(grid_size,room_list,floor(((grid_size[0]*grid_size[1])*0.3)/4))
	room_list = generation_scripts.generate_size2(grid_size,room_list,floor(((grid_size[0]*grid_size[1])*0.2)/2))
	room_list = generation_scripts.generate_size1(grid_size,room_list,floor(((grid_size[0]*grid_size[1])*0.2)))
	room_list = generation_scripts.generate_ResAndTra(grid_size,room_list)
	
	for room in room_list:
		if room.Name == "ENTRANCE":
			summon_creature(room,5,["Soldier"],"No",5)
			log_msg("b",str(room.Units.size()))

func load_game(save_path):
	
	room_list.clear()
	var children = %RoomCollector.get_children()
	for child in children:
		child.free()
	roundstart_effect_dict.clear()
	
	if FileAccess.file_exists(save_path):
		var raw = FileAccess.open(save_path,FileAccess.READ)
		var json = JSON.parse_string(raw.get_as_text())
		
		state.GameName = json.filename
		state.Resources = json.data.gamestate.Resources
		state.TradeGoods = json.data.gamestate.TradeGoods
		state.MaxResources = json.data.gamestate.MaxResources
		state.MaxTradeGoods = json.data.gamestate.MaxTradeGoods
		state.GamePhase = json.data.gamestate.GamePhase
		change_stage(state.GamePhase)
		state.SubPhase = json.data.gamestate.SubPhase
		state.Transmutation = json.data.gamestate.Transmutation
		state.MilitaryCapacity = json.data.gamestate.MilitaryCapacity
		state.SaveNo = json.data.gamestate.SaveNo
		state.GameLength = json.data.gamestate.GameLength
		state.SessionTime = json.data.gamestate.SessionTime
		
		state.DWARVEN_DOMINANCE = json.data.gamestate.DWARVEN_DOMINANCE
		state.BEASTMASTER = json.data.gamestate.BEASTMASTER
		state.YOU_SHALL_NOT_PASS = json.data.gamestate.YOU_SHALL_NOT_PASS
		state.DRAGONS_ARE_OUR_FRIENDS = json.data.gamestate.DRAGONS_ARE_OUR_FRIENDS
		state.ENDLESS_TREASURY = json.data.gamestate.ENDLESS_TREASURY
		state.HITTING_THE_GYM = json.data.gamestate.HITTING_THE_GYM
		state.MIND_YOUR_STEP = json.data.gamestate.MIND_YOUR_STEP
		state.LOOKING_FOR_GROUP = json.data.gamestate.LOOKING_FOR_GROUP
		state.ARCHMAGE = json.data.gamestate.ARCHMAGE
		state.PROGRESS_AT_ALL_COSTS = json.data.gamestate.PROGRESS_AT_ALL_COSTS
		
		var load_room_list : Array[Room]
		for room in json.data.room_data:
			var rRoom = Room.new()
			rRoom.Coordinate = Vector2(room.Coordinate[0],room.Coordinate[1])
			rRoom.Buildable = room.Buildable
			var statuses : Array[String]
			for x in room.Status:
				statuses.push_back(x)
			rRoom.Status = statuses
			rRoom.Status_placed = false
			rRoom.Name = room.Name
			rRoom.Room_id = room.Room_id
			rRoom.Hidden = room.Hidden
			rRoom.Can_recruit = room.Can_recruit
			var unitList :Array[Unit]
			for unit in room.Units:
				var rUnit = Unit.new()
				rUnit.Coordinate = Vector2(room.Coordinate[0],room.Coordinate[1])
				rUnit.Hostile = unit.Hostile
				rUnit.Name = unit.Name
				rUnit.Ability = unit.Ability
				rUnit.Str = unit.Str
				rUnit.Number = unit.Number
				rUnit.Placed = false
				rUnit.Moved = unit.Moved
				#rUnit.Effects = unit.EEffects
				unitList.push_back(rUnit)
			rRoom.Units = unitList
			load_room_list.push_back(rRoom)
		room_list = load_room_list
	else:
		print(save_path+ " does not exist")
		new_game()

func Draw_everithing():
	placement_scripts.temp_place(room_list,tempRoom,tempUnit,tempStatus,%RoomCollector,grid_size)

func re_draw_everithing():
	placement_scripts.redraw(room_list,tempUnit,tempStatus,grid_size,%RoomCollector)
	reload_currency()
	astar_grid.update()
	update_MC()

func reload_currency():
	%CurrentGold.set_text(str(state.TradeGoods)+"/"+str(state.MaxTradeGoods))
	%CurrentSilver.set_text(str(state.Resources)+"/"+str(state.MaxResources))

func center_on_entrance():
	var start_pos = Vector2(0,0)
	for room in room_list:
		if room.Name == "ENTRANCE":
			start_pos = room.Coordinate + Vector2(ROOM_SIZE[0]/2,ROOM_SIZE[1]/2)
			break
	$Camera2D.position = start_pos

func get_clickable_non_visible_rooms():
	var visible_neighbour: Array[Room]
	for room in room_list:
		var has_visible_neighbour = false
		#print(str(room.Coordinate) + " :")
		var rIdx = room_list.find(room)
		if rIdx - grid_size[1] >= 0: #Left check
			if room_list[rIdx-grid_size[1]].Hidden == false:
				#print("Left clickable, non visible: "+ str(room_list[rIdx-grid_size[1]].Coordinate))
				has_visible_neighbour = true
		if rIdx + 1 < room_list.size(): #Bottom check
			if room_list[rIdx + 1].Hidden == false:
				#print("Left clickable, non visible: "+ str(room_list[rIdx + 1].Coordinate))
				has_visible_neighbour = true
		if rIdx + grid_size[1] < room_list.size(): #Right check
			if room_list[rIdx + grid_size[1]].Hidden == false:
				#print("Left clickable, non visible: "+ str(room_list[rIdx + grid_size[1]].Coordinate))
				has_visible_neighbour = true
		if rIdx - 1 >= 0: #Top check
			if room_list[rIdx-1].Hidden == false:
				#print("Left clickable, non visible: "+ str(room_list[rIdx-1].Coordinate))
				has_visible_neighbour = true
		
		if has_visible_neighbour:
			visible_neighbour.push_back(room)
	return visible_neighbour

func get_visible_rooms():
	var visible_rooms : Array[Room]
	for room in room_list:
		if room.Hidden == false:
			visible_rooms.push_back(room)
	return visible_rooms

func get_rooms_same_row(room:Room):
	var rowRooms :Array[Room]
	var room_height = room_list.find(room)-floor(room_list.find(room)/grid_size[1])*grid_size[1]
	for x in grid_size[0]:
		rowRooms.push_back(room_list[x * grid_size[1] + room_height])
	return rowRooms

func get_rooms_same_col(room:Room):
	var colRooms: Array[Room]
	var room_col = floor(room_list.find(room)/grid_size[1])
	for x in room_list:
		if floor(room_list.find(x)/grid_size[1]) == room_col:
			colRooms.push_back(x)
	return colRooms

func get_entrance():
	for room in room_list:
		if room.Name == "ENTRANCE":
			return room

func change_stage(to_stage:int):
	state.GamePhase = to_stage
	match to_stage:
		-1:
			%CurrentState.set_text("Pre Round Effects")
			%TradeDone.disabled = true
			log_msg("b","State changed to 'Pre Round Effect'")
			_on_display_clickable_rooms_pressed()
		0:
			%CurrentState.set_text("Explore")
			%Current_needed_action.set_text("Click on an unexplored room.")
			log_msg("b","State changed to '"+%CurrentState.text+"'")
			_on_display_clickable_rooms_pressed()
		1:
			%CurrentState.set_text("Combat")
			%Current_needed_action.set_text("Don't let the enemy reach the entrance.")
			log_msg("b","State changed to '"+%CurrentState.text+"'")
			_on_display_clickable_rooms_pressed()
		2:
			%CurrentState.set_text("Trade")
			%Current_needed_action.set_text("Exchange Resources and Trade Goods.")
			%TradeDone.disabled = false
			log_msg("b","State changed to '"+%CurrentState.text+"'")
			_on_display_clickable_rooms_pressed()
		3:
			%CurrentState.set_text("Build")
			%Current_needed_action.set_text("Click on an empty room and build something.")
			log_msg("b","State changed to '"+%CurrentState.text+"'")
			_on_display_clickable_rooms_pressed()
		4:
			%CurrentState.set_text("Recruit")
			%Current_needed_action.set_text("Grow your army by recrouting units.")
			log_msg("b","State changed to '"+%CurrentState.text+"'")
			_on_display_clickable_rooms_pressed()
		101:
			pass # game end

func stage_Explore(active_room:Object):
	#print("cliclked on "+ str(active_room))
	var active_room_id : String = ""
	var cnvr = get_clickable_non_visible_rooms()
	var is_visible = get_visible_rooms()
	var combat :bool = false
	var bonus = 0
	var room_depth = 0
	
	for room in room_list:
		if room.Pointer == active_room:
			room_depth = (room_list.find(room)-floor(room_list.find(room)/grid_size[1])*grid_size[1])
			for x in grid_size[1]-1:
				if room_list[floor(room_list.find(room)/grid_size[1])*grid_size[1]+x].Name == "OVERSEERS_OFFICE":
					bonus = room_depth

	for x in room_list:
		if x.Coordinate == active_room.get_position():
			if cnvr.find(x) != -1 && is_visible.find(x) == -1:
				#nonbuild_room_effects(x,room_depth,bonus)
				for room in room_list:
					if room.Coordinate == active_room.get_position():
						active_room_id = room.Room_id
				
				for room in room_list:
					if room.Room_id == active_room_id:
						room.Hidden = false
						log_msg("w","Found "+room.Name)
						if room.Name == "VOID_CRYSTAL":
							get_tree().change_scene_to_file("res://Scenes/Game/Game_Over.tscn")
							change_stage(101)
						%RoomOpen.play()
						nonbuild_room_effects(room,room_depth,bonus)
						for hRoom in room_list:
							for units in hRoom.Units:
								if units.Hostile == "Yes":
									combat = true
				
				if combat:
					change_stage(1)
				else:
					change_stage(2)
					trade_open()
	re_draw_everithing()

func battle(agressor_units : Array[Unit], argessor_bous:int, defender_units : Array[Unit],defender_bonus:int):
		#log_msg("g", "DEFUNITS1: "+str(defender_units[1].Name))
		var survivors :Array[Unit]
		
		var all_agressor_STR : int = argessor_bous
		for agressor in agressor_units:
			all_agressor_STR += agressor.Str * agressor.Number
		
		var all_defender_STR : int = defender_bonus
		for defender in defender_units:
			all_defender_STR += defender.Str * defender.Number
			log_msg("b",defender.Name)
		
		if defender_units.size() == 0:
			log_msg("w", "No defenders")
			return agressor_units
		
		
		log_msg("w",str(all_agressor_STR) + "=:=" + str(all_defender_STR))
		
		if all_agressor_STR > all_defender_STR:
			log_msg("w", "Agressor victory!")
			for agressor in agressor_units:
				if agressor.Str <= all_defender_STR:
					all_defender_STR -= agressor.Str
				else:
					survivors.push_back(agressor)
			return survivors
			
		if all_defender_STR > all_agressor_STR:
			log_msg("w", "Defender victory!")
			for friendly in defender_units:
				if friendly.Str <= all_agressor_STR:
					all_agressor_STR -= friendly.Str
				else:
					survivors.push_back(friendly)
			return survivors
		else:
			log_msg("r", "Draw")
			survivors.clear()
			return survivors

func moove_unit(unit:Unit,from:Room,to:Room):
	var paralised : bool = false
	var surrounding_rooms:Array[Room]
	for effect in unit.Effects:
		if effect.value == "-10":
			unit.Moved = true

	for room in room_list:
		if get_visible_rooms().find(room) != -1 and room.Status.size() == 0:
			if room == room_list[room_list.find(from)+1] or room == room_list[room_list.find(from)-1] or room == room_list[room_list.find(from)+grid_size[1]] or room == room_list[room_list.find(from)-grid_size[1]]:
				surrounding_rooms.push_back(room)
	for room in room_list:
		if get_visible_rooms().find(room) != -1 and room.Status.size() == 0:
			if room == room_list[room_list.find(from)+1] or room == room_list[room_list.find(from)-1] or room == room_list[room_list.find(from)+grid_size[1]] or room == room_list[room_list.find(from)-grid_size[1]]:
				if surrounding_rooms.find(room) == -1:
					surrounding_rooms.push_back(room)
	
	var agressor : Array[Unit]
	agressor.append_array([unit])
	var defender : Array[Unit]
	defender.append_array(to.Units)
	
	var agressor_ranged_support : Array[Unit]
	for room in surrounding_rooms:
		for sUnit in room.Units:
			if sUnit.Hostile == unit.Hostile and sUnit.Ranged == true:
				agressor_ranged_support.push_back(sUnit)
	
	var defender_ranged_support : Array[Unit]
	for room in surrounding_rooms:
		for sUnit in room.Units:
			if sUnit.Hostile != unit.Hostile and sUnit.Hostile != "Neutral" and sUnit.Ranged == true:
				defender_ranged_support.push_back(sUnit)
	
	for aUnit in agressor:
		if state.GamePhase == 1:
			aUnit.Moved = true

	from.Units.pop_at(from.Units.find(unit))
	to.Units.clear()
	
	
	if defender.size() > 0 and unit.Hostile != defender[0].Hostile:
		log_msg("b","Combat!!!")
		var agr_supp_str:int
		for sUnit in agressor_ranged_support:
			agr_supp_str += sUnit.Str
		var def_sup_str:int
		for sUnit in defender_ranged_support:
			def_sup_str += sUnit.Str
		var victor : Array[Unit] = battle(agressor,agr_supp_str,defender,def_sup_str)
		unit.Coordinate = to.Coordinate
		to.Units.append_array(victor)
	
	elif defender.size() > 0 and unit.Hostile == defender[0].Hostile:
		log_msg("b","Merge!!!")
		unit.Coordinate = to.Coordinate
		to.Units.append_array(defender+[unit])
	
	else:
		log_msg("b","Move!!!")
		unit.Coordinate = to.Coordinate
		to.Units.append_array([unit])
	
	re_draw_everithing()
	
func moove_all_units(from:Room,to:Room):
	var agressor : Array[Unit]
	for unit in from.Units:
		if unit.Moved == false:
			agressor.push_back(unit)
	var defender : Array[Unit]
	defender.append_array(to.Units)
	
	if agressor.size() > 0:
		var surrounding_rooms:Array[Room]
		
		var agressor_ranged_support : Array[Unit]
		for room in surrounding_rooms:
			for sUnit in room.Units:
				if sUnit.Hostile == from.Units[0].Hostile and sUnit.Ranged == true:
					agressor_ranged_support.push_back(sUnit)
		
		var defender_ranged_support : Array[Unit]
		for room in surrounding_rooms:
			for sUnit in room.Units:
				if sUnit.Hostile != from.Units[0].Hostile and sUnit.Hostile != "Neutral" and sUnit.Ranged == true:
					defender_ranged_support.push_back(sUnit)
		
		for unit in agressor:
			if state.GamePhase == 1:
				unit.Moved = true
		
		for unit in agressor:
			from.Units.pop_at(from.Units.find(unit))
			
			
		
		to.Units.clear()
		
		
		if defender.size() > 0 and agressor[0].Hostile != defender[0].Hostile:
			log_msg("b","Combat!!!")
			var agr_supp_str:int
			for sUnit in agressor_ranged_support:
				agr_supp_str += sUnit.Str
			var def_sup_str:int
			for sUnit in defender_ranged_support:
				def_sup_str += sUnit.Str
			var victor : Array[Unit] = battle(agressor,agr_supp_str,defender,def_sup_str)
			for unit in from.Units.size()-1:
				from.Units[unit].Coordinate = to.Coordinate
			to.Units.append_array(victor)
		
		elif defender.size() > 0 and agressor[0].Hostile == defender[0].Hostile:
			log_msg("b","Merge!!!")
			for unit in from.Units.size()-1:
				from.Units[unit].Coordinate = to.Coordinate
			to.Units.append_array(defender+agressor)
		
		else:
			log_msg("b","Move!!!")
			for unit in from.Units.size()-1:
				from.Units[unit].Coordinate = to.Coordinate
			to.Units.append_array(agressor)
	
	re_draw_everithing()

func before_combat_effects():
	#===Drunkards===
	var list_of_drunkards:Array[Unit]
	var list_of_inns:Array[Room]
	
	for room in room_list:
		if room.Name == "INN":
			list_of_inns.push_back(room)
		for unit in room.Units:
			if unit.Name == "Drunkard":
				list_of_drunkards.push_back(unit)
	
	for Drunkard in list_of_drunkards:
		var current_room :Room
		for room in room_list:
			if room.Coordinate == Drunkard.Coordinate:
				current_room = room
		moove_unit(Drunkard,current_room,list_of_inns.pick_random())
	
	#===Saboteurs===
	for room in room_list:
		for unit in room.Units:
			if unit.Name == "Saboteur":
				room.trap_temp = true
				room.trap = "Damage"
				room.trap_lvl = 2
	
func stage_Combat():
	if count_unit("Jester") > 0:
		for room in room_list:
			for unit in room.Units:
				if unit.Name == "Jester":
					entrance = room
	else:
		entrance = get_entrance()
	
	for room in room_list:
		if room.Hidden || room.Status.has("FLODDED_LAVA") || room.Status.has("POISON_GAS"):
			astar_grid.set_point_solid(Vector2i((room.Coordinate[0]-22)/130,(room.Coordinate[1]-45)/90),true)
		else:
			astar_grid.set_point_solid(Vector2i((room.Coordinate[0]-22)/130,(room.Coordinate[1]-45)/90),false)
	
	before_combat_effects()
	%Combat_Done.position = Vector2i(-70,103)
	log_msg("w","Combat begins!")
	while count_unit("h") > 0:
		log_msg("r","There are hostiles!")
		var hostiles = []
		for room in room_list:
			for unit in room.Units:
				if unit.Hostile == "Yes":
					hostiles.push_back({"Room":room,"Unit":unit})
					#log_msg("r","A hostile : "+ str(room.Coordinate)+" "+unit.Name)
					
		if state.SubPhase == 0: #===ENEMY TURN===
			if count_unit("Jester") > 0:
				for room in room_list:
					for unit in room.Units:
						if unit.Name == "Jester":
							entrance = room
			else:
				entrance = get_entrance()
			for room in room_list:
				for unit in hostiles:
					if room == unit.Room and room.Units.find(unit.Unit) != -1:
						#log_msg("g","The "+room.Name+" exists and has the specified unit("+unit.Unit.Name+")!")
						if Vector2i((room.Coordinate[0]),(room.Coordinate[1])) != Vector2i((entrance.Coordinate[0]),(entrance.Coordinate[1])):
							log_msg("g","The "+room.Name+" exists and has the specified unit("+unit.Unit.Name+")!")
							var next_cord_id = astar_grid.get_point_path(Vector2i((room.Coordinate[0]-92)/130,(room.Coordinate[1]-45)/90),Vector2i((entrance.Coordinate[0]-92)/130,(entrance.Coordinate[1]-45)/90))[1]
							var next_cord : Vector2 = Vector2(next_cord_id[0]*130+92,next_cord_id[1]*90+45)
							log_msg("b","unit("+unit.Unit.Name+") => "+str(next_cord))
							
							for nRoom in room_list:
								if nRoom.Coordinate == next_cord:
									log_msg("r","moved "+unit.Unit.Name+" from "+ str(room.Coordinate)+ " to "+ str(nRoom.Coordinate))
									#log_msg("g","defense sizr: "+str(nRoom.Units.size()))
									moove_unit(unit.Unit,room,nRoom)
									re_draw_everithing()
						
						#use aStar2d t check for sortest available path!!!
						re_draw_everithing()
			state.SubPhase = 1
		else: #===FRIENDLY TURN===
			if entrance.Units.size() >0 and entrance.Units[0].Hostile == "Yes":
				get_tree().change_scene_to_file("res://Scenes/Game/Game_Over.tscn")
				
			await combat_turn_done
			state.SubPhase = 0
		#do combat while enemies are wisible
		#if all enemies are dead exit combat
	

	%Combat_Done.position = Vector2i(-70,300) #%DarkScreen.texture.size[1]+%Combat_Done.size[1]

	log_msg("w","Combat ends!")
	for room in room_list:
		if room.trap_temp:
			room.trap = ""
			room.trap_lvl = 0 
	%TradeDone.disabled = false
	change_stage(2)
	trade_open()

func trade_open():
	%ToGold.disabled = false
	%ToSilver.disabled = false

func trade_close():
	%ToGold.disabled = true
	%ToSilver.disabled = true

func stage_Build(active_room:Object):
	set_process(true)
	var is_visible = get_visible_rooms() 
	for room in room_list:
		if room.Coordinate == active_room.get_position():
			var storehouse:bool = false
			for x in get_rooms_same_row(room):
				if x.Name == "STOREHOUSE":
					storehouse = true
			if is_visible.find(room) != -1:
				var inst_build_Window = Build_options_window.instantiate()
				%Build_Menu.add_child(inst_build_Window)
				%TradeDone.disabled = true
				log_msg("w","Build menu opened.")
				BuildOpened.connect(%Build_Menu.get_child(0)._on_get_data)
				for sRoom in room_list:
					if sRoom.Pointer == active_room:
						#print(str(Vector2(state.TradeGoods,state.Resources)))
						BuildOpened.emit(sRoom,Vector2(state.TradeGoods,state.Resources),built_room_list,storehouse)
				
func stage_Recruit(active_room:Object):
	var noGolemForge = 0
	var noForgottenCrypts = 0
	
	for room in get_visible_rooms():
		match room.Name:
			"FORGOTTEN_CRYPTS":
				noForgottenCrypts+=1
			"GOLEM_FORGE":
				noGolemForge+=1
			
	state.MilitaryCapacity.Soldier = 5+(built_room_list.BARRACKS.size()*10)
	state.MilitaryCapacity.Gunner = (built_room_list.BARRACKS.size()*10)
	state.MilitaryCapacity.Hound = built_room_list.KENNEL.size()*5
	state.MilitaryCapacity.Cleric = built_room_list.SHRINE.size()
	state.MilitaryCapacity.Mage = built_room_list.LIBRARY.size()*5
	state.MilitaryCapacity.Prisoner = built_room_list.PRISON.size()*20
	state.MilitaryCapacity.Alchemist = built_room_list.LABORATORY.size()*10
	state.MilitaryCapacity.Golem = noGolemForge
	state.MilitaryCapacity.Cannon = built_room_list.FORGE.size()+built_room_list.CANNON_OUTPOST.size()*2
	state.MilitaryCapacity.Skull_Dwarf = noForgottenCrypts*20
	state.MilitaryCapacity.Adventurer = built_room_list.INN.size()
	
	update_MC()
	
	for room in room_list:
		if room.Pointer == active_room:
			if room.Can_recruit == true:
				var inst_recruit_window = Recruit_window.instantiate()
				%TradeDone.disabled = true
				%Recruit_Menu.add_child(inst_recruit_window)
				log_msg("w","Recruit menu opened.")
				RecruitOpened.connect(get_child(0).get_child(3).get_child(0)._window_open)
				RecruitOpened.emit(room,Vector2(state.TradeGoods,state.Resources))
	
	#print("start _process")
	set_process(true)
	
func update_MC():
	for mc in %MC_collector.get_children():
		mc.queue_free()
	
	for mc in state.MilitaryCapacity:
		if state.MilitaryCapacity[mc] > 0:
			var labl = Label.new()
			labl.text = mc+" "+str(state.MilitaryCapacity[mc])
			%MC_collector.add_child(labl)
	
func summon_creature(room: Room, streng:int, cName: Array[String], hostile:String, number: int = 1, ranged:bool = false):
	var creature = cName.pick_random()
	var enemy = Unit.new()
	for x in room_list:
		if x == room:
			for y in number:
				#print("Summoned "+creature+" at: "+str(x.Coordinate))
				log_msg("g","Summoned "+creature+" at: "+str(x.Coordinate))
				enemy.Coordinate = x.Coordinate
				enemy.Hostile = hostile
				enemy.Name = creature
				enemy.Str = streng
				enemy.Ranged = ranged
				x.Units.push_back(enemy)
	
func nonbuild_room_effects(room: Room, debpth: int, bonus_to_currency: int):
	match room.Name:
		"TRADE_GOOD": 
			#print(room.Name)
			var rnd = randi_range(1,12)
			var addable = rnd + debpth + bonus_to_currency
			if state.TradeGoods + addable <= state.MaxTradeGoods:
				state.TradeGoods += addable
				fluff.display_currency_changed_at(%Fluff,currency_change_floater,room.Coordinate,0,addable)
				#print("Added "+str(addable)+" Trade Goods")
				log_msg("g","Added "+str(rnd)+"+"+str(debpth)+"+"+str(bonus_to_currency)+" Trade Goods")
			else: 
				state.TradeGoods = state.MaxTradeGoods
				fluff.display_currency_changed_at(%Fluff,currency_change_floater,room.Coordinate,0,addable)
				#print("Maxed Trade Goods")
				log_msg("g","Maxed Trade Goods")
		"RESOURCE": 
			#print(room.Name)
			var rnd = randi_range(1,12)
			var addable = rnd + debpth + bonus_to_currency
			if state.Resources + addable <= state.MaxResources:
				state.Resources += addable
				fluff.display_currency_changed_at(%Fluff,currency_change_floater,room.Coordinate,addable,0)
				#print("Added "+str(addable)+" Resources")
				log_msg("g","Added "+str(rnd)+"+"+str(debpth)+"+"+str(bonus_to_currency)+" Resources")
			else: 
				state.Resources = state.MaxResources
				fluff.display_currency_changed_at(%Fluff,currency_change_floater,room.Coordinate,addable,0)
				#print("Maxed Resources")
				log_msg("g","Maxed Resources")
		"UNDERGROUND_FOREST":
			#print(room.Name)
			log_msg("g","'Undergroun forest' bonus enabeled!")
			enabeled_bonuses.UNDERGROUND_FOREST = true
		"GAS-FILLED_CHAMBER":
			print(room.Name)
			var gas = ["POISON_GAS","FLAMMABLE_GAS","BLINDING_GAS"].pick_random()
			for x in room_list:
				if x == room:
					x.Status.push_back(gas)
					#print(x.Name+" gassified "+ gas)
					log_msg("g",x.Name+" gassified with "+ gas)
		"NATURAL_MAGIC_CAVE":
			print(room.Name)
			match randi_range(0,1):
				0:
					#print("Good magic...")
					log_msg("g","Good magic...")
				1:
					#print("Bad magic...")
					log_msg("g","Bad magic...")
		"UNDERGROUND_RIVER":
			print(room.Name)
			var flod = "FLODDED_WATER"
			for x in room_list:
				if x == room:
					x.Status.push_back(flod)
					#print(x.Name+" flodded "+ flod)
					log_msg("g",x.Name+" flodded with "+ flod)
		"CAVERN":
			print(room.Name)
		"CRYSTAL_CAVERN":
			#print(room.Name)
			room.Buildable = true
			enabeled_bonuses.CRYSTAL_CAVERN = true
			log_msg("g","'Crystal cavern' bonus enabeled!")
		"MAGMA_FLOW":
			print(room.Name)
			var flod = "FLODDED_LAVA"
			for x in room_list:
				if x == room:
					x.Status.push_back(flod)
					#print(x.Name+" flodded "+ flod)
					log_msg("g",x.Name+" flodded with "+ flod)
		"UNDERGROUND_LAKE":
			print(room.Name)
			var flod = "FLODDED_WATER"
			for x in room_list:
				if x == room:
					x.Status.push_back(flod)
					#print(x.Name+" flodded "+ flod)
					log_msg("g",x.Name+" flodded with "+ flod)
		"HIVE_OF_CREATURES":
			print(room.Name)
			summon_creature(room, 10, ["Black Wasps","Giant Ants","Clockwork Spiders","Snakes"], "Yes")
		"VOLCANIC_SHAFT":
			print(room.Name)
		"CAVERN_WITH_TAMEABLE_CRATURE":
			print(room.Name)
			summon_creature(room, 10, ["Rat","Mole","Bat"], "Neutral")
		"CAVERN_WITH_LARGE_CREATURE":
			print(room.Name)
			summon_creature(room, 40, ["Large Rat","Large Mole","Large Bat"], "Neutral")
		"CAVERN_WITH_BURROWING_BEAST":
			print(room.Name)
			summon_creature(room, 20, ["Burrowing Beast"], "Yes")
		"MONSTER_VILLAGE":
			print(room.Name)
			summon_creature(room, 10, ["Goblins","Kobolds","Frog People","Pixies"], "Yes")
		"FORGOTTEN_CRYPTS":
			print(room.Name)
			summon_creature(room, 20, ["Undead"], "Yes")
			enabeled_bonuses.FORGOTTEN_CRYPTS = true
			log_msg("g","'Forgotten crypts' bonus enabeled!")
		"WISHING_WELL":
			print(room.Name)
			enabeled_bonuses.WISHING_WELL = true
			log_msg("g","'Wishing well' bonus enabeled!")
		"SEALED_ROOM":
			print(room.Name)
			#print("Bad magic")
			log_msg("g","Bad magic...")
		"ABANDONED_MINE":
			print(room.Name)
			var addable = 20 + debpth*2
			if state.TradeGoods + addable <= state.MaxTradeGoods:
				state.TradeGoods += addable
				#print("Added 20"+str(debpth)+"*2 Trade Goods")
				log_msg("g","Added 20"+str(debpth)+"*2 Trade Goods")
			else: 
				state.TradeGoods = state.MaxTradeGoods
				#print("Maxed Trade Goods")
				log_msg("g","Maxed Trade Goods")
		"BURRIED_TEMPLE":
			print(room.Name)
			summon_creature(room, 20, ["Cleric"], "No")
			match randi_range(0,3):
				0: log_msg("g","Good magic...")
				1: log_msg("g","Bad magic...")
				2: log_msg("g","Bad magic...")
				3: log_msg("g","Bad magic...")
		"ABANDONED_ROOM":
			print(room.Name)
			print("Place a room")
		"ANCHIENT_LIBRARY":
			print(room.Name)
			match randi_range(0,1):
				0: log_msg("g","Good magic...")
				1: log_msg("g","Bad magic...")
		"DEMON_PORAL":
			print(room.Name)
			enabeled_bonuses.DEMON_PORAL = true
			log_msg("g","'Demon portall' bonus enabeled!")
		"GOLEM_FORGE":
			print(room.Name)
			enabeled_bonuses.GOLEM_FORGE = true
			log_msg("g","'Golem forge' bonus enabeled!")
		"LOST_ARTEFACT":
			print(room.Name)
			summon_creature(room, 1, ["Artefact"], "No")
		"SLUMBERING_WYRM":
			print(room.Name)
			summon_creature(room, 100, ["Wyrm"], "Neutral")
			enabeled_bonuses.SLUMBERING_WYRM = true
			log_msg("g","'Slumbering wyrm' bonus enabeled!")
		"HALLS_OF_THE_LICH_KING":
			print(room.Name)
			summon_creature(room, 20, ["Undead"], "Yes")
		"BONE_CAVE":
			print(room.Name)
		"SLIME_CAVE":
			print(room.Name)
			summon_creature(room, 20, ["Slimes"], "Yes")
		"MEAT_CAVE":
			print(room.Name)
		"PORTAL":
			print(room.Name)
		"NUT_AND_SQUIRELL_CAVE":
			print(room.Name)
			var flod = "FLODDED_NUTS"
			for x in room_list:
				if x == room:
					x.Status.push_back(flod)
					#print(x.Name+" flodded "+ flod)
					log_msg("g",x.Name+" flodded with "+ flod)
			summon_creature(room, 10, ["Squirrels"], "Yes")
		"GOD_MUSHROOM_CAVE":
			print(room.Name)
			summon_creature(room, 1, ["God Mushroom"], "Neutral")
		"TIME_CRYSTALS":
			print(room.Name)
			enabeled_bonuses.TIME_CRYSTALS = true
			log_msg("g","'Time crystals' bonus enabeled!")
		"LIVING_FOSSILS":
			print(room.Name)
			if enabeled_bonuses.TIME_CRYSTALS:
				summon_creature(room, 100, ["Living Fossil"], "Yes")
		"MOLE_VILLAGE":
			print(room.Name)
			enabeled_bonuses.MOLE_VILLAGE = true
			log_msg("g","'Mole village' bonus enabeled!")
		"CRYSTAL_DWARFT_WITH_ARTEFACT":
			print(room.Name)
			print("LEGENDARY FIND")
		"SMART_CREATURE":
			print(room.Name)
			enabeled_bonuses.SMART_CREATURE = true
			log_msg("g","'Smart creature' bonus enabeled!")
		"WHISTLING_CAVE":
			print(room.Name)
			enabeled_bonuses.WHISTLING_CAVE = true
			log_msg("g","'Whistling cave' bonus enabeled!")
		"REALM_OF_LOST_THINGS":
			print(room.Name)
			enabeled_bonuses.REALM_OF_LOST_THINGS = true
			log_msg("g","'Realm of lost thing' bonus enabeled!")

func add_to_RSEL(Name:String,Message:String,UI:bool):
	roundstart_effect_dict.push_back({"Name":Name,"Message":Message,"UI":UI})
	
func count_unit(unitName:String):
	var count = 0
	if unitName.to_upper() == "H":
		for room in room_list:
			for unit in room.Units:
				if unit.Hostile == "Yes":
					count += 1
	else:
		for room in room_list:
			for unit in room.Units:
				if unit.Name == unitName:
					count+=1
	return count

func count_rooms(roomName:String):
	var count = 0
	for room in room_list:
		if room.Name == roomName:
			count += 1
	return count

func roundstart_effects(depth: int, bonus_to_currency: int):
	print("Round start effects --->")
	roundstart_effect_dict.clear()
	if count_rooms("UNDERGROUND_FOREST") == 0:
		enabeled_bonuses.UNDERGROUND_FOREST = false
	
	
	if enabeled_bonuses.UNDERGROUND_FOREST == true:
		
		var visible_underground_forests : Array[Room]
		for room in get_visible_rooms():
			if room.Name == "UNDERGROUND_FOREST":
				visible_underground_forests.push_back(room)
		if state.Resources + visible_underground_forests.size()  + bonus_to_currency <= state.MaxResources:
			state.Resources += (visible_underground_forests.size()  + bonus_to_currency)
			for room in visible_underground_forests:
				fluff.display_currency_changed_at(%Fluff,currency_change_floater,room.Coordinate,1,0)
			print("Added "+str(visible_underground_forests.size()  + bonus_to_currency)+" to resources via UNDERGROUND_FOREST")
			add_to_RSEL("UNDERGROUND_FOREST","Added "+str(visible_underground_forests.size()  + bonus_to_currency)+" to resources via UNDERGROUND_FOREST",false)
			add_to_RSEL("UNDERGROUND_FOREST","Make some extra space by cutting down the forest?",true)
		else:
			state.Resources = state.MaxResources
			for room in visible_underground_forests:
				fluff.display_currency_changed_at(%Fluff,currency_change_floater,room.Coordinate,1,0)
			print("Maxed resources via UNDERGROUND_FOREST")
			add_to_RSEL("UNDERGROUND_FOREST","Maxed resources via UNDERGROUND_FOREST",false)
			add_to_RSEL("UNDERGROUND_FOREST","Make some extra space by cutting down the forest?",true)
	
	if enabeled_bonuses.CRYSTAL_CAVERN == true:
		var visible_crystal_caverns : Array[Room]
		for room in get_visible_rooms():
			if room.Name == "CRYSTAL_CAVERN":
				visible_crystal_caverns.push_back(room)
		for room in visible_crystal_caverns:
			for x in room_list:
				if x == room:
					var rand = randi_range(1,12)
					if rand == 0:
						x.Name = "CAVERN"
						x.Room_id = gen_room_id(x)
						print("CRYSTAL_CAVERN destrolyed.")
						add_to_RSEL("CRYSTAL_CAVERN","CRYSTAL_CAVERN destrolyed at "+str(x.Coordinate),false)
					else :
						if state.TradeGoods + rand + depth + bonus_to_currency <= state.MaxTradeGoods:
							fluff.display_currency_changed_at(%Fluff,currency_change_floater,room.Coordinate,0,(rand + depth + bonus_to_currency))
							state.TradeGoods += (rand + depth + bonus_to_currency)
							print("Added "+str(rand + depth + bonus_to_currency)+" to trade goods via CRYSTAL_CAVERN at "+str(x.Coordinate))
							#add_to_RSEL("CRYSTAL_CAVERN","Added "+str(rand + depth + bonus_to_currency)+" to trade goods via CRYSTAL_CAVERN at "+str(x.Coordinate),false)
						else:
							fluff.display_currency_changed_at(%Fluff,currency_change_floater,room.Coordinate,0,(rand + depth + bonus_to_currency))
							state.TradeGoods = state.MaxTradeGoods
							print("Maxed trade goods via CRYSTAL_CAVERN at "+str(x.Coordinate))
							#add_to_RSEL("CRYSTAL_CAVERN","Maxed trade goods via CRYSTAL_CAVERN at "+str(x.Coordinate),false)
	
	if enabeled_bonuses.FORGOTTEN_CRYPTS == true:
		var visible_forgotten_crypts : Array[Room]
		for room in get_visible_rooms():
			if room.Name == "FORGOTTEN_CRYPTS":
				visible_forgotten_crypts.push_back(room)
		for room in visible_forgotten_crypts:
			if room.Can_recruit == false:
				summon_creature(room, 20, ["Undead"], "Yes")
				add_to_RSEL("FORGOTTEN_CRYPTS","Undead summoned at FORGOTTEN_CRYPTS",false)
			var non_friendly_units = 0
			for unit in room.Units:
				if unit.Hostile == "Yes" || unit.Hostile == "Neutral":
					non_friendly_units +=1
			if non_friendly_units == 0 :
				room.Can_recruit = true
	
	if enabeled_bonuses.WISHING_WELL == true:
		add_to_RSEL("WISHING_WELL","Do you wish to make a wish at the wishing well for 10 Trade Goods?",true)
		
	if enabeled_bonuses.DEMON_PORAL == true:
		var visible_demon_portals : Array[Room]
		for room in get_visible_rooms():
			if room.Name == "DEMON_PORAL":
				visible_demon_portals.push_back(room)
		for room in visible_demon_portals:
			var rand = randi_range(1,4)
			if rand == 1:
				summon_creature(room, 20, ["Demons"], "Yes")
				add_to_RSEL("DEMON_PORAL","Demons summoned at DEMON_PORAL",false)
		if count_unit("Cleric") > 0 && state.TradeGoods >= 20:
			add_to_RSEL("DEMON_PORAL","Do you wish to make a sacrifice to close the Demon Portal?",true)
		else:
			add_to_RSEL("DEMON_PORAL","A sacrifice cannot be made to close the Demon Portal.\nNot enough Trade goods or no cleric is present.",false)
		
	if enabeled_bonuses.GOLEM_FORGE == true:
		var visible_golem_forges : Array[Room]
		for room in get_visible_rooms():
			if room.Name == "GOLEM_FORGE":
				visible_golem_forges.push_back(room)
		for room in visible_golem_forges:
			if room.Can_recruit == false && room.Units.size() == 0:
				summon_creature(room, 20, ["Ruined Golem"], "Yes")
				set_process(true)
				change_stage(1)
			var non_friendly_units = 0
			for unit in room.Units:
				if unit.Hostile == "Yes" || unit.Hostile == "Neutral":
					non_friendly_units +=1
			if non_friendly_units == 0 :
				room.Can_recruit = true
		
	if enabeled_bonuses.SLUMBERING_WYRM == true:
		add_to_RSEL("SLUMBERING_WYRM","Do you wish to plunder the wyrms hoard?",true)
		
	if enabeled_bonuses.MOLE_VILLAGE == true:
		for room in get_visible_rooms():
			if room.Name == "MOLE_VILLAGE":
				room.Can_recruit = true
		
	if enabeled_bonuses.SMART_CREATURE == true:
		add_to_RSEL("SMART_CREATURE","Do you wish to call upon an Unusually Inteliget Creature to assist in discovery?",true)
		
	if enabeled_bonuses.REALM_OF_LOST_THINGS == true:
		var random = randi_range(1,12)
		state.TradeGoods += random
		add_to_RSEL("REALM_OF_LOST_THINGS","A wealth of "+random+" Trade Goods have been found.",true)

	if enabeled_bonuses.STOCKPILE == true:
		match randi_range(1,51):
			51:match randi_range(1,4):
				1:
					add_to_RSEL("STOCKPILE","An infestation has consumed "+str(floor(state.Resources/2))+" resources",true)
					state.Resources = floor(state.Resources/2)
				_:
					summon_creature(built_room_list.STOCKPILE.pick_random(),60,["Displaced elemental"],"Yes")
					change_stage(1)
	
	if enabeled_bonuses.TREASURY == true:
		match randi_range(1,51):
			51:match randi_range(1,4):
				1:
					add_to_RSEL("TREASURY","Thieves have stolen "+str(floor(state.TradeGoods/2))+" Trade Goods",true)
					state.Resources = floor(state.TradeGoods/2)
				_:
					summon_creature(built_room_list.STOCKPILE.pick_random(),40,["thieves"],"Yes")
					change_stage(1)
	
	if enabeled_bonuses.LABORATORY == true:
		var labs:Array[Room]
		for room in get_visible_rooms():
			if room.Name == "LABORATORY":
				labs.push_back(room)
		if count_unit("Alchemist") >= 50:
			var room = labs.pick_random()
			match randf_range(1,51):
				1:
					room.Buildable = false
					room.Name = "CAVERN"
					room.Room_id = gen_room_id(room)
					room.Units.clear()
				51:
					enabeled_bonuses.LABORATORY = true
			add_to_RSEL("LABORATORY","Do science!",false)
	
	if enabeled_bonuses.PRISON == true:
		for room in get_visible_rooms():
			if room.Name == "PRISON":
				if state.MilitaryCapacity.Prisoner < count_unit("Prisoner"):
					summon_creature(room,1,["Prisoner"],"Neutral",2)
					add_to_RSEL("PRISON","Added prisoner to prison",false)
				if floor(count_unit("Prisoner")/20) >= 1:
					if state.MaxTradeGoods >= state.TradeGoods+20:
						state.TradeGoods += 20
						fluff.display_currency_changed_at(%Fluff,currency_change_floater,room.Coordinate,0,20)
						add_to_RSEL("PRISON","Added 20 Trade Goods.",false)
					else:
						state.TradeGoods = state.MaxTradeGoods
						fluff.display_currency_changed_at(%Fluff,currency_change_floater,room.Coordinate,0,20)
						add_to_RSEL("PRISON","Maxed out trade goods via prison.",false)
					%CurrentGold.set_text(str(state.TradeGoods))
	
	var inst_RS_collector_window = RS_collector_winodw.instantiate()
	if roundstart_effect_dict.size() > 0:
		%"Round Start Collector".add_child(inst_RS_collector_window)
		open_roundstart_UI_elements.connect(get_child(0).get_child(2).get_child(0)._open_roundstart_UI_elements)
		open_roundstart_UI_elements.emit(roundstart_effect_dict)
	else:
		change_stage(0)
		print("start _process")
		set_process(true)
		
	
	roundstart_effect_dict.clear()


#-------Generation-------

#1. We generate an array of coordinates representing the grid of rooms in the playable area.
#	The distaance and position is dependent on the size of the grid and the size of the individual rooms.

#2. We generate vertiacal and horizontal blocking rooms (such as vulcanic shaft, magma flow or underground river).
#	The vertical rooms alvays have priority and horizontal rooms with no connection to the edge of the grid will be removed.
#	1 of theese sould be generated every 80-100 rooms to not block everything.
#	Horizontal blocking rooms cannot generate above laler 3.

#3. We generate rooms with a max size of 6.
#	Only generate 1 below layer 8.

#4. We generate rooms with a max size of 4.
#	Layer restricted rooms cannot generate into other layers.

#5. We generate rooms with a max size of 2.
#	Layer restricted rooms cannot generate into other layers.

#6. We generate rooms with a max size of 1.

#7. We generate Resources and Trade Goods on the remaining spaces.
#	At the end no more than 2/5 of the rooms sould be Resources or Trade Goods

#-------Gameplay-------

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	%GameMusic.play()
	%GameMusic.volume_db = -80
	soundTween.tween_property(%GameMusic,"volume_db",-10,1)
	start_time = Time.get_unix_time_from_system()
	all_rooms = read_json("res://Resources/Data/AllRooms.json")
	var id = 0
	for room in AllRooms_as_dict:
		%Search_room_dropdown.add_item(room.Name,id)
		id+=1
	if GlobalLoadData.save_to_load_path.length() >0:
		log_msg("b",GlobalLoadData.save_to_load_path)
		load_game(GlobalLoadData.save_to_load_path)
	else:
		log_msg("b","New Game")
		new_game()
	Draw_everithing()
	center_on_entrance()
	re_draw_everithing()
	%RoomBorder.position = room_list[0].Coordinate - Vector2(80,90)
	
	astar_grid.region = Rect2i(0,0,grid_size[0],grid_size[1])
	astar_grid.diagonal_mode = 1
	astar_grid.update()
	
	
	#print("INSERT INTO `rooms_rom` (`SAE_id`, `PYR_SAE_id`, `Coordinate`, `name`, `buildable`, `connectediD`, `trap`, `wall_top`, `wall_right`, `wall_bottom`, `wall_left`) VALUES")
	#for room in room_list:
		#print( "('2024-11-14 12:40:16', 'lime.lime@lime.lime', '"+str(room.Coordinate[0])+"_"+str(room.Coordinate[1])+"', '"+room.Name+"', '0', '"+room.Room_id+"', NULL, NULL, NULL, NULL, NULL),")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	state.SessionTime = Time.get_unix_time_from_system() - start_time
	if state.GamePhase == -1:
		
		roundstart_effects(0,0)
		
		#print("pause _process")
		set_process(false)

	if state.GamePhase == 1:
		#log_msg("r",str(count_unit("h")))
		%TradeDone.disabled = true
		stage_Combat()
		#print("pause _process")
		set_process(false)
		

func _on_regenerate_mapp_pressed() -> void:
	print("Regenerating...")
	new_game()
	placement_scripts.temp_place(room_list,tempRoom,tempUnit,tempStatus,%RoomCollector,grid_size)

func _on_room_clicked(passed_room) -> void:
	room_intaraction_room = passed_room
	room_choosen.emit()
	match state.GamePhase:
		0:
			stage_Explore(passed_room)
			set_process(true)
		3:
			for room in room_list:
				if room.Pointer == passed_room:
					if !room.Status.is_empty(): 
						print("Cannot access room")
					elif room.Buildable == false:
						stage_Build(passed_room)
					else:
						print("Room already taken")
		4: stage_Recruit(passed_room)

func _on_room_clicked_right(passed_room) -> void:
	for room in room_list:
		if room.Pointer == passed_room && room.Hidden == false:
			var inst_Info = Info_window.instantiate()
			inst_Info.title = room.Name
			var desc;
			for x in all_rooms:
				if x.Name == room.Name:
					desc = x.Description
			inst_Info.get_child(0).get_child(1).text = str(desc)
			inst_Info.position = get_local_mouse_position()
			for unit in room.Units:
				var labl = U_button.instantiate()
				labl.text = unit.Name
				inst_Info.get_child(0).get_child(5).add_child(labl)
			get_child(0).get_child(0).add_child(inst_Info)
			sendToClearRoom.connect(get_child(0).get_child(0).get_child(get_child(0).get_child(0).get_child_count()-1)._current_room)
			sendToClearRoom.emit(room)
			sendToClearRoom.disconnect(get_child(0).get_child(0).get_child(get_child(0).get_child(0).get_child_count()-1)._current_room)
			

func _on_to_gold_pressed() -> void:
	var localGold = state.TradeGoods
	var localSilver = state.Resources
	
	if localGold+1 <= state.MaxTradeGoods && localSilver-2 >= 0:
		localGold+=1
		localSilver-=2
		state.TradeGoods = localGold
		state.Resources = localSilver
		log_msg("g","Converted 2 Resources to 1 Trade Goods")
		reload_currency()

func _on_to_silver_pressed() -> void:
	var localGold = state.TradeGoods
	var localSilver = state.Resources

	if localGold-1 >=0 && localSilver+2 <= state.MaxResources:
		localGold-=1
		localSilver+=2
		state.TradeGoods = localGold
		state.Resources = localSilver
		log_msg("g","Converted 1 Trade Goods to 2 Resources")
		reload_currency()

func _on_trade_done_pressed() -> void:
	match state.GamePhase:
		2:
			trade_close()
			log_msg("r","Stage Done or skipped!")
			change_stage(3)
		3:
			log_msg("r","Stage Done or skipped!")
			change_stage(4)
		4:
			set_process(true)
			log_msg("r","Stage Done or skipped!")
			change_stage(-1)

func _on_infinite_materials_pressed() -> void:

	state.TradeGoods += 1000
	state.Resources += 1000
	reload_currency()

func _on_display_clickable_rooms_pressed() -> void:
	match state.GamePhase:
		0: 
			for room in get_clickable_non_visible_rooms():
				if get_visible_rooms().find(room) == -1:
					room.Pointer.get_child(0).get_child(4).visible = true
			await get_tree().create_timer(1).timeout
			for room in room_list:
				room.Pointer.get_child(0).get_child(4).visible = false
		1: pass
			#for room in get_visible_rooms():
			#	for all_units_in_current_room in room.Units:
			#		for unit in all_units_in_current_room:
			#			if unit.Hostile == "No":
			#				room.Pointer.get_child(0).get_child(4).visible = true
			#await get_tree().create_timer(1).timeout
			#for room in room_list:
			#	room.Pointer.get_child(0).get_child(4).visible = false
		2:
			if get_tree() != null:
				var sColor = $Camera2D/CanvasLayer/Tray/VBoxContainer/ColorRect.color
				$Camera2D/CanvasLayer/Tray/VBoxContainer/ColorRect.color = Color(0.1,1,0)
				await get_tree().create_timer(1).timeout
				$Camera2D/CanvasLayer/Tray/VBoxContainer/ColorRect.color = sColor
		3: 
			for room in get_visible_rooms():
				if room.Buildable == false and room.Status.is_empty():
					room.Pointer.get_child(0).get_child(4).visible = true
			await get_tree().create_timer(1).timeout
			for room in room_list:
				room.Pointer.get_child(0).get_child(4).visible = false
		4: 
			for room in get_visible_rooms():
				if room.Can_recruit == true:
					room.Pointer.get_child(0).get_child(4).visible = true
			await get_tree().create_timer(1).timeout
			for room in room_list:
				room.Pointer.get_child(0).get_child(4).visible = false

func _roundstart_effect_response(resp)-> void:
	if resp.Name != "END":
		roundstart_effect_return.push_back(resp)
		print("not END addaed: "+str(resp))
	else:
		#print("hohihoh")
		for effect in roundstart_effect_return:
			match effect.Name:
				"UNDERGROUND_FOREST":
					if effect.Response == true:
						%Current_needed_action.text = "Choose a forest to demolish." 
						await room_choosen
						for x in room_list:
							while room_intaraction_room == x.Pointer and x.Name != "UNDERGROUND_FOREST":
								await room_choosen
							if room_intaraction_room == x.Pointer and x.Name == "UNDERGROUND_FOREST":
								print("Dem a forest at: "+str(x.Coordinate))
								x.Name = "CAVERN"
								x.Room_id = gen_room_id(x)
								re_draw_everithing()
	
				"WISHING_WELL":
					if effect.Response == true:
						match randi_range(0,1):
							0: print("Good_magic")
							0: print("Baad_magic")
				"DEMON_PORAL":
					if effect.Response == true:
						%Current_needed_action.text = "Choose a demon portal to close."
						await room_choosen
						
						for x in room_list:
							if room_intaraction_room == x.Pointer:
								x.Name = "CAVERN"
				"SLUMBERING_WYRM":
					if effect.Response == true:
						%Current_needed_action.text = "Choose a slumbering wyrm to steal from."
						await room_choosen
						
						for x in room_list:
							if room_intaraction_room == x.Pointer:
								match randi_range(0,3):
									0: 
										#print("Wakey, wakey!")
										x.Name = "CAVERN"
										x.Room_id = gen_room_id(x)
										x.Units.clear()
										var angry_wyrm = Unit.new()
										angry_wyrm.Coordinate = x.Coordinate
										angry_wyrm.Hostile = "Yes"
										angry_wyrm.Name = "Wyrm"
										angry_wyrm.Placed = true
										angry_wyrm.Str = 100
										x.Units.push_back(angry_wyrm)
										
									1: state.TradeGoods += 20
									2: state.TradeGoods += 20
									3: state.TradeGoods += 20
						
				"SMART_CREATURE":
					if effect.Response == true:
						%Current_needed_action.text = "Choose a smart creature to commune with."
						await room_choosen
						
						for x in room_list:
							if room_intaraction_room == x.Pointer:
								var dangerous_rooms: Array[Room]
								var rooms_tb_displayed : Array[Room]
								for y in room_list:
									if ["GAS-FILLED_CHAMBER","UNDERGROUND_RIVER","MAGMA_FLOW","UNDERGROUND_LAKE","HIVE_OF_CREATURES","VOLCANIC_SHAFT","CAVERN_WITH_LARGE_CREATURE","CAVERN_WITH_BURROWING_BEAST","MONSTER_VILLAGE","FORGOTTEN_CRYPTS","DEMON_PORAL","HALLS_OF_THE_LICH_KING","NUT_AND_SQUIRELL_CAVE","GOD_MUSHROOM_CAVE"].find(y.Name):
										dangerous_rooms.push_back(y)
								for dRoom in dangerous_rooms:
									for hRoom in get_clickable_non_visible_rooms():
										if dRoom == hRoom:
											rooms_tb_displayed.push_back(dRoom)
								for disRoom in rooms_tb_displayed:
									disRoom.Pointer.get_child(0).get_child(4).font_color = Color(1,0,0,1)
									disRoom.Pointer.get_child(0).get_child(4).visible = true
								await get_tree().create_timer(5).timeout
								for disRoom in room_list:
									disRoom.Pointer.get_child(0).get_child(4).font_color = Color(1,0.57,1,1)
									disRoom.Pointer.get_child(0).get_child(4).visible = false
						
		
		roundstart_effect_return.clear()
		change_stage(0)
		print("start _process")
		set_process(true)
	print("Round start end...")
	#print(str(resp))

func _on_search_room_pressed() -> void:
	for room in room_list:
		if room.Name == AllRooms_as_dict[$Camera2D/CanvasLayer/Tray/Search_room_dropdown.selected].Name:
			room.Pointer.get_child(0).get_child(4).visible = true
	await get_tree().create_timer(1).timeout
	for room in room_list:
				room.Pointer.get_child(0).get_child(4).visible = false

func _empty_room(room:Room,price):
	for aRoom in room_list:
		if aRoom.Pointer == room.Pointer:
			state.Resources -= price
			aRoom.Status.clear()
			aRoom.Name = "CAVERN"
			aRoom.Room_id = gen_room_id(aRoom)
			re_draw_everithing()

func _build_room(Name:String,Target:Room,price:Vector2):
	#print("Building "+Name+" on "+str(Target.Coordinate)+" to replace "+Target.Name )
	if Name == "EXIT":
		%TradeDone.disabled = false
	else:
		%TradeDone.disabled = false
		state.TradeGoods-=price[0]
		state.Resources-=price[1]
		for child in %Build_Menu.get_children():
			child.queue_free()
		for room in room_list:
			if room == Target:
				room.Name = Name
				room.Buildable = true
				room.Room_id = gen_room_id(room)
				log_msg("g",Name+" room built at "+str(room.Coordinate))
				match Name:
					"INN":
						var INN_residents : Array[Unit]
						for unit in (read_json("res://Resources/Data/AllUnits.json")):
							if int(unit.Cost) == 0:
								var resident = Unit.new()
								resident.Name = unit.Unit
								resident.Hostile = "No"
								resident.Coordinate = Target.Coordinate
								resident.Str = unit.STR
								INN_residents.push_back(resident)
								match resident.name:
									"Witch":
										%Current_needed_action.text = "Choose a unit / Troop to experiment on." 
										await room_choosen
										var rooms_with_friendlies : Array[Room]
										for lRoom in room_list:
											for lUnit in room.Units:
												if lUnit.Hostile == "No":
													rooms_with_friendlies.append(lRoom)
										for x in room_list:
											while room_intaraction_room == x.Pointer and rooms_with_friendlies.find(x) == -1:
												await room_choosen
											if room_intaraction_room == x.Pointer and rooms_with_friendlies.find(x) != -1:
												var choices = [{"origin":"Witch","value":"*2","desc":"Doubles the strength of unit"},{"origin":"Witch","value":"-10","desc":"Paralised unit cannot move."}].pick_random()
												for xUnit in x.Units:
													xUnit.Effects.append(choices)
								re_draw_everithing()
						var choosen = INN_residents.pick_random()
						summon_creature(room,choosen.Str,[choosen.Name],choosen.Hostile)
						room.Can_recruit = true
					"LIBRARY":
						print("Good magic...")
						log_msg("g","Good magic...")
					"BARRACKS":
						room.Can_recruit = true
					"FORGE":
						room.Can_recruit = true
					"KENNEL":
						room.Can_recruit = true
					"LABORATORY":
						room.Can_recruit = true
					"LIBRARY":
						room.Can_recruit = true
					"STOCKPILE":
						state.MaxResources += 50
						enabeled_bonuses.STOCKPILE = true
					"TREASURY":
						state.MaxTradeGoods += 50
						enabeled_bonuses.TREASURY = true
					
		built_room_list[Name].push_back(Target)
		%RoomBuilt.play()
		
		change_stage(4)
		re_draw_everithing()

func _recruit_unit(Name:String,Strength:int,ranged:String,Target:Room,price:Vector2):
	if Name == "EXIT":
		%TradeDone.disabled = false
	else:
		%TradeDone.disabled = false
		state.TradeGoods-=price[0]
		state.Resources-=price[1]
		
		var Ranged :bool =false
		if ranged.length() > 0:
			Ranged = true
		
		for child in %Recruit_Menu.get_children():
			child.queue_free()
		
		for room in room_list:
			if room == Target:
				summon_creature(room,Strength,[Name],"No",1,Ranged)
				%Recruited.play()
					
		
		change_stage(-1)
		re_draw_everithing()

func _on_combat_done_pressed() -> void:
	combat_turn_done.emit()
	for room in room_list:
		for unit in room.Units:
			unit.Moved = false
	re_draw_everithing()

func _move_friendly_unit(move_data) -> void:
	log_msg("g",str(move_data))
	if move_data.UnitId == -1:
		log_msg("r","ERROR!!! NO UNIT ID AT FRIENDLY MOVEMENT REQUEST!!!")
		
	var from_room :Room
	var can_move_if_combat :Array[Room]
	var can_move_not_combat : Array[Room]
	
	for room in room_list:
		if room.Pointer == move_data.FromRoomPoiner:
			from_room = room
	
	for room in room_list:
		if get_visible_rooms().find(room) != -1 and room.Status.size() == 0:
			can_move_not_combat.push_back(room)
	for room in room_list:
		if get_visible_rooms().find(room) != -1 and room.Status.size() == 0:
			if room == room_list[room_list.find(from_room)+1] or room == room_list[room_list.find(from_room)-1] or room == room_list[room_list.find(from_room)+grid_size[1]] or room == room_list[room_list.find(from_room)-grid_size[1]]:
				can_move_if_combat.push_back(room)
	re_draw_everithing()
	

	
	if state.GamePhase == 1:
		for room in room_list:
			if room.Pointer == move_data.FromRoomPoiner:
				if move_data.Single:
					log_msg("w",room.Units[move_data.UnitId].Name)
					
					await room_choosen
					for x in room_list:
						if x.Pointer == room_intaraction_room and can_move_if_combat.find(x) != -1 and room.Units[move_data.UnitId].Moved == false:
							moove_unit(room.Units[move_data.UnitId],room,x)
				else:
					await  room_choosen
					for x in room_list:
						if x. Pointer == room_intaraction_room and can_move_if_combat.find(x) != -1:
							moove_all_units(room,x)
					for unit in room.Units:
						log_msg("w",unit.Name)
						
	else:
		for room in room_list:
			if room.Pointer == move_data.FromRoomPoiner:
				if move_data.Single:
					log_msg("b",room.Units[move_data.UnitId].Name)
					
					await room_choosen
					for x in room_list:
						if x.Pointer == room_intaraction_room and can_move_not_combat.find(x) != -1:
							moove_unit(room.Units[move_data.UnitId],room,x)
							
				else:
					await room_choosen
					for x in room_list:
						if x. Pointer == room_intaraction_room and can_move_not_combat.find(x) != -1:
							moove_all_units(room,x)
					for unit in room.Units:
						log_msg("b",unit.Name)
		for room in room_list:
			for unit in room.Units:
				unit.Moved = false


func _on_save_button_pressed() -> void:
	start_time = Time.get_unix_time_from_system()
	var inst_save_window = Save_window.instantiate()
	inst_save_window.position = Vector2(980,600)
	%Tray.add_child(inst_save_window)
	var last = $Camera2D/CanvasLayer/Tray.get_children().size()-1.
	var save_window = $Camera2D/CanvasLayer/Tray.get_child(last)
	
	saveRequest.connect(save_window._save_request)
	saveRequest.emit(state,room_list)

func _save_done(State : GameState):
	state = State
