extends Entity
class_name Chicken


const SPEED = 200.0
const JUMP_VELOCITY = -400.0
var direction: Vector2 = Vector2.ZERO
var change_direction_timer: float = 1.0

var player
var timer

var egg = load("res://Scenes/Character/Egg.tscn")

func _ready():
	player = get_parent().get_node("Player")
	randomize()
#spawnEgg()

func _physics_process(delta: float):
	var collision_info = move_and_collide(velocity * delta * 0.4)
	
	if collision_info:
		velocity = velocity.bounce(collision_info.get_normal())


func move(position):
	velocity = position

func getPosition():
	return position
