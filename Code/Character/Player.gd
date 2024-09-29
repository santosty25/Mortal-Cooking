extends Entity
class_name Player

signal healthChanged 

@export var player: Player

#sound effects
@onready var knifeSwing = $SFX/knifeSwing
@onready var running = $SFX/running
@onready var cashGained = $SFX/cashGained
@onready var takeDamage = $SFX/takeDamage

# Node references, reduces work if scene heirarchy changed
@onready var animator = $Animator
@onready var interaction = $Interaction
#@onready var hitEffect = $HitEffect
@onready var attack = $Attack
@onready var main = $".."
@onready var dashCooldown = $Helpers/DashCooldown
@onready var healCooldown = $Helpers/HealCooldown

# input handling
var canAttack = true
var canDash = true
var dashTime = 0.06
var dashTimer = 0
const speed = 500.0
const attackSlowdown = 2
var canMove = true

# other important variables
var heldItem = null
var healRate = 0

func _ready() -> void:
	# overrides
	maxHealth = 10
	health = maxHealth
	sprite = $Animator

func _process(delta):
	super._process(delta)
	queue_redraw()
	
	var direction = Vector2.ZERO
	var multiplier = 1.0
		
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
		dashCooldown.start()
	if Input.is_action_pressed("Attack_Main"):
		if (heldItem is Ranged_Weapon):
			heldItem.fire()
		if (heldItem is Melee_Weapon):
			heldItem.swing()
		multiplier /= attackSlowdown
	if Input.is_action_just_pressed("Interact"):
		interact()
			
	#if heldItem:
	#	heldItem.position = position+Vector2(0,-200)
		
	if (dashTimer > 0):
		animator.spawn_afterimage()
		multiplier = 20
		dashTimer -= delta
		
	if direction.length() > 1:
		direction = direction.normalized()
		
	if direction.length() > 0:
		animator.set_animation("walk")
	else:
		animator.set_animation("idle")
		
	if animator.aiming || animator.swing_attacking:
		animator.face(get_global_mouse_position()-position)
	else:
		animator.face(direction)
		
	if canMove:
		velocity = direction*speed*multiplier
		move_and_slide()
		#move_and_collide(direction*speed*delta*multiplier)
		
	if healCooldown.time_left == 0 && health < maxHealth:
		health += healRate*delta
		if health > maxHealth:
			health = maxHealth
		healthChanged.emit()

#func _draw() -> void:
	#for each in animator.afterimage_list:
	#	#var t: Transform2D = each[1]
	#	print("drawing at: "+str(each[1]))
	#	var img = Image.new()
	#	img.load(each[0])
	#	var texture = ImageTexture.create_from_image(img)
	#	draw_texture(texture, to_global(each[1]), Color(1,1,1))

func _on_dash_cooldown_timeout():
	canDash = true

func freeze():
	canMove = false

func unfreeze():
	canMove = true

func interact():
	var target = null
	var search: Array = interaction.get_overlapping_bodies()
	if heldItem:
		for body in search:
			if body == heldItem:
				continue
			elif body is Plate|| body is Weapon || body is Bin || body is Enemy_Drop:
				if target && (target.global_position-global_position).length() > (body.global_position-global_position).length():
					target = body
				elif !target:
					target = body
			elif body is Serving_Location && heldItem is Plate:
				target = body
				break; # terrain interactions take precedence and there is only one serving location
		if target:
			if target is Plate && heldItem is Enemy_Drop:
				target.add_item(heldItem, heldItem.get_label())
				remove_item(heldItem)
			elif target is Serving_Location && heldItem is Plate:
				if main.serve(heldItem):
					remove_item(heldItem)
					cashGained.play()
				else:
					drop_item(heldItem)
			elif target is Weapon:
				drop_item(heldItem)
				equip_item(target)
			elif target is Bin:
				target.spawn_enemy()
			else:
				drop_item(heldItem)
		else:
			drop_item(heldItem)
	else:
		for body in search:
			if body == heldItem:
				continue
			elif body is Enemy_Drop || body is Plate || body is Weapon:
				if target && (target.global_position-global_position).length() > (body.global_position-global_position).length():
					target = body
				elif !target:
					target = body
			elif body is Bin && (not target || not (target is Enemy_Drop || target is Plate)): # less important than plates or drops
				if target && (target.global_position-global_position).length() > (body.global_position-global_position).length():
					target = body
				elif !target:
					target = body
		if target is Bin:
			target.spawn_enemy()
		elif target:
			equip_item(target)
			
func equip_item(item: Node2D):
	animator.equip_item(item)
	heldItem = item
	
func get_held_item():
	return heldItem

func drop_item(item: Node2D):
	if animator.get_direction():
		heldItem.global_position = global_position
	else:
		heldItem.global_position = global_position
	heldItem = null
	animator.drop_item(item)

func remove_item(item: Node2D):
	heldItem = null
	animator.drop_item(item)

func take_damage(amount: float, damageLabel:String) -> void:
	if dashTimer > 0:
		return
	health -= amount
	healthChanged.emit()
	indicate_damage()
	takeDamage.play()
	healCooldown.start(healCooldown.wait_time)
	if health <= 0:
		queue_free()
		get_tree().change_scene_to_file("res://Scenes/UI/GameOver.tscn")

func heal(amount):
	super.heal(amount)
	healthChanged.emit()
