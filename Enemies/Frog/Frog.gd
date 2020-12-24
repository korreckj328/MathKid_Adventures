extends KinematicBody2D

enum {IDLE, HURT, MOVE}

export (int) var speed
export (int) var gravity
export (int) var jump_str

var state
var velocity = Vector2()
var facing = 1
var anim
var newAnim
var mapBottom = 2000000
var cooldown = false
var lastVelocity = 0

func SetMapBottom(value):
	mapBottom = value

func _physics_process(delta):
	$Sprite.flip_h = lastVelocity > 0
	if anim != newAnim:
		anim = newAnim
		$AnimationPlayer.play(anim)
	velocity.y += gravity * delta
	if is_on_floor() and !cooldown:
		if facing == -1:
			if !$CastLeft.is_colliding():
				velocity.y += jump_str
				changeState(MOVE)
				velocity.x = facing * speed
				cooldown = true
				lastVelocity = velocity.x
			else:
				facing = facing * -1
				velocity.x = facing * speed
				velocity.y += jump_str
				cooldown = true
				lastVelocity = velocity.x
		else:
			if !$CastRight.is_colliding():
				velocity.y += jump_str
				changeState(MOVE)
				velocity.x = facing * speed
				cooldown = true
				lastVelocity = velocity.x
			else:
				facing = facing * -1
				velocity.x = facing * speed
				velocity.y += jump_str
				cooldown = true
				lastVelocity = velocity.x
	if $Timer.time_left > 0:
		lastVelocity = velocity.x 
		velocity.x = 0
	

	velocity = move_and_slide(velocity,Vector2(0,-1))
		
	for idx in range(get_slide_count()):
		var collision = get_slide_collision(idx)
		if collision.collider.name in ["Male", "Female"]:
			collision.collider.hurt()
		if collision.normal.x != 0:
			facing = sign(collision.normal.x)
			velocity.y = -100
	if position.y > mapBottom:
		queue_free()
	
	if state == MOVE and is_on_floor():
		$Timer.start()
		$Dust.emitting = true
		changeState(IDLE)
	

func changeState(newState):
	state = newState
	match state:
		IDLE:
			newAnim = "Idle"
			state = IDLE
		HURT:
			newAnim = "Squished"
			state = HURT
		MOVE:
			newAnim = "Move"
			state = MOVE

func _ready():
	state = IDLE

func takeDamage():
	$AnimationPlayer.play("Squished")
	$CollisionShape2D.disabled = true
	set_physics_process(false)


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "Squished":
		queue_free()


func _on_Timer_timeout():
	cooldown = false;
