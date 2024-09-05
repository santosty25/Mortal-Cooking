extends Node2D

var ingredientsLabels = ["apple"] # list of all base ingredients
var preparationsLabels = ["chopped"] # list of all ways of preparing ingredients

var ingredients = [load("res://art/Apple.png")]

var orderSteps = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	generate_order()

func generate_order():
	var orderStack = []
	for i in range(orderSteps):
		var ingredient = ingredientsLabels[randi_range(0, len(ingredientsLabels)-1)]
		var preparation = preparationsLabels[randi_range(0, len(preparationsLabels)-1)]
		orderStack.append([ingredient,preparation])
	return orderStack
	
func displayOrder():
	pass

func _on_order_cooldown_timeout() -> void:
	generate_order()
