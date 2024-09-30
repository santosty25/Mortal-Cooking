extends Node2D
class_name Main

@onready var pause_menu = $"Pause Menu"
var paused = false

# lists of possible order ingredients including strings, scenes, and images
var ingredientsLabels = ["apple", "lettuce", "tomato", "cheese", "beef", "bread", "shrimp"] # list of all base ingredients
var preparationsLabels = ["chopped", "burned", "diced", "flattened"] # list of all ways of preparing ingredients
var weaponIcons = [load("res://art/UI/Halberd_Icon.png"),load("res://art/Effects/Flame_Large.PNG"),load("res://art/UI/Murasama_Icon.png"),load("res://art/UI/Hammer_Icon.png")]
var enemyIcons = [load("res://art/UI/apple_icon.png"),load("res://art/UI/lettuce_icon.png"),load("res://art/UI/tomato_icon.png"),load("res://art/UI/cheese_icon.png"),load("res://art/UI/meat_icon.png"),load("res://art/UI/bread_icon.png"),load("res://art/UI/shrimp_icon.png")]
var ingredients = [load("res://Scenes/Character/Apple.tscn"), load("res://Scenes/Character/Tomato.tscn"), load("res://Scenes/Character/Beef.tscn"), load("res://Scenes/Character/Bread.tscn"), load("res://Scenes/Character/Cheese.tscn"), load("res://Scenes/Character/Lettuce.tscn"), load("res://Scenes/Character/Shrimp.tscn")]
var slop = load("res://art/Item/Slop.PNG")
var dropImages = [
					[	
						load("res://art/Item/Apple_Slices.png"), 
						load("res://art/Item/Dried_Apples.png"),
						load("res://art/Item/Cubed_Apple.png"), 
						load("res://art/Item/Applesauce.png")
					],
					[	
						load("res://art/Item/Lettuce_Leaf.PNG"), 
						slop,
						load("res://art/Item/Diced_Lettuce.png"), 
						slop
					],
					[	
						load("res://art/Item/Tomato_Slice.PNG"), 
						slop,
						load("res://art/Item/Diced_Tomato.png"), 
						load("res://art/Item/Ketchup.png")
					],
					[	
						load("res://art/Item/Cheese_Slice.PNG"), 
						load("res://art/Item/Melted_Cheese.PNG"),
						load("res://art/Item/String_Cheese.png"), 
						slop,
					],
					[	
						load("res://art/Item/Sliced_Beef.PNG"),
						load("res://art/Item/Steak.PNG"), 
						load("res://art/Item/Cubed_Beef.png"), 
						load("res://art/Item/Ground_Beef.png")
					],
					[	
						load("res://art/Item/Bread.PNG"), 
						load("res://art/Item/Toast.PNG"),
						load("res://art/Item/Crutons.png"), 
						load("res://art/Item/Naan.png")
					],
					[	
						slop,
						load("res://art/Item/Fried_Shrimp.PNG"),
						slop,
						slop
					]
				] # first index is ingredient, second is preparation


# things we need to respawn
var plate = load("res://Scenes/Item/Plate.tscn")
var chicken = load("res://Scenes/Character/Chicken.tscn")
var chickenSpawn

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
var ordersServed = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	generate_order()
	generate_order()
	
	chickenSpawn = $Path2D/PathFollow2D
	spawn_chicken()
	
	$Bin1.set_spawn(load("res://Scenes/Character/Apple.tscn"))
	$Bin2.set_spawn(load("res://Scenes/Character/Cow.tscn"))
	$Bin3.set_spawn(load("res://Scenes/Character/Bread.tscn"))
	$Bin4.set_spawn(load("res://Scenes/Character/Cheese.tscn"))
	$Bin5.set_spawn(load("res://Scenes/Character/Lettuce.tscn"))
	$Bin6.set_spawn(load("res://Scenes/Character/Shrimp.tscn"))
	$Bin7.set_spawn(load("res://Scenes/Character/Tomato.tscn"))
	
	$Bin1.set_sprite(load("res://art/Terrain/Apple_Crate.png"))
	$Bin2.set_sprite(load("res://art/Terrain/Meat_Crate.png"))
	$Bin3.set_sprite(load("res://art/Terrain/Bread_Crate.png"))
	$Bin4.set_sprite(load("res://art/Terrain/Cheese_Crate.png"))
	$Bin5.set_sprite(load("res://art/Terrain/Lettuce_Crate.png"))
	$Bin6.set_sprite(load("res://art/Terrain/Shrimp_Crate.png"))
	$Bin7.set_sprite(load("res://art/Terrain/Tomato_Crate.png"))
	
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Pause"):
		pauseMenu()
	$Score.text = "$"+str(score)

func pauseMenu():
	if paused:
		pause_menu.hide()
		Engine.time_scale = 1
	else:
		pause_menu.show()
		Engine.time_scale = 0 
	
	paused = !paused

