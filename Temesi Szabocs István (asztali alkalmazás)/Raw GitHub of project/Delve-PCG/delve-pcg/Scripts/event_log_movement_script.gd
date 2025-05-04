extends CanvasLayer

var log_active = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_pressed() -> void:
	if log_active == false:
		%Log_BG.position[0] -= %Log_BG.size[0]
		$Button.position[0] -= %Log_BG.size[0]
		log_active = true
	else:
		%Log_BG.position[0] += %Log_BG.size[0]
		$Button.position[0] += %Log_BG.size[0]
		log_active = false
