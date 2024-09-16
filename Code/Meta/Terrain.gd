extends CharacterBody2D
class_name Terrain

var burnCount = 0
var burnCountMax = 5
var burnDelay = 0
var burnDelayMax = 1

func _process(delta: float) -> void:
	if burnDelay > 0:
		burnDelay -= delta

func ignite(flame: Flame):
	if burnCount > burnCountMax || burnDelay > 0:
		flame.queue_free()
		return
	else:
		burnDelay = burnDelayMax
		flame.set_target(self)
		flame.position = position
