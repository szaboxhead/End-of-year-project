extends Window

static var SCROLL_SPEED = 50
var min_position

# Called when the node enters the scene tree for the first time.
func _ready():
	min_position = %Collector.position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _input(event: InputEvent) -> void:
	if event.is_action("mouse_wheel_up"):
		%Collector.position -= Vector2(SCROLL_SPEED,0)
		#print(%Collector.position)
	elif event.is_action("mouse_wheel_down"):
		if %Collector.position[0] - SCROLL_SPEED < min_position[0]:
			%Collector.position += Vector2(SCROLL_SPEED,0)
			#print(%Collector.position)
