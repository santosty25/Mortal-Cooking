extends CanvasGroup
class_name Animator


# state bools
var flipped = false
var walking = false
var swing_attacking = false
var aiming = false
var holding_item = false
var arm_idle = true

# references
@onready var hand = $Arm_Front/Hand
@onready var player = $".."
@onready var root = $"../.."
@onready var moustache = $"Body/Head/Moustache"
@onready var front_arm = $"Arm_Front"
@onready var back_arm = $"Arm_Back"
@onready var left_leg = $"Leg_L"
@onready var right_leg = $"Leg_R"
@onready var body_group = $"Body"
@onready var head_group = $"Body/Head"
@onready var bgMusic : AudioStreamPlayer = $"../../jazzBackground"

# animation vars
var leg_rotation_max = 45
var leg_direction = 1
var leg_rotation_speed = 500

var arm_rotation_max = 15
var arm_direction = 1
var arm_rotation_speed = 0.5
var arm_rotation_percent = 0
var arm_walking_mult = 2

var body_bounce_max = 15
var body_direction = 1
var body_animate_speed = 0.75
var body_anchor = Vector2.ZERO
var body_running_mult = 5
var body_bounce_percent = 0

var moustache_twitch_timer_max = 5
var moustache_twitch_timer = 0
var moustache_direction = 1
var moustache_twitch_count = 0
var moustache_rotation_max = 5
var moustache_twitch_speed = 100

func _ready() -> void:
	body_anchor = body_group.position

func _process(delta: float) -> void:
	animate_moustache(delta)
	animate_body(delta)
	if (arm_idle):
		animate_arm(delta)
	if walking:
		animate_legs(delta)
	else:
		reset_legs(delta)
		
	var heldItem = player.get_held_item()
	if heldItem:
		if aiming:
			aim(heldItem)
		else:
			hold_item(heldItem)
			
func hold_item(heldItem: Node2D):
	heldItem.global_position = hand.global_position
	heldItem.rotation = front_arm.rotation+PI/2
	if (holding_item):
		set_arm_rotation(true, 90)
			
func aim(heldItem: Node2D):
	var mouse = get_global_mouse_position()
	var pos = front_arm.global_position
	front_arm.rotation = pos.angle_to_point(mouse)-PI/2
	if get_direction():
		front_arm.rotation *= -1
	heldItem.global_position = hand.global_position
	heldItem.rotation = front_arm.rotation+PI/2
	if get_direction():
		var base = front_arm.rotation+PI/2
		if (base < PI/2):
			head_group.rotation = (front_arm.rotation+PI/2)/2
		else:
			head_group.rotation = (front_arm.rotation+PI/2+2*PI)/2
	else:
		head_group.rotation = (front_arm.rotation+PI/2)/2
		
func reset_head():
	head_group.rotation = 0
		
func animate_moustache(delta: float):
	if moustache_twitch_timer < moustache_twitch_timer_max:
		moustache_twitch_timer += delta
	else:
		if moustache_twitch_count < 3:
			if abs(moustache.rotation_degrees) <= moustache_rotation_max:
				moustache.rotation_degrees += moustache_direction*moustache_twitch_speed*delta
			else:
				moustache.rotation_degrees = moustache_rotation_max*moustache_direction
				moustache_direction *= -1
				moustache_twitch_count += 1
		else:
			
			if moustache.rotation_degrees*moustache_direction < 0:
				moustache.rotation_degrees += moustache_direction*moustache_twitch_speed*delta
			else:
				moustache.rotation_degrees = 0
				moustache_twitch_timer = 0
				moustache_twitch_count = 0
				moustache_direction = 1

func animate_legs(delta: float):
	if abs(left_leg.rotation_degrees) <= leg_rotation_max:
		left_leg.rotation_degrees += leg_direction*leg_rotation_speed*delta
	else:
		left_leg.rotation_degrees = leg_rotation_max*leg_direction
		leg_direction *= -1
	right_leg.rotation_degrees = -left_leg.rotation_degrees

func reset_legs(delta: float):
	if left_leg.rotation_degrees*leg_direction < 0:
		left_leg.rotation_degrees += leg_direction*leg_rotation_speed*delta
	else:
		left_leg.rotation_degrees = 0
		leg_direction = 1
	right_leg.rotation_degrees = -left_leg.rotation_degrees
	
