extends Node2D

var order = null
var timerPercent = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Plate/Hitbox.disabled = true
	
func _process(delta: float) -> void:
	timerPercent = $Timer.time_left/$Timer.wait_time
	$Sprite2D.modulate = Color(1,timerPercent,timerPercent)

func set_order(order):
	self.order = order

func get_reward():
	return round(len($Plate.itemLabels)*10*timerPercent)

func _on_timer_timeout() -> void:
	$"..".remove_order(self)
