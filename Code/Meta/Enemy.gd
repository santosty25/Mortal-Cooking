extends Entity
class_name Enemy

var label = ""
var drop = load("res://Scenes/Item/Enemy_Drop.tscn")
@onready var main = get_tree().get_root()

var motionMin = 10
var friction = 0.9
var motion = Vector2.ZERO

func take_damage(amount: float, damageLabel: String):
	health -= amount
	super.indicate_damage()
	if health < 0:
		var drop_node = drop.instantiate()
		drop_node.position = position
		drop_node.label = [label, damageLabel]
		if !(main is Main):
			main = Main.new()
		drop_node.set_image(main.get_drop_image(drop_node.label))
		$"..".add_child(drop_node)
		queue_free()

func get_label():
	return label

func knockback(direction: Vector2):
	motion = direction
	
func _process(delta: float) -> void:
	super._process(delta)
	var collision_info = move_and_collide(motion)
	if collision_info:
		motion = motion.bounce(collision_info.get_normal())
	motion *= friction
