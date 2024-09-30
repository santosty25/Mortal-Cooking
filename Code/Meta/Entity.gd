extends CharacterBody2D
class_name Entity

var maxHealth: float = 1
var health: float = 1
var burnCount = 0
var burnCountMax = 5
var burnDelay = 0
var burnDelayMax = 1
var sprite = null
var isColored = false
var colorTimeMax = 0.2
var colorTimer = 0

var healIndicator = load("res://Scenes/Effects/Heal_Indicator.tscn")

func _process(delta: float) -> void:
	if burnDelay > 0:
		burnDelay -= delta
	if colorTimer > colorTimeMax && isColored:
		sprite.modulate = Color(1,1,1)
		isColored = false
	else:
		colorTimer += delta
		
# default damage function
func take_damage(amount: float, damageLabel: String):
	health -= amount
	if (health <= 0):
		queue_free()
	if sprite:
		indicate_damage()
		
func heal(amount):
	if health < maxHealth:
		health += amount
	if health > maxHealth:
		health = maxHealth
	if sprite:
		indicate_healing()
		
func indicate_damage():
	sprite.modulate = Color(1,0.5,0.5)
	isColored = true
	colorTimer = 0
	
func indicate_healing():
	sprite.modulate = Color(0,1,0)
	for i in range(3):
		var heal_node = healIndicator.instantiate()
		heal_node.global_position = global_position + Vector2(randf()-0.5,randf()-0.5).normalized()*randf()*100
		$"..".add_child(heal_node)
	isColored = true
	colorTimer = 0

func ignite(flame: Flame):
	if burnCount > burnCountMax || burnDelay > 0:
		flame.queue_free()
		return
	else:
		burnDelay = burnDelayMax
		flame.set_target(self)
		flame.position = position
