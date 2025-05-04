extends Node2D

@onready var this = $"."
var current_room
signal room_clicked(room)
signal room_clicked_right(room)
signal move_request()


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if this.get_parent().name == "RoomCollector":
		room_clicked.connect(get_parent().get_parent()._on_room_clicked)
		room_clicked_right.connect(get_parent().get_parent()._on_room_clicked_right)
		move_request.connect(get_parent().get_parent()._move_friendly_unit)
		


func _on_area_2d_mouse_entered() -> void:
	current_room = this


func _on_area_2d_mouse_exited() -> void:
	current_room = null


func _on_area_2d_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.get_button_index() == 1 and event.is_pressed() == true:
			#print("cliclked on "+ str(current_room))
			room_clicked.emit(current_room)
		elif event.get_button_index() == 2 and event.is_pressed() == true:
			#print("right cliclked on "+ str(current_room))
			room_clicked_right.emit(current_room)

func _move_friendly_unit(unit_info) -> void:
	move_request.emit({"UnitId":unit_info.ID,"Single":unit_info.Single,"FromRoomPoiner":this})
