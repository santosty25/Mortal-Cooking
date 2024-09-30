extends CharacterBody2D
class_name Plate

var itemLabels = []
var itemNodes = []
var itemStackOffset = -20

func _process(delta: float) -> void:
	for i in range(len(itemNodes)):
		itemNodes[i].global_position = global_position+Vector2(0, itemStackOffset*i)

func add_item(node, itemLabel):
	node.get_node("Hitbox").disabled = true
	node.reparent(self)
	node.global_position = position+Vector2(0, itemStackOffset*len(itemNodes))
	itemLabels.append(itemLabel)
	itemNodes.append(node)
	node.z_index = z_index+len(itemNodes)

func get_label():
	return itemLabels

func delete():
	for each in itemNodes:
		each.queue_free()
	queue_free()

func clear():
	for each in itemNodes:
		each.queue_free()
	itemNodes = []
