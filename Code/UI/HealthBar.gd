extends ProgressBar

@export var player: Player

func _ready():
	player = get_parent().get_node("Player")
	if player:
		player.healthChanged.connect(update)
		update()
	
# updates the health bar
func update():
	value = player.health * 100 / player.maxHealth
	
