extends Entity
class_name Enemy

var label = ""
var drop = load("res://Scenes/Item/Enemy_Drop.tscn")
@onready var main = get_tree().get_root()

func take_damage(amount: float, damageLabel: String):
	print("took damage"+str(amount))
	health -= amount
	if health < 0:
		var drop_node = drop.instantiate()
		drop_node.position = position
		drop_node.label = [label, damageLabel]
		if !(main is Main):
			main = Main.new()
		drop_node.set_image(main.get_drop_image(drop_node.label))
		$"..".add_child(drop_node)
		queue_free()
