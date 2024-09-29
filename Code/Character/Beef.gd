extends Enemy
class_name Beef

const SPEED = 100

var jumpDelay = 2
var jumpDelayMin = 1.5
var jumpDelayMax = 2.5
var jumpTimer = 0
var jumpDist = 400
var jumpTime = 1
var jumpTracker = 0
var jumpHeight = 300
var isJumping = false
var jumpStart = Vector2.ZERO
var jumpEnd = Vector2.ZERO
var squishTime = 0.2

@onready var idle = $Sprites/Idle
@onready var squish = $Sprites/Squish
@onready var jump = $Sprites/Jump
@onready var shadow = $Sprites/Shadow

# reference to the player
var player

func _ready():
	player = get_parent().get_node("Player")
	label = "beef"
	sprite = $Sprites
	
	jumpDelay = randf_range(0.5,1.5)
	jumpTimer = jumpDelay
	
	# overrides
	maxHealth = 3
	health = maxHealth

func _process(delta):
	super._process(delta)
	if player:
		if (jumpTimer > 0) && !isJumping:
			jumpTimer -= delta
			shadow.visible = false
			if jumpTimer < squishTime || jumpDelay-jumpTimer < squishTime:
				squish.visible = true
				idle.visible = false
			else:
				squish.visible = false
				idle.visible = true
		elif isJumping:
			if jumpTracker < jumpTime:
				jumpTracker += delta
				var frac = (jumpTracker/jumpTime)
				var y_pos = sin(frac*PI)*jumpHeight
				var x_pos = frac*(jumpEnd-jumpStart)+jumpStart
				position = x_pos+Vector2(0,-y_pos)
				var scl = 1-sin(frac*PI)*0.3
				shadow.scale = Vector2(scl,scl)
				shadow.global_position = x_pos
			else:
				check_damage()
				isJumping = false
				jump.visible = false
				position = jumpEnd
		else:
			shadow.visible = true
			squish.visible = false
			idle.visible = false
			jump.visible = true
			jumpDelay = randf_range(jumpDelayMin, jumpDelayMax)
			jumpTimer = jumpDelay
			isJumping = true
			run_jump()

func get_label():
	return label

func run_jump():
	jumpStart = position
	var targetPos = (player.global_position-global_position)
	if targetPos.length() > jumpDist:
		targetPos = targetPos.normalized()*jumpDist
	jumpEnd = position+targetPos
	jumpTracker = 0

func check_damage():
	for body in $Area2D.get_overlapping_bodies():
		if body is Player:
			body.take_damage(2,"true")
