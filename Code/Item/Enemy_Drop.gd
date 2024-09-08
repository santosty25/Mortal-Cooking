extends CharacterBody2D
class_name Enemy_Drop

var label = []

func set_image(image):
	$Sprite2D.texture = image

func get_label():
	return label
