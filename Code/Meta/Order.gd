extends Node
class_name Order

var order_steps: Array[Order_Step] = []

func equals(dish: Array[String]) -> bool:
	if len(dish) != len(order_steps):
		return false
	for label in dish:
		pass
	return true

func choose_n(options: Array[String], count: int, repeat=false):
	var r = []
	for i in range(count):
		var choice = randi_range(0,len(options)-1)
		r.append(options[choice])
		if !repeat:
			options.remove_at(choice)
	return r
		
