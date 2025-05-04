extends Node

var movement : Vector2 = Vector2(0,0)
var speed : float = 400
var mouse_wheel_pos = 5

var color_speed = 0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var cameraPos = %Camera2D.position
	var borderPosTL = %RoomBorder.position
	var borderPosBR = %RoomBorder.position + %RoomBorder.size

	if (cameraPos[0]>borderPosTL[0] && cameraPos[1]>borderPosTL[1]) && (cameraPos[0]<borderPosBR[0] && cameraPos[1]<borderPosBR[1]):
		$".".position += movement * delta
	else:
		if cameraPos[0]<borderPosTL[0]:
			$".".position = Vector2(borderPosTL[0]+1,$".".position[1])
		elif cameraPos[1]<borderPosTL[1]:
			$".".position = Vector2($".".position[0],borderPosTL[1]+1)
		elif cameraPos[0]>borderPosBR[0]:
			$".".position = Vector2(borderPosBR[0]-1,$".".position[1])
		elif cameraPos[1]>borderPosBR[1]:
			$".".position = Vector2($".".position[0],borderPosBR[1]-1)
		

	
	%DarkScreen.color += color_speed * Color(0,0,0,0.01) * delta * 10
	%GameMusic.volume_db -= float(color_speed)/14
	#print(%DarkScreen.color[3])
	if %DarkScreen.color[3] >= 1.2:
		get_tree().change_scene_to_file("res://Scenes/MainMenu/main_menu.tscn")

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		color_speed = 6
	if event.is_action_released("ui_cancel"):
		color_speed = 0
		%DarkScreen.color = Color(0,0,0,0)
		%GameMusic.volume_db = -10
	
	if event.is_action_pressed("keyboard_up"):
		movement = Vector2(movement[0],-speed)
	if event.is_action_released("keyboard_up"):
		movement = Vector2(movement[0],0)
		
	if event.is_action_pressed("keyboard_right"):
		movement = Vector2(speed,movement[1])
	if event.is_action_released("keyboard_right"):
		movement = Vector2(0,movement[1])
		
	if event.is_action_pressed("keyboard_bottom"):
		movement = Vector2(movement[0],speed)
	if event.is_action_released("keyboard_bottom"):
		movement = Vector2(movement[0],0)
		
	if event.is_action_pressed("keyboard_left"):
		movement = Vector2(-speed,movement[1])
	if event.is_action_released("keyboard_left"):
		movement = Vector2(0,movement[1])
		
	if event.is_action("mouse_wheel_up"):
		if $".".zoom[0] <= 2.5:
			$".".zoom += Vector2(0.02,0.02)
			if speed >= 300:
				speed -= 50
				#print("MVP: "+str(mouse_wheel_pos))
	
	if event.is_action("mouse_wheel_down"):
		if $".".zoom[0] >= 0.8:
			$".".zoom -= Vector2(0.02,0.02)
			if speed <= 800:
				speed += 50
				#print("MVP: "+str(mouse_wheel_pos))
	
	
