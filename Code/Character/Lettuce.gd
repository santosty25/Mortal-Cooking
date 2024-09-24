extends Enemy
class_name Lettuce

const SPEED = 100
const SHOOT_TIME = 3 # time between each shot

var stepSide = false
var target = Vector2.ZERO
var walkDist = 200
var waitTimer = 3
var maxWait = 5
var minWait = 2
var flipTimerMax = 0.1
var flipTimer = 0
var attack = 0
var shootTimer = SHOOT_TIME # timer for projectile

# reference to the player
var player
var projectile_scene : PackedScene = preload("res://Scenes/Effects/LettuceProjectile.tscn")

func _ready():
	player = get_parent().get_node("Player")
	label = "lettuce"
	
	# overrides
	maxHealth = 1
	health = maxHealth

func _process(delta):
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
				scale.x = abs(scale.x)
			elif direction.x > 0:
				scale.x = -abs(scale.x)

			if (direction * delta).length() > (target - position).length():
				move_and_collide(target - position)
			else:
				move_and_collide(direction * delta)
		else:
			$AnimatedSprite2D.rotation = 0
		
		# shoot projectile
		shootTimer -= delta
		if shootTimer <= 0:
			shoot_at_player()
			shootTimer = SHOOT_TIME

func _physics_process(delta):
	attack -= delta
	if attack < 0.2:
		$AnimatedSprite2D.play("Idle")
		$HitEffect.show()
	if attack < 0.1:
		$HitEffect.hide()

func get_label():
	return label

# shoots a projectile at the player
func shoot_at_player():
	if player:
		# Ensure the projectile_scene is valid and create an instance
		if projectile_scene:
			var projectile = projectile_scene.instantiate()  # Use instantiate() instead of instance()
			get_parent().add_child(projectile)
			
			projectile.position = position
			projectile.direction = (player.position - position).normalized()
