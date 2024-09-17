extends CharacterBody2D
class_name Chicken


const SPEED = 100.0
const JUMP_VELOCITY = -400.0
var direction: Vector2 = Vector2.ZERO
var change_direction_timer: float = 1.0

var player

func _ready():
	player = get_parent().get_node("Player")
	randomize()
	change_direction()

func move(position):
	position = velocity
	

func _physics_process(delta: float) -> void:
	velocity = direction * SPEED
	move_and_slide()
	#velocity = move_and_slide()
	
	if get_slide_collision_count() > 0:
		change_direction()
	
	#change_direction_timer -= delta
	#if change_direction_timer <= 0:
		#change_direction()
		#change_direction_timer = 1.0
		#
	if direction.x > 0:
		$AnimatedSprite2D.flip_h = true
	elif direction.x < 0:
		$AnimatedSprite2D.flip_h = false
		
func change_direction():
	direction = Vector2(randf_range(-1,1), randf_range(-1,1)).normalized()
