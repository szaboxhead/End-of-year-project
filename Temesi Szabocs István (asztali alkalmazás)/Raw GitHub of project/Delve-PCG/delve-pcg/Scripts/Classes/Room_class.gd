extends Node

class_name Room

var Coordinate : Vector2 = Vector2(0,0)
var Buildable : bool = false
var Pointer
var Status : Array[String] = []
var Status_placed : bool = false
var Name : String = "none"
var Room_id : String
var Hidden : bool = true
var Units :Array[Unit] = []
var Can_recruit = false

var trap : String = "none"
var trap_lvl : int = 0
var trap_temp : bool = false

var wall : Array[String] = ["none","none","none","none"]
var wall_lvl : Array[int] = [0,0,0,0]
