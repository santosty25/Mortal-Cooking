extends Enemy
class_name Shrimp

const SPEED = 500
const INITIAL_MOVE_TIME = 2
const CHANGE_DIRECTION_TIME = 1

var stepSide = false
var direction = Vector2(0, -1) 
var bounceTimerMax = 0.1
var bounceTimer = 0
var bounceHeight = 50
var spriteAnchor = Vector2.ZERO
var bounce = false
var changeDirectionTimer = CHANGE_DIRECTION_TIME
var initialMoveTimer = INITIAL_MOVE_TIME
var hasSwitchedDirection = false

# reference to the player
var player

func _ready():
	player = get_parent().get_node("Player")
	label = "shrimp"
	sprite = $Sprite
	spriteAnchor = sprite.position
	
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
		
		if (bounceTimer < bounceTimerMax) && direction.length() > 0:
			bounceTimer += delta
			bounce = !bounce
			if bounce:
				sprite.position = spriteAnchor+Vector2(0,-bounceHeight)
			else:
				sprite.position = spriteAnchor
		else:
			bounceTimer = 0

		if direction.x < 0:
			scale.x = abs(scale.x)
			sprite.rotation_degrees = -10
		else:
			scale.x = -abs(scale.x)
			sprite.rotation_degrees = 10
	
func get_label():
	return label

func set_random_direction():
	direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
