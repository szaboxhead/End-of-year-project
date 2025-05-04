extends Button

signal filter_pressed

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	filter_pressed.connect(get_parent().get_parent().get_parent().get_parent()._on_filter_pressed)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_pressed():
	filter_pressed.emit($".".text)
