extends Node2D
class_name Hint

func _ready() -> void:
	top_level = true
	z_index = 100

func set_icons(enemy, weapon, product):
	$CanvasGroup/Enemy.texture = enemy
	$CanvasGroup/Weapon.texture = weapon
	$CanvasGroup/Product.texture = product
