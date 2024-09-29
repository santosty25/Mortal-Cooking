extends Terrain
class_name Bin

var spawn = load("res://Scenes/Character/Apple.tscn")
var sprite = load("res://art/Terrain/AppleBin.png")

# vary from 0 to 0.025 to increase difficulty
var spawnChance = 0.0

func spawn_enemy():
	var spawnNode = spawn.instantiate()
	spawnNode.position = position - Vector2(200, 0)
	$"..".add_child(spawnNode)

func set_spawn(node):
	spawn = node

func set_sprite(img):
	sprite = img
	$Sprite2D.texture = img

func _on_random_spawn_timeout() -> void:
	if randf() < spawnChance:
		spawn_enemy()
