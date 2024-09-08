extends CharacterBody2D
class_name Plate

var itemLabels = []
var itemNodes = []
var itemStackOffset = -20

func _process(delta: float) -> void:
	for i in range(len(itemNodes)):
		itemNodes[i].position = position+Vector2(0, itemStackOffset*i)

func add_item(node, itemLabel):
	node.get_node("Hitbox").disabled = true
	itemLabels.append(itemLabel)
	itemNodes.append(node)

func get_label():
	return itemLabels

func delete():
	for each in itemNodes:
		each.queue_free()
	queue_free()
