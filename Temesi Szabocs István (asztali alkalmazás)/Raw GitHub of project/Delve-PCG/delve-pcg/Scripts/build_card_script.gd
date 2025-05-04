extends Node2D

@onready var room_placement_sript = load("res://Scripts/room_placement.gd")

signal build_room_resp

var room_price

func _room_build_request(roomData:Dictionary,can_buil:bool,storehouse:bool):
	%RoomTittle.text = roomData.Name
	
	$ColorRect/Sprite2D.set_region_rect(room_placement_sript.roomImage(roomData.Name))
	
	var price = roomData.Cost.split('_')
	if !storehouse:
		room_price = Vector2(int(price[0]),int(price[1]))
	else:
		room_price = Vector2(int(price[0]),floor(int(price[1])/2))
	if !can_buil:
		$ColorRect.color = Color(0.9,0.5,0.5)
		$ColorRect/BuildButton.disabled = true
	%Price_TradeGood.text = str(room_price[0])
	%Price_Resource.text = str(room_price[1])
	%RoomQuote.text = ('"'+roomData.Quote+'"')
	%RoomEffect.text = roomData.Description


func _on_build_button_pressed():
	build_room_resp.connect(get_parent().get_parent().get_parent()._build_room)
	build_room_resp.emit(%RoomTittle.text,room_price)
