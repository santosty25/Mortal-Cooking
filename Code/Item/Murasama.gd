extends Melee_Weapon
class_name Murasma

var knockback = 3
var attackPressed = false
var camera: Camera2D = null
var cameraAnchor = Vector2.ZERO
var cameraZoom = 0
var zoom = 2.5
var zoomSpeed = 10
var zoomAngle = 15
var offset = 170
var isZoomed = false
var lines = []
var slashWidth = 10
var fadeRate = 10
var lastMousPos = null
var iFrames = 0.001
var enemyIFrames = []
var immuneEnemies: Array[RID] = []
var damage = 0.3

func _ready():
	label = "diced"
	camera = get_viewport().get_camera_2d()
	cameraAnchor = camera.position
	cameraZoom = camera.zoom.x

func _process(delta: float) -> void:
	queue_redraw()
	for each in lines:
		if (each[2] == 1):
			raycast_damage(each[0], each[1])
		each[2] -= fadeRate*delta
	var i = 0
	while i < len(enemyIFrames):
		enemyIFrames[i] -= delta
		if enemyIFrames[i] <= 0:
			enemyIFrames.remove_at(i)
			immuneEnemies.remove_at(i)
			i -= 1
		i += 1
	if (animator):
		animator.set_animation("hold_item")
		animator.set_arm_rotation(true, 0)
		rotation = rotation-PI/2
		if attackPressed && !isZoomed:
			camera.position = animator.player.position
			camera.global_position += animator.get_aim_direction().normalized()*offset
			attackPressed = false
			isZoomed = true
		elif attackPressed && isZoomed:
			animator.player.freeze()
			if (camera.zoom.x < zoom):
				camera.zoom += Vector2(zoomSpeed*delta, zoomSpeed*delta)
			else:
				if (!lastMousPos):
					lastMousPos = get_local_mouse_position()
				else:
					var slash: Vector2 = lastMousPos-get_local_mouse_position()
					if slash.length() > 50:
						slash = slash.normalized()*300
						var center = to_local(camera.position)+Vector2(randf(),randf()).normalized()*150
						if len(lines) > 0:
							var last = lines.back()[1]
							lines.append([last,center-slash, 1])
						else:
							lines.append([center+slash,center-slash, 1])
					lastMousPos = get_local_mouse_position()
			attackPressed = false
		else:
			animator.player.unfreeze()
			camera.zoom = Vector2(cameraZoom, cameraZoom)
			camera.position = cameraAnchor
			camera.rotation_degrees = 0
			isZoomed = false
			
func raycast_damage(start, end):
	var gStart = animator.player.to_global(start)
	var gEnd = animator.player.to_global(end)
	var space_state = get_world_2d().direct_space_state
	var query = PhysicsRayQueryParameters2D.create(gStart, gEnd)
	query.exclude = immuneEnemies
	query.collision_mask = 0b00000000_00000000_00000000_00000010
	var result = space_state.intersect_ray(query)
	while len(result.keys()) > 0:
		immuneEnemies.append(result.rid)
		enemyIFrames.append(iFrames)
		var body = result.collider
		if (body is Enemy):
			body.take_damage(damage, label)
			body.knockback((body.position-animator.player.position).normalized()*knockback)
		query = PhysicsRayQueryParameters2D.create(gStart, gEnd)
		query.exclude = immuneEnemies
		query.collision_mask = 0b00000000_00000000_00000000_00000010
		result = space_state.intersect_ray(query)
	
func _draw() -> void:
	var i = 0
	while i < len(lines):
		if lines[i][2] > 0:
			draw_line(lines[i][0], lines[i][1], Color(1,0,0,lines[i][2]), slashWidth)
		else:
			lines.remove_at(i)
			i -= 1
		i += 1

func swing():
	attackPressed = true
