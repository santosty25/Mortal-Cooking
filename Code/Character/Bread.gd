extends Enemy
class_name Bread

const SPEED = 100
var stepSide = false
var target = Vector2.ZERO
var walkDist = 200
var waitTimer = 3
var maxWait = 5
var minWait = 2
var flipTimerMax = 0.1
var flipTimer = 0
var attack = 0
var heal_amount = 0.5
var heal_interval = 3.0
var heal_timer = 0

@onready var healSound = $AudioStreamPlayer2D 
# reference to the player
var player

func _ready():
	player = get_parent().get_node("Player")
	label = "bread"
	sprite = $AnimatedSprite2D
	
	# overrides
	maxHealth = 3
	health = maxHealth

func _process(delta):
	super._process(delta)
	if player:
		# Set target to player's position
		target = player.position
		var direction = (target - position).normalized() * SPEED

		flipTimer -= delta
		if flipTimer <= 0:
			stepSide = !stepSide
			flipTimer = flipTimerMax

		if (position - target).length() > 0.1:
			if stepSide:
				$AnimatedSprite2D.rotation_degrees = -10
			else:
				$AnimatedSprite2D.rotation_degrees = 10

			if direction.x < 0:
				scale.x = 0.3
			elif direction.x > 0:
				scale.x = -0.3

			if (direction * delta).length() > (target - position).length():
				move_and_collide(target - position)
			else:
				move_and_collide(direction * delta)
		else:
			$AnimatedSprite2D.rotation = 0
	
	# heal nearby enemies
	heal_timer += delta
	if heal_timer >= heal_interval:
		heal_nearby_enemies()
		heal_timer = 0

func _physics_process(delta):
	attack -= delta
	if attack < 0.2:
		$AnimatedSprite2D.play("Idle")
		# player.take_damage(1, "attack")
		$HitEffect.show()
	if attack < 0.1:
		$HitEffect.hide()

func heal_nearby_enemies():
	var bodies = $Area2D.get_overlapping_bodies()
	healSound.play()
	for body in bodies:
		if body is Enemy and body != self:
			body.heal(heal_amount)
			print("Healing enemy:", body.name, "by", heal_amount, "Current health:", body.health)
	
func get_label():
	return label
