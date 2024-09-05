extends CharacterBody2D
class_name Apple

const SPEED = 200
var stepSide = false
var target = Vector2.ZERO
var walkDist = 200
var waitTimer = 3
var maxWait = 5
var minWait = 2
var flipTimerMax = 0.1
var flipTimer = 0
var attack = 0

var health = 3

var drop = load("res://Scenes/Enemy_Drop.tscn")

func _ready():
	target = getRandomWalk()

func _process(delta):
	var direction = (target-position)
	direction = direction.normalized()
	direction *= SPEED
	
	flipTimer -= delta
	if flipTimer <= 0:
		stepSide = !stepSide
		flipTimer = flipTimerMax
	
	if (position-target).length() > 0.1:
		if (stepSide):
			$AnimatedSprite2D.rotation_degrees = -10
		else:
			$AnimatedSprite2D.rotation_degrees = 10
			
		if (direction.x < 0):
			scale.x = 0.3
		elif direction.x > 0:
			scale.x = -0.3
			
		if (direction*delta).length() > (target-position).length():
			move_and_collide(target-position)
		else:
			move_and_collide(direction*delta)
	else:
		$AnimatedSprite2D.rotation = 0
		if waitTimer <= 0:
			target = getRandomWalk()
			waitTimer = minWait+randf()*(maxWait-minWait)
		else:
			waitTimer -= delta
			
func _physics_process(delta):
	attack -= delta
	if attack < 0.2:
		$AnimatedSprite2D.play("Idle")
		$HitEffect.show()
	if attack < 0.1:
		$HitEffect.hide()

func getRandomWalk():
	var newTarget = Vector2(randf()*2-1,randf()*2-1)
	newTarget = newTarget.normalized()*walkDist+position
	return newTarget

func _on_area_2d_body_entered(body):
	$AnimatedSprite2D.play("Windup")
	attack = 0.3

func take_damage(amount, damageLabel):
	health -= amount
	if (health < 0):
		var drop_node = drop.instantiate()
		drop_node.position = position
		drop_node.label = ["apple", damageLabel]
		$"..".add_child(drop_node)
		# here we can set what teh drop should be
		queue_free()
