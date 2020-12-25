extends KinematicBody2D

enum {IDLE, HURT, MOVE}
enum {RIGHT, LEFT}

export (int) var speed

var state
var velocity = Vector2(0, 0)
var anim
var newAnim
var mapBottom = 2000000
var facing = -1
var root_nodes
var player_location
var player_facing
var player_spirte

func SetMapBottom(value):
	mapBottom = value

func change_state(new_state):
	match new_state:
		IDLE:
			state = new_state
			newAnim = "Idle"
		HURT:
			state = new_state
			newAnim = "Hurt"
		MOVE:
			state = new_state
			newAnim = "Move"

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "Hurt":
		change_state(IDLE)
		$CollisionShape2D.disabled = false

func _ready():
	change_state(IDLE)
	root_nodes = get_parent().get_parent().get_children()

func takeDamage():
	change_state(HURT)
	if anim != newAnim:
		anim = newAnim
		$AnimationPlayer.play("Hurt")
	$CollisionShape2D.disabled = true

func _physics_process(delta):
	#$Sprite.flip_h = velocity.x > 0
	if anim != newAnim:
		anim = newAnim
		$AnimationPlayer.play(anim)
	
	for node in root_nodes:
		if node.name == "Male":
			player_location = to_global(node.position)
			for sub_node in node.get_children():
				if sub_node.name == "Sprite":
					if sub_node.flip_h == false:
						player_facing = RIGHT
					else:
						player_facing = LEFT
	
	if state == MOVE:
		var ghost_location = to_global(position)
		if player_location.x < ghost_location.x:
			if player_facing == RIGHT:
				#stay still
				velocity.x = 0
				velocity.y = 0
			else:
				velocity.x = -speed * delta
				if player_location.y > to_global(position).y:
					velocity.y = -speed * delta
				else:
					velocity.y = speed * delta
		else:
			if player_facing == LEFT:
				#stay still
				velocity.x = 0
				velocity.y = 0
			else:
				velocity.x = -speed * delta
				if player_location.y > to_global(position).y:
					velocity.y = speed * delta
				else:
					velocity.y = -speed * delta
	elif state == IDLE:
		var ab_dist = abs(to_global(position).x - player_location.x)
		if ab_dist < 2000:
			change_state(MOVE)
			
	velocity = move_and_slide(velocity,Vector2(0,1))
	
	for idx in range(get_slide_count()):
		var collision = get_slide_collision(idx)
		if collision.collider.name in ["Male", "Female"]:
			collision.collider.hurt()
		if collision.normal.x != 0:
			facing = sign(collision.normal.x)
			velocity.y = -100
	if position.y > mapBottom:
		queue_free()
