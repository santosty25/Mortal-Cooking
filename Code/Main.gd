extends Node2D
class_name Main

# lists of possible order ingredients including strings, scenes, and images
var ingredientsLabels = ["apple"] # list of all base ingredients
var preparationsLabels = ["chopped", "fire"] # list of all ways of preparing ingredients
var ingredients = [load("res://Scenes/Character/Apple.tscn")]
var dropImages = [[load("res://art/Item/Apple_Slices.png"), load("res://art/Item/Dried_Apples.png")]] # first index is ingredient, second is preparation
var chickBody = load("res://Scenes/Character/Chicken.tscn")
var chickenSpawn

# things we need to respawn
var plate = load("res://Scenes/Item/Plate.tscn")

# for creating order icons on screen
var dropNode = load("res://Scenes/Item/Enemy_Drop.tscn")
var orderNode = load("res://Scenes/UI/Order.tscn")
var orderSeparation = 250

# vars for generating orders
var minOrderSteps = 1
var maxOrderSteps = 1

# global things to track
var score = 0
var currentOrders = [] # list of [node, orderStack], orderstack is list of [ingredient, preparation] strings

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	generate_order()
	generate_order()
	spawn_chicken()
	
func _process(delta: float) -> void:
	$Score.text = "$"+str(score)

func generate_order():
	# create order display
	var orderDisplay = orderNode.instantiate()
	orderDisplay.position = Vector2(-570*2+150 + orderSeparation * len(currentOrders),-320*2)
	add_child(orderDisplay)
	
	# decide what order is
	var orderStack = []
	for i in range(randi_range(minOrderSteps,maxOrderSteps)):
		var ingredientIndex = randi_range(0, len(ingredientsLabels)-1)
		var ingredient = ingredientsLabels[ingredientIndex]
		var preparationIndex = randi_range(0, len(preparationsLabels)-1)
		var preparation = preparationsLabels[preparationIndex]
		orderStack.append([ingredient,preparation])
		
		# display item on order display
		var orderStep = dropNode.instantiate()
		orderStep.set_image(dropImages[ingredientIndex][preparationIndex])
		orderDisplay.get_node("Plate").add_item(orderStep, [ingredient,preparation])
		orderDisplay.add_child(orderStep)
		
	# track current orders
	currentOrders.append([orderDisplay, orderStack])
	
	# tell display node what order it's tracking
	orderDisplay.set_order(orderStack)

func _on_order_cooldown_timeout() -> void:
	generate_order()

func remove_order(order):
	var id = -1
	# get order from list
	for i in range(len(currentOrders)):
		if currentOrders[i][0] == order[0]:
			id = i
	if (id >= 0):
		currentOrders.remove_at(id)
		order[0].queue_free()
		# iterate through subsequent orders and shift them over
		for i in range(id, len(currentOrders)):
			currentOrders[i][0].position.x = -570*2+150 + orderSeparation * i
			
func serve(order):
	var id = -1
	var label = order.get_label()
	# get order from list
	#print(currentOrders)
	#print(label)
	for i in range(len(currentOrders)):
		if currentOrders[i][1] == label:
			id = i
			break
	if id == -1:
		return false # return failure, no orders matched the delivered item
	else:
		score += currentOrders[id][0].get_reward()
		remove_order(currentOrders[id])
		order.delete()
		
		var plateCount = 0
		for each in get_children():
			if each is Plate:
				plateCount += 1
				
		if plateCount-1 < 4: # plate we just served has yet to be removed
			for each in get_children():
				if each is Table:
					var hasPlate = false
					for body in each.get_items():
						if body is Plate:
							hasPlate = true
					if not hasPlate:
						var plateNode = plate.instantiate()
						plateNode.position = each.position+Vector2(0,-20)
						$"..".add_child(plateNode)
						break
					
		
		return true
func get_drop_image(label: Array):
	var x = ingredientsLabels.find(label[0])
	var y = preparationsLabels.find(label[1])
	if !x || !y:
		print("invalid label: "+str(label))
	return dropImages[x][y]
		
func spawn_chicken():
	var chick = chickBody.instantiate()
	add_child(chick)

	chick.move(chick.position)