func animate_body(delta: float):
	if body_bounce_percent >= 0 || body_bounce_percent <= 1:
		var change = body_direction*body_animate_speed*delta
		if (walking):
			change *= body_running_mult
		body_bounce_percent += change
	else:
		if body_direction == 1:
			body_bounce_percent = 1
		else:
			body_bounce_percent = 0
		body_direction *= -1
	body_group.position.y = body_anchor.y + body_bounce_max * sin(body_bounce_percent*2*PI)
	
func animate_arm(delta: float):
	if arm_rotation_percent >= 0 || arm_rotation_percent <= 1:
		var change = arm_direction*arm_rotation_speed*delta
		if (walking):
			change *= arm_walking_mult
		arm_rotation_percent += change
	else:
		if arm_direction == 1:
			arm_rotation_percent = 1
		else:
			arm_rotation_percent = 0
		arm_direction *= -1
	front_arm.rotation_degrees = arm_rotation_max * sin(arm_rotation_percent*2*PI)

# flips the player to face the right way
func face(direction):
	if (direction.length() > 0):
		if direction.x > 0 && flipped:
			player.scale.x *= -1#0.3
			scale = Vector2(1,1)
			rotation_degrees = 0
			flipped = false
		elif direction.x < 0 && not flipped:
			player.scale.x *= -1#-0.3
			rotation_degrees = 180
			scale = Vector2(-1,-1)
			flipped = true

# arm t/f for left right, degrees angle from down rotating counterclockwise
func set_arm_rotation(arm, degrees):
	if arm:
		front_arm.rotation_degrees = -degrees
	else:
		back_arm.rotation_degrees = -degrees
		
# leg t/f for left right, degrees angle from down rotating counterclockwise
func set_leg_rotation(leg, degrees):
	if leg:
		left_leg.rotation_degrees = -degrees
	else:
		right_leg.rotation_degrees = -degrees
		
func set_animation(keyword):
	if keyword == "idle":
		walking = false
	elif keyword == "hold_item":
		holding_item = true
		arm_idle = false
		reset_head()
	elif keyword == "walk":
		walking = true
	elif keyword == "attack_charge":
		swing_attacking = true
		aiming = false
		arm_idle = false
		holding_item = false
		reset_head()
	elif keyword == "attack_idle":
		swing_attacking = true
		aiming = false
		arm_idle = true
		holding_item = false
		reset_head()
	elif keyword == "attack_aim":
		aiming = true
		swing_attacking = false
		arm_idle = false
		holding_item = false
	elif keyword == "hand_empty":
		aiming = false
		swing_attacking = false
		arm_idle = true
		reset_head()
	else:
		print("invalid keyword")
		
func equip_item(item: Node2D):
	if item is Melee_Weapon:
		set_animation("attack_charge")
		item.animator = self
	elif item is Ranged_Weapon:
		set_animation("attack_aim")
	elif item is Plate || item is Enemy_Drop:
		set_animation("hold_item")
	else:
		print("an error occured")
	holding_item = true
	if flipped:
		item.scale.y = -abs(item.scale.y)
	else:
		item.scale.y = abs(item.scale.y)
	item.reparent(player)
	var mgMusic = load("res://Audio/MGR.mp3")
	var regular = load("res://Audio/JazzBackground.mp3")
	if item is Murasma && bgMusic.stream == regular:
		bgMusic.stream = mgMusic
		bgMusic.play()
	elif bgMusic.stream == mgMusic:
		bgMusic.stream = regular
		bgMusic.play()
	
func drop_item(item: Node2D):
	set_animation("hand_empty")
	item.reparent(root)
	if item is Melee_Weapon:
		item.animator = null
	holding_item = false
	var regMusic = load("res://Audio/JazzBackground.mp3")
	if bgMusic.stream != regMusic:
		bgMusic.stream = regMusic
		bgMusic.play()

# returns whether or not we're facing right
func get_direction():
	return flipped
	
func get_aim_direction() -> Vector2:
	var mouse = get_global_mouse_position()
	var pos = player.global_position
	return mouse-pos
