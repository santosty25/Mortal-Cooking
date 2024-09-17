extends CharacterBody2D
class_name Bin

var spawn = load("res://Scenes/Character/Apple.tscn")

func spawn_enemy():
	var spawnNode = spawn.instantiate()
	spawnNode.position = position - Vector2(200, 0)
	$"..".add_child(spawnNode)
