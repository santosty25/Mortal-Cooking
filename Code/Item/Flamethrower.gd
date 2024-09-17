extends Ranged_Weapon
class_name Flamethrower

@onready var flame = load("res://Scenes/Effects/Flame.tscn")
var flameTimer = 0
var flameTimerMax = 0.05
var flameSpeed = 400
var flameCount = 5

var isFiring = false

func _process(delta: float) -> void:
	if (isFiring):
		if flameTimer >= flameTimerMax:
			for i in range(flameCount):
				var newFlame = flame.instantiate()
				add_child(newFlame)
				newFlame.global_position = $Emission_Point.global_position
				var motion = Vector2(1,0).rotated(global_rotation)
				motion += Vector2(randf()*2-1, randf()*2-1).normalized()*randf()/2
				newFlame.set_motion(motion*flameSpeed)
				flameTimer = 0
		else:
			flameTimer += delta
		isFiring = false

func fire():
	isFiring = true
	for body in $Hurtbox.get_overlapping_bodies():
		if body is Entity || body is Terrain:
			var newFlame = flame.instantiate()
			body.add_child(newFlame)
			body.ignite(newFlame)
