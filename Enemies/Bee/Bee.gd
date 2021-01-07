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
var direction
var distance
var player_facing

var player

func SetMapBottom(value):
	mapBottom = value

func change_state(new_state):
	match new_state:
		IDLE:
			state = new_state
			newAnim = "Flying"
		HURT:
			state = new_state
			newAnim = "Hurt"
		MOVE:
			state = new_state
			newAnim = "Flying"

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "Hurt":
		queue_free()

func _ready():
	change_state(IDLE)
	var main
	for tmp_node in get_tree().get_root().get_children():
		if "Main" in tmp_node.name:
			main = tmp_node
		if "Level" in tmp_node.name:
			main = tmp_node
	if main.name == "Main":
		for node in main.get_children():
			if "Level" in node.name:
				var level = node.get_children()
				for sub_node in level:
					if sub_node.name == "Male":
						player = sub_node
	elif "Level" in main.name:
		for node in main.get_children():
			if node.name == "Male":
				player = node

func takeDamage():
	change_state(HURT)
	if anim != newAnim:
		anim = newAnim
		$AnimationPlayer.play("Hurt")
	$CollisionShape2D.disabled = true

func _physics_process(delta):
	$Sprite.flip_h = velocity.x > 0
	if anim != newAnim:
		anim = newAnim
		$AnimationPlayer.play(anim)
	
	direction = player.global_position - self.global_position
	distance = sqrt(direction.x * direction.x + direction.y * direction.y)
	
	for node in player.get_children():
		if node.name == "Sprite":
			if node.flip_h == false:
				player_facing = RIGHT
			else:
				player_facing = LEFT
	
	if state == MOVE:
		if direction.normalized().x > 0:
			velocity.x = ceil(direction.normalized().x) * speed
			if direction.normalized().y > 0:
				velocity.y = ceil(direction.normalized().y) * speed
			else:
				velocity.y = floor(direction.normalized().y) * speed
		else:
			velocity.x = floor(direction.normalized().x) * speed
			if direction.normalized().y > 0:
				velocity.y = ceil(direction.normalized().y) * speed
			else:
				velocity.y = floor(direction.normalized().y) * speed
	elif state == IDLE:
		if distance < 2000:
			change_state(MOVE)
	elif state == HURT:
		velocity.x = 0
		velocity.y = 0
			
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
