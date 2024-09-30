extends Enemy
class_name Bread

const SPEED = 100
var stepSide = false
var target = Vector2.ZERO
var walkDist = 200
var waitTimer = 3
var maxWait = 5
var minWait = 2
var flipTimerMax = 0.3
var flipTimer = 0
var attack = 0
var heal_amount = 0.5
var heal_interval = 3.0
var heal_timer = 0

var healLines = []
var healLineFadeRate = 3
var healLineWidth = 30

@onready var healSound = $AudioStreamPlayer2D 
# reference to the player
var player

func _ready():
	player = get_parent().get_node("Player")
	label = "bread"
	sprite = $Sprites
	
	# overrides
	maxHealth = 3
	health = maxHealth

func _process(delta):
	super._process(delta)
	
	queue_redraw()
	for each in healLines:
		each[1] -= healLineFadeRate*delta
	
	if player:
		# Set target to player's position
		target = player.position
		var direction = (target - position).normalized() * SPEED

		flipTimer -= delta
		if flipTimer <= 0:
			stepSide = !stepSide
			flipTimer = flipTimerMax

		if (position - target).length() > 300:
			if stepSide:
				$Sprites/Flat.visible = false
				$Sprites/Squish.visible = true
			else:
				$Sprites/Flat.visible = true
				$Sprites/Squish.visible = false
				if direction.x < 0:
					scale.x = 0.3
				elif direction.x > 0:
					scale.x = -0.3

				if (direction * delta).length() > (target - position).length():
					move_and_collide(target - position)
				else:
					move_and_collide(direction * delta)
		else:
			$Sprites/Flat.visible = true
			$Sprites/Squish.visible = false
	
	# heal nearby enemies
	heal_timer += delta
	if heal_timer >= heal_interval:
		heal_nearby_enemies()
		heal_timer = 0

func _draw() -> void:
	var i = 0
	while i < len(healLines):
		if healLines[i][1] > 0:
			var alpha = 1-cos(PI*healLines[i][1]/2)
			draw_line(Vector2.ZERO, to_local(healLines[i][0].global_position), Color(0,1,0,alpha), healLineWidth)
		else:
			healLines.remove_at(i)
			i -= 1
		i += 1

func _physics_process(delta):
	attack -= delta

func heal_nearby_enemies():
	var bodies = $Area2D.get_overlapping_bodies()
	var shouldSound = false
	for body in bodies:
		if body is Enemy and body != self and !(body is Bread):
			shouldSound = true
			body.heal(heal_amount)
			healLines.append([body,1])
			#print("Healing enemy:", body.name, "by", heal_amount, "Current health:", body.health)
	if shouldSound:
		healSound.play()
func get_label():
	return label