func generate_order():
	var orderStack = []
	var selection = 0
	if ordersServed < 5:
		selection = randi_range(1,6)
	elif ordersServed < 10:
		selection = randi_range(4,8)
	elif ordersServed < 15:
		selection = randi_range(5,10)
	else:
		selection = randi_range(7,11)
	match selection:
		1:
			orderStack = [["apple", "chopped"]]
		2:
			orderStack = [["apple", "burned"]]
		3:
			orderStack = [["apple", "flattened"]]
		4:
			orderStack = [["cheese", "diced"]]
		5:
			orderStack = [["beef", "burned"]]
		6:
			orderStack = [["shrimp", "burned"]]
		7:
			#KBBQ
			orderStack = [["beef","chopped"],["tomato", "flattened"]]
		8:
			#grilled cheese
			orderStack = [["bread", "burned"],["cheese", "burned"]]
		9:
			#charcuterie board
			orderStack = choose_n([["bread", "flattened"],["cheese", "diced"],["apple", "diced"],["beef", "diced"]], randi_range(2,3),false)
		10:
			#salad
			orderStack = [["lettuce","chopped"]]
			orderStack.append_array(choose_n([["apple", "diced"],["tomato","diced"]],1,true))
			orderStack.append(["bread","diced"])
		11:
			#burger
			orderStack = choose_n([["bread", "chopped"]],1,true)
			orderStack.append(["beef", "flattened"])
			orderStack.append_array(choose_n([["lettuce","chopped"],["tomato","chopped"],["cheese","chopped"],["tomato","flattened"]],randi_range(0,4),false))
	
	# create order display
	var orderDisplay: Order = orderNode.instantiate()
	orderDisplay.set_main(self)
	orderDisplay.position = Vector2(-570*2+150 + orderSeparation * len(currentOrders),-320*2)
	add_child(orderDisplay)
	
	for each in orderStack:
		var orderStep = dropNode.instantiate()
		var ingredientIndex = ingredientsLabels.find(each[0])
		var preparationIndex = preparationsLabels.find(each[1])
		orderStep.set_image(dropImages[ingredientIndex][preparationIndex])
		orderDisplay.get_node("Plate").add_item(orderStep, each)
		orderDisplay.add_child(orderStep)
		
	orderDisplay.get_node("Timer").wait_time = 30*len(orderStack)
	
	# decide what order is
	'''var orderStack = []
	for i in range(randi_range(minOrderSteps,maxOrderSteps)):
		var processed = slop
		var ingredient = ""
		var preparation = ""
		var ingredientIndex = -1
		var preparationIndex = -1
		while processed == slop:
			ingredientIndex = randi_range(0, len(ingredientsLabels)-1)
			ingredient = ingredientsLabels[ingredientIndex]
			preparationIndex = randi_range(0, len(preparationsLabels)-1)
			preparation = preparationsLabels[preparationIndex]
			processed = get_drop_image([ingredient, preparation])
		orderStack.append([ingredient,preparation])
		
		# display item on order display
		var orderStep = dropNode.instantiate()
		orderStep.set_image(dropImages[ingredientIndex][preparationIndex])
		orderDisplay.get_node("Plate").add_item(orderStep, [ingredient,preparation])
		orderDisplay.add_child(orderStep)
	'''
		
	# track current orders
	currentOrders.append([orderDisplay, orderStack])
	
	# tell display node what order its tracking
	orderDisplay.set_order(orderStack)
	

func _on_order_cooldown_timeout() -> void:
	generate_order()

func remove_order(order: Node2D):
	var id = -1
	# get order from list
	for i in range(len(currentOrders)):
		print(currentOrders[i][0])
		print(order)
		if currentOrders[i][0] == order:
			id = i
			break
	if (id >= 0):
		currentOrders.remove_at(id)
		order.queue_free()
		# iterate through subsequent orders and shift them over
		for i in range(id, len(currentOrders)):
			currentOrders[i][0].position.x = -570*2+150 + orderSeparation * i
			
func serve(order):
	var id = -1
	var label = order.get_label()
	# get order from list
	for i in range(len(currentOrders)):
		var found = true
		for each in currentOrders[i][1]:
			if not each in label:
				found = false
				continue
		if found:
			id = i
	if id == -1:
		return false # return failure, no orders matched the delivered item
	else:
		score += currentOrders[id][0].get_reward()
		$Player.heal(len(currentOrders[id][1]))
		remove_order(currentOrders[id][0])
		order.delete()
		ordersServed += 1
		
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
	if dropImages[x][y] == slop:
		return null
	return dropImages[x][y]
	
# returns enemy, weapon, and result
func get_tooltip_icons(ing, prep):
	var ing_idx = ingredientsLabels.find(ing)
	var prep_idx = preparationsLabels.find(prep)
	return [enemyIcons[ing_idx],weaponIcons[prep_idx],dropImages[ing_idx][prep_idx]]
	
func spawn_chicken():
	var chick = chicken.instantiate()
	chickenSpawn.progress_ratio = randf()
	add_child(chick)
	chick.position = chickenSpawn.position
	
	chickenSpawn.progress_ratio = randf()
	chick.move(chickenSpawn.position)

func choose_n(list: Array, amount: int, replace: bool):
	var rval = []
	for i in range(amount):
		if replace:
			rval.append(list[randi_range(0,len(list)-1)])
		else:
			rval.append(list.pop_at(randi_range(0,len(list)-1)))
	return rval
