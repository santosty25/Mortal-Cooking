extends Enemy
class_name Tomato

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
var explosionRadius = 100  # Distance at which the explosion triggers
var explosionDamage = 0.5  # Damage is half the player's health
var exploded = false  # Flag to check if Tomato has already exploded
var explosionTime = 3.0  # Time in seconds before the Tomato explodes
var explosionTimer = 0.0  # Countdown timer
var soundPlaying = false  # Flag to track if the sound is playing

# Reference to the player
var player
@onready var creeper = $CreeperSound
@onready var explosionSound = $ExplosionSound

func _ready():
	player = get_parent().get_node("Player")
	label = "tomato"
	sprite = $AnimatedSprite2D
	explosionTimer = explosionTime  # Initialize the timer
	
	# Overrides
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
		# Move Tomato towards player
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
		
		# Explosion countdown when close to player
		if position.distance_to(player.position) < explosionRadius:
			countdown_explosion(delta)

	var bodies = $Area2D.get_overlapping_bodies()

func countdown_explosion(delta):
	explosionTimer -= delta  # Reduce timer by delta

	# Start playing the sound if not already playing
	if not soundPlaying:
		creeper.play()
		soundPlaying = true

	if explosionTimer <= 0.0:
		explode()

func explode():
	if exploded:
		return  # Prevent multiple explosions
	
	print("Explosion triggered")  # Debug print to ensure this is called
	
	if exploded:
		return
	
	print("Explosion triggered")
	
	exploded = true
	
	# Ensure the player is in the explosion range
	if position.distance_to(player.position) <= explosionRadius:
		print("Player within explosion range")  # Another debug print
		if player.has_method("take_damage"):
			player.take_damage(player.maxHealth * explosionDamage, "explosion")
		else:
			player.health -= player.maxHealth * explosionDamage
		
		creeper.play()
	
	queue_free()  # Remove the Tomato after explosion
	
# Override the take_damage() function from the parent
func take_damage(amount: float, damageLabel: String):
	# Call the parent function to handle damage reduction and health check
	super.take_damage(amount, damageLabel)

	# Reset the bomb timer when Tomato gets hit
	explosionTimer = explosionTime  # Reset the explosion countdown
	soundPlaying = false  # Reset the sound flag so it can start again
	print("Tomato hit! Timer reset to ", explosionTime, " seconds.")

func _physics_process(delta):
	attack -= delta
	if attack < 0.2:
		$AnimatedSprite2D.play("Idle")
		$HitEffect.show()
	if attack < 0.1:
		$HitEffect.hide()

func get_label():
	return label
