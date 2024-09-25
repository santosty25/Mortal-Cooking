extends CharacterBody2D
class_name Entity

var maxHealth: float = 1
var health: float = 1
var burnCount = 0
var burnCountMax = 5
var burnDelay = 0
var burnDelayMax = 1
var sprite = null
var isRed = false
var redTimeMax = 0.2
var redTimer = 0

func _process(delta: float) -> void:
	if burnDelay > 0:
		burnDelay -= delta
	if redTimer > redTimeMax && isRed:
		sprite.modulate = Color(1,1,1)
		isRed = false
	else:
		redTimer += delta
		
# default damage function
func take_damage(amount: float, damageLabel: String):
	health -= amount
	if (health <= 0):
		queue_free()
	if sprite:
		indicate_damage()
		
func indicate_damage():
	sprite.modulate = Color(1,0,0)
	isRed = true
	redTimer = 0

func ignite(flame: Flame):
	if burnCount > burnCountMax || burnDelay > 0:
		flame.queue_free()
		return
	else:
		burnDelay = burnDelayMax
		flame.set_target(self)
		flame.position = position
