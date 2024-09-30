extends Sprite2D
class_name Heal_Indicator

var speed = 100
var lifetime = 1
var life_counter = 0

func _ready() -> void:
	top_level = true

func _process(delta: float) -> void:
	if life_counter < lifetime:
		life_counter += delta
		modulate = Color(1,1,1,cos(PI*(life_counter/lifetime)/2))
		position.y -= speed*delta
	else:
		queue_free()
