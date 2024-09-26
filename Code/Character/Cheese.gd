extends Enemy
class_name Cheese

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

# reference to the player
var player

var meltedCheese = preload("res://Scenes/Effects/MeltedCheese.tscn")

# timer for dropping melted cheese
var drop_timer = 5.0
var drop_interval = 5.0

func _ready():
	player = get_parent().get_node("Player")
	label = "cheese"
	sprite = $AnimatedSprite2D
	
	# overrides
	maxHealth = 5
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
	
	# Time for dropping cheese
	drop_timer -= delta
	if drop_timer <= 0:
		drop_melted_cheese()
		drop_timer = drop_interval # reset timer
		
	var bodies = $Area2D.get_overlapping_bodies()

func _physics_process(delta):
	attack -= delta
	if attack < 0.2:
		$AnimatedSprite2D.play("Idle")
		# player.take_damage(1, "attack")
		$HitEffect.show()
	if attack < 0.1:
		$HitEffect.hide()

func _on_area_2d_body_entered(body):
	$AnimatedSprite2D.play("Windup")
	if body is Player:
		body.take_damage(1, "attack")
	attack = 0.3

func drop_melted_cheese():
	var melted_cheese = meltedCheese.instantiate()
	
	# add melted cheese to the scene
	melted_cheese.position = position
	get_parent().add_child(melted_cheese)
	
func get_label():
	return label
