extends Enemy
class_name Shrimp

const SPEED = 500
const INITIAL_MOVE_TIME = 2
const CHANGE_DIRECTION_TIME = 1

var stepSide = false
var direction = Vector2(0, -1) 
var walkDist = 200
var waitTimer = 3
var maxWait = 5
var minWait = 2
var flipTimerMax = 0.1
var flipTimer = 0
var changeDirectionTimer = CHANGE_DIRECTION_TIME
var initialMoveTimer = INITIAL_MOVE_TIME
var hasSwitchedDirection = false

# reference to the player
var player

func _ready():
	player = get_parent().get_node("Player")
	label = "shrimp"
	sprite = $AnimatedSprite2D
	
	# overrides
	maxHealth = 3
	health = maxHealth

func _process(delta):
	super._process(delta)
	if player:
		# check if the shrimp can start moving randomly
		if not hasSwitchedDirection:
			initialMoveTimer -= delta
			if initialMoveTimer <= 0:
				hasSwitchedDirection = true 
				set_random_direction()
		else:
			changeDirectionTimer -= delta
			if changeDirectionTimer <= 0:
				set_random_direction()  # change direction randomly
				changeDirectionTimer = CHANGE_DIRECTION_TIME

		# update the shrimp's position based on the current direction
		move_and_collide(direction * SPEED * delta)

		if direction.x < 0:
			scale.x = 0.3
			$AnimatedSprite2D.rotation_degrees = -10
		else:
			scale.x = -0.3
			$AnimatedSprite2D.rotation_degrees = 10
		
		$AnimatedSprite2D.play("Idle")  
	var bodies = $Area2D.get_overlapping_bodies()
	
func get_label():
	return label

func set_random_direction():
	direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
