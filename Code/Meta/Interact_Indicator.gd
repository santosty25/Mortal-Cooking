extends Node2D
class_name Interact_Icon

var itemText = "Take (E)"
var terrainText = "Use (E)"

func _ready() -> void:
	top_level = true

func setTerrainText():
	$Label.text = terrainText
	
func setItemText():
	$Label.text = itemText

func disable():
	visible = false
	
func enable():
	visible = true
