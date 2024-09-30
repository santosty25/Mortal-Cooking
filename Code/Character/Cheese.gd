extends Enemy
class_name Cheese

const SPEED = 100
var stepSide = false
var target = Vector2.ZERO
var attack = 0
var rotSpeed = 300
@onready var front = $Sprite/Front
@onready var back = $Sprite/Back

@onready var BLA = $Sprite/Back/L_Anchor
@onready var BRA = $Sprite/Back/R_Anchor
@onready var FLA = $Sprite/Front/L_Anchor
@onready var FRA = $Sprite/Front/R_Anchor
@onready var BC = $Sprite/Back/Center
@onready var FC = $Sprite/Front/Center
@onready var BLI = $Sprite/Back/L_Inner
@onready var BRI = $Sprite/Back/R_Inner
@onready var FLI = $Sprite/Front/L_Inner
@onready var FRI = $Sprite/Front/R_Inner

@onready var cheesin = $AudioStreamPlayer2D

# reference to the player
var player

var meltedCheese = preload("res://Scenes/Effects/MeltedCheese.tscn")

# timer for dropping melted cheese
var drop_timer = 5.0
var drop_interval = 5.0

func _ready():
	player = get_parent().get_node("Player")
	label = "cheese"
	sprite = $AnimatedSprite2D
	
	# overrides
	maxHealth = 5
	health = maxHealth

func _process(delta):
	super._process(delta)
	queue_redraw()
	if player:
		# Set target to player's position
		target = player.position
		var direction = (target - position).normalized() * SPEED
		
		if sign(direction.x)*sign(direction.y) == sign(scale.y):
			scale.x *= -1

		if (position - target).length() > 0.1:

			if (direction * delta).length() > (target - position).length():
				move_and_collide(target - position)
			else:
				move_and_collide(direction * delta)
				
		if sign(direction.y) < 0:
			front.rotate(delta*PI*rotSpeed/180)
			back.rotate(delta*PI*rotSpeed/180)
		else:
			front.rotate(-delta*PI*rotSpeed/180)
			back.rotate(-delta*PI*rotSpeed/180)
	
	# Time for dropping cheese
	drop_timer -= delta
	if drop_timer <= 0:
		drop_melted_cheese()
		drop_timer = drop_interval # reset timer

func _draw() -> void:
	#Color(249,196,9)
	var coords_fill_L : Array = [
		[BLI.global_position.x,BLI.global_position.y],
		[BC.global_position.x,BC.global_position.y],
		[FC.global_position.x,FC.global_position.y],
		[FLI.global_position.x,FLI.global_position.y]
	]
	var fill_L_packed : PackedVector2Array = []
	for coord in coords_fill_L:
		fill_L_packed.append(to_local(Vector2(coord[0], coord[1])))
	var coords_fill_R : Array = [
		[BRI.global_position.x,BRI.global_position.y],
		[BC.global_position.x,BC.global_position.y],
		[FC.global_position.x,FC.global_position.y],
		[FRI.global_position.x,FRI.global_position.y]
	]
	var fill_R_packed : PackedVector2Array = []
	for coord in coords_fill_R:
		fill_R_packed.append(to_local(Vector2(coord[0], coord[1])))
	draw_polygon(fill_L_packed,[Color(249.0/256,196.0/256,9.0/256)])
	draw_polygon(fill_R_packed,[Color(249.0/256,196.0/256,9.0/256)])
	draw_line(to_local(BLA.global_position),to_local(FLA.global_position),Color.BLACK,10)
	draw_line(to_local(BRA.global_position),to_local(FRA.global_position),Color.BLACK,10)

func _physics_process(delta):
	attack -= delta

func _on_area_2d_body_entered(body):
	if body is Player:
		body.take_damage(1, "attack")
	attack = 0.3

func drop_melted_cheese():
	var melted_cheese = meltedCheese.instantiate()
	
	# add melted cheese to the scene
	melted_cheese.position = position
	cheesin.play()
	get_parent().add_child(melted_cheese)
	
func get_label():
	return label
