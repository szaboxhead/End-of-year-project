extends Label

const SPEED = 0.2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position[1] -= SPEED
	set("theme_override_colors/font_color",get("theme_override_colors/font_color")-Color(0,0,0,SPEED/7))
	set("theme_override_colors/font_outline_color",get("theme_override_colors/font_outline_color")-Color(0,0,0,SPEED/7))
	if get("theme_override_colors/font_color")[3] < 0:
		queue_free()
