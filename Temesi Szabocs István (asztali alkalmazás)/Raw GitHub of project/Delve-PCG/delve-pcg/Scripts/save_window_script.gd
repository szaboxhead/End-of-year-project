extends Window

var state: GameState
var room_list: Array[Room]
var newGameName : String

signal saveDone()


func _save_request(State,Room_List):
	state = State
	room_list = Room_List
	%Save_Name.text = state.GameName
	saveDone.connect(get_parent().get_parent().get_parent().get_parent()._save_done)
	

func _on_save_button_pressed() -> void:
	state.SaveNo+=1
	var save_dict = {
		"filename" : state.GameName,
		"data" : {
			"gamestate" : {
				"Resources" : state.Resources,
				"TradeGoods" : state.TradeGoods,
				"GamePhase" : state.GamePhase,
				"SubPhase" : state.SubPhase,
				"Transmutation" : state.Transmutation,
				"MaxTradeGoods" : state.MaxTradeGoods,
				"MaxResources" : state.MaxResources,
				"MilitaryCapacity" : {
					"Soldier":state.MilitaryCapacity.Soldier,
					"Gunner":state.MilitaryCapacity.Gunner,
					"Hound":state.MilitaryCapacity.Hound,
					"Cleric":state.MilitaryCapacity.Cleric,
					"Mage":state.MilitaryCapacity.Mage,
					"Prisoner":state.MilitaryCapacity.Prisoner,
					"Alchemist":state.MilitaryCapacity.Alchemist,
					"Golem":state.MilitaryCapacity.Golem,
					"Cannon":state.MilitaryCapacity.Cannon,
					"Skull_Dwarf":state.MilitaryCapacity.Skull_Dwarf,
					"Adventurer":state.MilitaryCapacity.Adventurer
				},
				"SaveNo" : state.SaveNo,
				"GameLength" : state.GameLength+state.SessionTime,
				"SaveTime" : Time.get_datetime_dict_from_system(),
				"SessionTime": state.SessionTime,
				"DWARVEN_DOMINANCE" : state.DWARVEN_DOMINANCE,
				"BEASTMASTER" : state.BEASTMASTER,
				"YOU_SHALL_NOT_PASS" : state.YOU_SHALL_NOT_PASS,
				"DRAGONS_ARE_OUR_FRIENDS" : state.DRAGONS_ARE_OUR_FRIENDS,
				"ENDLESS_TREASURY" : state.ENDLESS_TREASURY,
				"HITTING_THE_GYM" : state.HITTING_THE_GYM,
				"MIND_YOUR_STEP" : state.MIND_YOUR_STEP,
				"LOOKING_FOR_GROUP" : state.LOOKING_FOR_GROUP,
				"ARCHMAGE" : state.ARCHMAGE,
				"PROGRESS_AT_ALL_COSTS" : state.PROGRESS_AT_ALL_COSTS
			},
			"room_data": []
		}
	}
	
	for room in room_list:
		var units_in_room = []
		for unit in room.Units:
			units_in_room.append({
				"Coordinate" : [unit.Coordinate[0],unit.Coordinate[1]],
				"Hostile" : unit.Hostile,
				"Name" : unit.Name,
				"Ability" : unit.Ability,
				"Str" : unit.Str,
				"Number" : unit.Number,
				"Placed" : unit.Placed,
				"Moved" : unit.Moved,
				"Effects" : unit.Effects # not good, need fix

			})
		save_dict.data.room_data.append({
			"Coordinate" : [room.Coordinate[0],room.Coordinate[1]],
			"Buildable" : room.Buildable,
			"Status" : room.Status,
			"Status_placed" : room.Status_placed,
			"Name" : room.Name,
			"Room_id" : room.Room_id,
			"Hidden" : room.Hidden,
			"Units" : units_in_room,
			"Can_recruit" : room.Can_recruit,
		})
		
	DirAccess.open("user://").make_dir("saves")
	var file = FileAccess.open("user://saves/"+state.GameName+".json", FileAccess.WRITE)
	file.store_string(str(save_dict))
	saveDone.emit(state)
	queue_free()

func _on_save_as_button_pressed() -> void:
	state.GameName = newGameName
	_on_save_button_pressed()


func _on_save_name_text_changed(new_text: String) -> void:
	newGameName = new_text


func _on_focus_exited() -> void:
	queue_free()


func _on_close_requested() -> void:
	queue_free()
