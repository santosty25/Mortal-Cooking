extends Area2D

const SPEED = 400
var direction = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
	$CollisionShape2D.disabled = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position += direction * SPEED * delta
	if position.distance_to(get_parent().get_node("Player").position) > 1000:
		queue_free()



func _on_body_entered(body):
	if body is Player:
		body.take_damage(1, "Projectile Attack")
		queue_free()
