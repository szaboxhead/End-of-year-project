extends Node2D

var color_speed : int
var local_login_values : Dictionary = {"UID":"~placeholder~","Pass":"~placeholder~"}
var cloud_saves : Array
var local_saves : Array
var original_pos : Array[Vector2]
@onready var HTTPrequest : HTTPRequest = %HTTPRequest

const URL : String = "http://localhost:8000"

@onready var card = load("res://Scenes/MainMenu/Load_Game/save_card.tscn")

signal filepath()

func login(UID:String,Pass:String):
	var body = {"UID":UID,"Pass":Pass}
	#print(JSON.stringify(body))
	HTTPrequest.request("https://delvelogin-978221649687.europe-north2.run.app",["Content-Type: application/json"],HTTPClient.METHOD_POST,JSON.stringify(body))

func getSaves():
	var body = {"UID":GlobalAllTimeData.login["UID"],"Pass":GlobalAllTimeData.login["Pass"]}
	HTTPrequest.request("https://delvesave-978221649687.europe-north2.run.app",["Content-Type: application/json"],HTTPClient.METHOD_POST,JSON.stringify(body))

func upload(Save_name:String):
	var replace = false
	if cloud_saves.size() < 3:
		for save in cloud_saves:
			if save.filename == Save_name:
				replace = true
		
		
		for save in local_saves:
			#print(save.filename == Save_name)
			if save.filename == Save_name:
				if replace:
					delete(Save_name)
					await %HTTPRequest.request_completed
					var body = {"UID":GlobalAllTimeData.login["UID"],"Pass":GlobalAllTimeData.login["Pass"],"data":save}
					#print(body)
					HTTPrequest.request("https://delveupload-978221649687.europe-north2.run.app",["Content-Type: application/json"],HTTPClient.METHOD_POST,JSON.stringify(body))

				else:
					var body = {"UID":GlobalAllTimeData.login["UID"],"Pass":GlobalAllTimeData.login["Pass"],"data":save}
					#print(body)
					HTTPrequest.request("https://delveupload-978221649687.europe-north2.run.app",["Content-Type: application/json"],HTTPClient.METHOD_POST,JSON.stringify(body))
					

func delete(Save_name:String):
	for save in cloud_saves:
		#print(save.filename+ " == " +Save_name)
		if save.filename == Save_name:
			var body = {"UID":GlobalAllTimeData.login["UID"],"Pass":GlobalAllTimeData.login["Pass"],"saveName":Save_name}
			#print(body)
			HTTPrequest.request("https://delvedelete-978221649687.europe-north2.run.app",["Content-Type: application/json"],HTTPClient.METHOD_POST,JSON.stringify(body))
			

func createCard(json,save,collector,placer,save_loc):
	var inst_card = card.instantiate()
	
	var savetime = json.data.gamestate.SaveTime
	var playtime= {"Minute" : str(floor(json.data.gamestate.GameLength/60)).pad_zeros(2), "Second":str(int(json.data.gamestate.GameLength) % 60).pad_zeros(2)}

	inst_card.get_child(0).get_child(0).text = json.filename
	inst_card.get_child(0).get_child(2).get_child(0).text = str(savetime.year)+"."+str(savetime.month).pad_zeros(2)+"."+str(savetime.day).pad_zeros(2)+". "+str(savetime.hour).pad_zeros(2)+":"+str(savetime.minute).pad_zeros(2)
	inst_card.get_child(0).get_child(3).get_child(0).text = str(playtime.Minute)+":"+str(playtime.Second)
	inst_card.get_child(0).get_child(4).get_child(0).text = str(json.data.gamestate.SaveNo)
	
	inst_card.position = placer.position
	original_pos.append(placer.position)
	placer.position[1] += inst_card.get_child(0).size[1]+5
	collector.add_child(inst_card)
	filepath.connect(collector.get_child(collector.get_children().size()-1)._recieve_file_path)
	filepath.emit("user://saves/"+save,save_loc)
	filepath.disconnect(collector.get_child(collector.get_children().size()-1)._recieve_file_path)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	local_saves.clear()
	var saves = DirAccess.get_files_at("user://saves/")
	#HTTPrequest.request(URL)
	
	if saves.size() > 2:
		$ColorRect/VScrollBar.visible = true
		$ColorRect/VScrollBar.max_value = saves.size()*10
	for save in saves:
		var raw = FileAccess.open("user://saves/"+save,FileAccess.READ)
		var json = JSON.parse_string(raw.get_as_text())
		createCard(json,save,%Save_collector,%Save_placer,"local")
		local_saves.append(JSON.parse_string(raw.get_as_text()))
	if GlobalAllTimeData.login["UID"] == null || GlobalAllTimeData.login["Pass"] == null:
		%Cloud_collector.visible = false
		%Login.visible = true
	else:
		getSaves()

		
