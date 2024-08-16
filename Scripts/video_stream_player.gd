extends VideoStreamPlayer


@onready var sprite_2d = $Sprite2D


func _on_finished():
	sprite_2d.show()
