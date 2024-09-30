extends CanvasGroup
class_name Afterimage
	
var lifetime = 0.3
var life_counter = 0
var hue = 0 # vary between 0 and 1
var attack = false

func _ready() -> void:
	top_level = true

func _process(delta: float) -> void:
	if life_counter < lifetime:
		life_counter += delta
		var frac = (life_counter/lifetime)
		# hsv 170 to 70
		if attack:
			modulate = Color(1,0,0,cos(PI*frac/2))
		else:
			modulate = Color.from_hsv((70+hue*100)/360,1,1,cos(PI*frac/2))
	else:
		queue_free()
