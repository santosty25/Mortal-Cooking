extends CharacterBody2D
class_name Enemy_Drop

var label = []
var slop = load("res://art/Item/Slop.PNG")

func set_image(image):
	$Sprite2D.texture = image

func get_label():
	return label

func set_slop():
	$Hitbox.disabled = true
	$Sprite2D.texture = slop
