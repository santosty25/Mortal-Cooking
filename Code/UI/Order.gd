extends Node2D
class_name Order

var order = null
var timerPercent = 1
var timerMax = 0
var main: Main = null
var tooltips = []
var tooltipOffset = 100
var tipsShown = false
var player
@onready var hint = load("res://Scenes/UI/Hint.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Plate/Hitbox.disabled = true
	timerMax = $Timer.time_left
	player = get_parent().get_node("Player")
	
func _process(delta: float) -> void:
	timerPercent = $Timer.time_left/timerMax
	$Sprite2D.modulate = Color(1,timerPercent,timerPercent)
	
	var mousePos = get_global_mouse_position()
	for i in range(len(tooltips)):
		if tooltips[i]:
			tooltips[i].position = mousePos+Vector2(0,tooltipOffset)*i

func set_order(order):
	self.order = order

func get_reward():
	var steps = len($Plate.itemLabels)
	var money = steps*5+round(steps*5*timerPercent)
	return money

func _on_timer_timeout() -> void:
	player.take_damage(1, "Order Incomplete")
	$"..".remove_order(self)

func set_main(node: Main):
	main = node
	

func _on_area_2d_mouse_entered() -> void:
	for each in $Plate.get_label():
		var hint_node = hint.instantiate()
		var icons = main.get_tooltip_icons(each[0],each[1])
		hint_node.set_icons(icons[0],icons[1],icons[2])
		add_child(hint_node)
		tooltips.append(hint_node)
	tipsShown = true

func _on_area_2d_mouse_exited() -> void:
	for each in tooltips:
		each.queue_free()
	tooltips = []
