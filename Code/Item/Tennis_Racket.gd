extends Melee_Weapon
class_name Tennis_Racket

var windupAngle = 90
var windupMax = 0.3
var windupCounter = 0
var swinging = false
var swingSpeed = 12
var maxDamage = 2
var knockback = 10
var windupPercent = 0

var attackPressed = false

func _ready():
	label = "diced"

func _process(delta: float) -> void:
	if (animator):
		if (attackPressed && !swinging):
			animator.set_animation("attack_charge")
			if windupCounter < windupMax:
				windupCounter += delta
			else:
				windupCounter = windupMax
			windupPercent = windupCounter/windupMax
			animator.set_arm_rotation(true, windupAngle*sin(windupCounter/windupMax*PI/2))
			attackPressed = false
		else:
			if (windupCounter > 0):
				swinging = true
				windupCounter -= delta*swingSpeed
				animator.set_arm_rotation(true, windupAngle*sin(windupCounter/windupMax*PI/2))
			elif windupPercent > 0:
				for body in $Hurtbox.get_overlapping_bodies():
					if body is Enemy:
						var r = (body.global_position-$Hurtbox.global_position).length()
						var max_r = ($Radius.global_position-$Hurtbox/Area.global_position).length()
						var distMult = max(0, 1-r/max_r)
						deal_damage(body, maxDamage*windupPercent*distMult)
						body.knockback((body.position-$Hurtbox.global_position).normalized()*knockback)
				swinging = false
				animator.set_animation("attack_idle")
				windupCounter = 0
				windupPercent = 0
			else:
				swinging = false
				animator.set_animation("attack_idle")
				windupCounter = 0
				windupPercent = 0

func swing():
	attackPressed = true
