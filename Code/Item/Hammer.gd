extends Melee_Weapon
class_name Hammer

var damage = 0.3
var isThrown = false
var throwPressed = false
var playedSound = true

var initial_velocity = Vector2(6000, 0)
var movement = Vector2.ZERO
var pos = Vector2.ZERO
var pull = 140
var spinSpeed = 20
var distDelta = 0
var returning = false
var deadzone = 0.1
var throwDelta = 0
var rot = 0
var knockback = 30

func _ready():
	label = "flattened"

func _process(delta: float) -> void:
	if (animator):
		if throwPressed && !isThrown:
			animator.set_animation("hold_item")
			var aim = animator.get_aim_direction()
			if animator.flipped:
				initial_velocity.x = -abs(initial_velocity.x)
			else:
				initial_velocity.x = abs(initial_velocity.x)
			movement = initial_velocity.rotated(aim.angle())
			if(aim.x < 0):
				movement = movement.rotated(PI)
			throwPressed = false
			isThrown = true
			pos = global_position
			distDelta = 0
			returning = false
			throwDelta = 0
		elif isThrown:
			animator.set_animation("hold_item")
			global_rotation = rot
			rot += PI*spinSpeed/180
			global_position = pos
			var playerVect = pos-animator.player.global_position
			distDelta = playerVect.length()
			movement -= pull*(playerVect).normalized()
			pos += movement*delta
			playerVect = pos-animator.player.global_position
			distDelta = playerVect.length()-distDelta
			if distDelta > 0 and returning:
				isThrown = false
				throwPressed = false
			elif distDelta < 0 && throwDelta > deadzone:
				returning = true
			throwDelta += delta
		else:
			animator.set_animation("attack_idle")

func swing():
	throwPressed = true

func _on_hurtbox_body_entered(body: Node2D) -> void:
	if body is Enemy:
		$HitSound.play()
		body.take_damage(damage, label)
		if returning:
			body.knockback(movement.normalized().rotated(PI)*knockback)
		else:
			body.knockback(movement.normalized()*knockback)
