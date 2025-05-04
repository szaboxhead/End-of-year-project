extends Node

class_name Unit

var Coordinate : Vector2 
var Hostile : String = "No"
var Name : String = "none"
var Origin : Room = null
var Ability : String = ""
var Str : int = 5
var Number : int = 1
var Ranged : bool = false
var Effects : Array[Dictionary] #origin,value,desc

var Placed : bool = false
var Moved : bool = false
