extends Area2D

var damage_per_second = 1
var player_in_zone = null

# how long the cheese is in the scene
var active_time = 20.0

# Called when the node enters the scene tree for the first time.
func _ready():
	set_process(true)
	z_index = -10

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	active_time -= delta
	if active_time <= 0:
		queue_free()
	
	if player_in_zone:
		player_in_zone.take_damage(damage_per_second * delta, "cheese damage")


func _on_body_entered(body):
	if body is Player:
		player_in_zone = body


func _on_body_exited(body):
	if body is Player:
		player_in_zone = null
