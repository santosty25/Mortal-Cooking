extends Terrain
class_name Bin

var spawn = load("res://Scenes/Character/Apple.tscn")
var sprite = load("res://art/Terrain/AppleBin.png")

func spawn_enemy():
	var spawnNode = spawn.instantiate()
	spawnNode.position = position - Vector2(200, 0)
	$"..".add_child(spawnNode)

func set_spawn(node):
	spawn = node

func set_sprite(img):
	sprite = img
	$Sprite2D.texture = img
