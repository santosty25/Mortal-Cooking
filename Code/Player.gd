extends CharacterBody2D


const speed = 300.0
var stepSide = false
var walkDist = 200
var waitTimer = 3
var maxWait = 5
var minWait = 2
var flipTimerMax = 0.1
var flipTimer = 0
var canAttack = true
var canDash = true
var dashTime = 0.01
var dashTimer = 0
var flipped = false

var heldItem = null

func _ready() -> void:
	$AnimatedSprite2D.play("Idle")

func _process(delta):
	var direction = Vector2.ZERO
	var multiplier = 1
		
	if Input.is_action_pressed("Move_Up"):
		direction.y -= 1
	if Input.is_action_pressed("Move_Down"):
		direction.y += 1
	if Input.is_action_pressed("Move_Left"):
		direction.x -= 1
	if Input.is_action_pressed("Move_Right"):
		direction.x += 1
	if Input.is_action_pressed("Block"):
		multiplier = 0.3
	if Input.is_action_pressed("Dash") && canDash:
		canDash = false
		dashTimer = dashTime
		$DashCooldown.start()
	if Input.is_action_just_pressed("Attack_Main"):
		canAttack = false
		$AnimatedSprite2D.play("Attack")
		for body in $Attack.get_overlapping_bodies():
			if body is Apple:
				$HitEffect.show()
				body.take_damage(1)
	if Input.is_action_just_pressed("Interact"):
		if heldItem:
			if flipped:
				heldItem.position = position+Vector2(-160,30)
			else:
				heldItem.position = position+Vector2(160,30)
			heldItem = null
		else:
			var closest = null
			for body in $Interaction.get_overlapping_bodies():
				if body != heldItem:
					if closest && (closest.position-position).length() > (body.position-position).length():
						closest = body
					elif !closest:
						closest = body
			if closest:
				heldItem = closest
			
	if heldItem:
		heldItem.position = position+Vector2(0,-200)
		
	if (dashTimer > 0):
		multiplier = 80
		dashTimer -= delta
		
	if direction.length() > 1:
		direction = direction.normalized()
		
	if (direction.length() > 0):
		flipTimer -= delta
		if flipTimer <= 0:
			stepSide = !stepSide
			flipTimer = flipTimerMax
			
		if direction.x > 0 && flipped:
			scale.x *= -1#0.3
			$AnimatedSprite2D.scale = Vector2(1,1)
			flipped = false
		elif direction.x < 0 && not flipped:
			scale.x *= -1#-0.3
			$AnimatedSprite2D.scale = Vector2(-1,-1)
			flipped = true
			
		if (stepSide):
			if flipped:
				$AnimatedSprite2D.rotation_degrees = 175
			else:
				$AnimatedSprite2D.rotation_degrees = -5
		else:
			if flipped:
				$AnimatedSprite2D.rotation_degrees = 185
			else:
				$AnimatedSprite2D.rotation_degrees = 5
	else:
		if flipped:
			$AnimatedSprite2D.rotation_degrees = 180
		else:
			$AnimatedSprite2D.rotation_degrees = 0
		
	move_and_collide(direction*speed*delta*multiplier)

func _on_dash_cooldown_timeout():
	canDash = true

func _on_animated_sprite_2d_animation_finished() -> void:
	if $AnimatedSprite2D.animation == "Idle":
		canAttack = true
	else:
		$AnimatedSprite2D.play("Idle")
		$HitEffect.hide()
