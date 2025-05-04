extends Node

static func display_currency_changed_at(collector, accesory,Coordinate:Vector2,resource:int = 0,trade_good:int = 0):
	var inst_accesory = accesory.instantiate()
	if resource != 0:
		inst_accesory.text = "+"+str(resource)+"R"
		inst_accesory.position = Coordinate
		collector.add_child(inst_accesory)
	elif trade_good != 0:
		inst_accesory.text = "+"+str(trade_good)+"TG"
		inst_accesory.position = Coordinate
		collector.add_child(inst_accesory)


	
