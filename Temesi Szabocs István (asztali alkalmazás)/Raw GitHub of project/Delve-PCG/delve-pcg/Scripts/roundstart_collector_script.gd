extends Node2D

#@onready var UF_UI = load("res://Scenes/Game/Assets/UI/Roundstart_UI/underground_forest_ui.tscn")
#@onready var WW_UI = load("res://Scenes/Game/Assets/UI/Roundstart_UI/wishing_well_ui.tscn")
#@onready var DP_UI = load("res://Scenes/Game/Assets/UI/Roundstart_UI/Sacrefice_UI.tscn")
#@onready var SW_UI = load("res://Scenes/Game/Assets/UI/Roundstart_UI/slumbering_wyrm_ui.tscn")
#@onready var SC_UI = load("res://Scenes/Game/Assets/UI/Roundstart_UI/smart_creature_ui.tscn")

@onready var Card = load("res://Scenes/Game/Assets/UI/Roundstart_UI/Roundstart_Card.tscn")


signal set_room_name(room_name:String)
signal window_resoult

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	window_resoult.connect(get_parent().get_parent().get_parent()._roundstart_effect_response)
	pass # Replace with function body.


func OpenUi(element,element_name):
	var inst_element = element.instantiate()
	#print("instantiated")
	%Window_collector.add_child(inst_element)
	set_room_name.connect(get_child(0).get_child(3).get_child(get_child(0).get_child(2).get_child_count()-1).get_child(0)._get_room_name)
	set_room_name.emit(element_name)
	#print("added")


func _open_roundstart_UI_elements(UI_element:Array[Dictionary]):
	#print("Got_emmit")
	for element in UI_element:
		if element.UI == false:
			var btn = Button.new()
			btn.text = element.Name+": "+element.Message
			btn.alignment = HORIZONTAL_ALIGNMENT_LEFT
			%Message_collector.add_child(btn)
		else:
			var instCard = Card.instantiate()
			instCard.get_child(0).text = element.Name
			instCard.get_child(1).text = element.Message
			%Window_collector.add_child(instCard)
			
			#match element.Name:
			#	"UNDERGROUND_FOREST":
			#		OpenUi(UF_UI,"UNDERGROUND_FOREST")
			#	"WISHING_WELL": 
			#		OpenUi(WW_UI,"WISHING_WELL")
			#	"DEMON_PORAL":
			#		OpenUi(DP_UI,"DEMON_PORAL")
			#	"SLUMBERING_WYRM":
			#		OpenUi(SW_UI,"SLUMBERING_WYRM")
			#	"SMART_CREATURE":
			#		OpenUi(SC_UI,"SMART_CREATURE")
			


func _on_button_pressed() -> void:
	print(str(%Window_collector.get_child_count()))
	if %Window_collector.get_child_count() == 0:
		window_resoult.emit({"Name":"END","Response":true})
		for child in get_parent().get_children():
			child.queue_free()
			
