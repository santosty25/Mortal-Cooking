extends CharacterBody2D
class_name Weapon

var mirrored = false
var label = ""
@onready var interactIconLocation: Vector2 = $InteractAnchor.position

func get_label():
	return label

func deal_damage(entity: Entity, amount: float):
	entity.take_damage(amount, label)
