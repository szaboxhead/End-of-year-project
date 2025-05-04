extends Node2D

var UnitName:String
var UnitSTR:int
var UnitPrice:Vector2

signal recruit_unit(Name:String,Strength:int,price:Vector2)

func _unit_recruit_request(Tittle:String,Price:Vector2,Effect:String,STR:int):
	UnitName = Tittle
	UnitSTR = STR
	UnitPrice = Price
	#print("REQ recieved: "+Tittle)
	%UnitTittle.text=Tittle
	%Price_TradeGood.text=str(Price[0])
	%Price_Resource.text=str(Price[1])
	%UnitEffect.text=Effect
	%Unit_STR.text=str(STR)+" STR"


func _on_recruit_button_pressed() -> void:
	recruit_unit.connect(get_parent().get_parent().get_parent()._recruit_unit)
	recruit_unit.emit(UnitName,UnitSTR,UnitPrice)
