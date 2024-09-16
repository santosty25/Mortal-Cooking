extends Sprite2D
class_name Flame

var hasFuel = false
var hasTarget = false
var target = null
var size = 3
var startSize = 3
var sizeSprites = [load("res://art/Effects/Flame_Small.PNG"), load("res://art/Effects/Flame_Medium.PNG"), load("res://art/Effects/Flame_Large.PNG"), load("res://art/Effects/Flame_Largest.PNG")]
var lifetime = randf()+1
var lifetimeMax = lifetime
var terrainLifeMult = 10
var entityLifeMult = 5
var damage = 1
var damageTimerMax = 1
var damageTimer = 0

var motion = Vector2.ZERO

func _ready() -> void:
	top_level = true
	scale += Vector2(randf(),randf())*0.1
	if randf() < 0.5:
		scale.x *= -1

func _process(delta: float) -> void:
	texture = sizeSprites[size]
	if !hasFuel:
		lifetime -= delta
		size = floor((startSize+1)*lifetime/lifetimeMax)
	if (lifetime <= 0):
		queue_free()
	if motion.length() > 0:
		global_position = global_position + motion*delta
		
	if hasTarget && target is Entity:
		position = target.position
		if damageTimer > damageTimerMax:
			target.take_damage(damage, "fire")
			damageTimer = 0
		else:
			damageTimer += delta
			
func set_start_size(size:int):
	self.startSize = size

func set_motion(motion: Vector2):
	self.motion = motion

func set_target(target: Node2D):
	hasTarget = true
	self.target = target
	if target is Entity:
		lifetime *= entityLifeMult
		lifetimeMax *= entityLifeMult
	elif target is Terrain:
		lifetime *= terrainLifeMult
		lifetimeMax *= terrainLifeMult
	motion = Vector2.ZERO