func _process(delta: float) -> void:
	%DarkScreen.color += color_speed * Color(0,0,0,0.01) * delta * 10
	#print(%DarkScreen.color[3])
	if %DarkScreen.color[3] >= 1.2:
		get_tree().change_scene_to_file("res://Scenes/MainMenu/main_menu.tscn")
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("mouse_wheel_down"):
		if local_saves.size() > 2:
			#print("down")
			if $ColorRect/VScrollBar.value <= $ColorRect/VScrollBar.max_value:
				$ColorRect/VScrollBar.value += 1
	if event.is_action_pressed("mouse_wheel_up"):
		if local_saves.size() > 2:
			#print("up")
			if $ColorRect/VScrollBar.value >= 0:
				$ColorRect/VScrollBar.value -= 1
	
	if event.is_action_pressed("ui_cancel"):
		color_speed = 12
	if event.is_action_released("ui_cancel"):
		color_speed = 0
		%DarkScreen.color = Color(0,0,0,0)

func _on_v_scroll_bar_value_changed(value):
	#print(original_pos)
	var last_car_pos = %Save_collector.get_children()[%Save_collector.get_children().size()-2].position
	var second_card = %Save_collector.get_children()[1].position
	for saveId in %Save_collector.get_children().size()-1:
		var save = %Save_collector.get_children()[saveId+1]
		#print(str(saveId)+": "+ str(save.position) +" => "+str(original_pos[saveId] + (value * ((last_car_pos - second_to_last_card)/$ColorRect/VScrollBar.max_value))))
		save.position = original_pos[saveId] - (value * ((last_car_pos - second_card)/$ColorRect/VScrollBar.max_value))
	


func _on_button_login_pressed() -> void:
	login(%Email_input.text,%Pass_input.text)


func _save_requset(saveName:String):
	upload(saveName)
	
func _local_save_requset(saveName:String):
	DirAccess.open("user://").make_dir("saves")
	var file = FileAccess.open("user://saves/"+saveName+".json", FileAccess.WRITE)
	for save in cloud_saves:
		if save.filename == saveName:
			file.store_string(str(save))
			get_tree().reload_current_scene()

func _delete_requset(savename,saveType):
	match saveType:
		"local":
			DirAccess.remove_absolute("user://saves/"+savename+".json")
			get_tree().reload_current_scene()
		"cloud":
			delete(savename)
			await %HTTPRequest.request_completed
			get_tree().reload_current_scene()

func _on_http_request_request_completed(_result: int, response_code: int, _headers: PackedStringArray, body: PackedByteArray) -> void:
	var res_body_json = JSON.parse_string(body.get_string_from_utf8())
	#print(res_body_json)
	match res_body_json["type"]:
		"login":
			if res_body_json["status"] == "OK":
				print("No error! Credentials saved!")
				local_login_values["UID"] = res_body_json["data"]["UID"]
				local_login_values["Pass"] = res_body_json["data"]["Pass"]
				%Cloud_collector.visible = true
				%Login.visible = false
				GlobalAllTimeData.login["UID"] = local_login_values["UID"]
				GlobalAllTimeData.login["Pass"] = local_login_values["Pass"]
				get_tree().reload_current_scene()
			else:
				print("An error occurred in the HTTP request. \nError code: "+str(response_code)+" "+res_body_json["error"] )
				$ColorRect/Login/Tittle.text = "Incorrect detils!"
		"saveGet":
			if res_body_json["status"] == "OK":
				print("No error! Saves got!")
				for save in res_body_json["data"]:
					var json = JSON.parse_string(JSON.parse_string(str(save)).save_data)
					#print(json.filename)
					createCard(json,json.filename+".json",%Cloud_collector,%Cloud_placer,"cloud")
					cloud_saves.append(json)
			else:
				print("An error occurred in the HTTP request. \nError code: "+str(response_code)+" "+res_body_json["error"] )
		"upload":
			if res_body_json["status"] == "OK":
				print("No error! Upload succesfull!")
				get_tree().reload_current_scene()
			else:
				print("An error occurred in the HTTP request. \nError code: "+str(response_code)+" "+res_body_json["error"] )
		"delete":
			if res_body_json["status"] == "OK":
				print("No error! Delete succesfull!")
			else:
				print("An error occurred in the HTTP request. \nError code: "+str(response_code)+" "+res_body_json["error"] )
