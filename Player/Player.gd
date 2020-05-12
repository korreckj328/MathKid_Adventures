extends KinematicBody2D

signal lifeChanged
signal dead

enum {IDLE, HURT, JUMP, RUN, DEAD}

var life
var state
var anim
var newAnim
var velocity = Vector2()

export(int) var runSpeed
export(int) var jumpSpeed
export(int) var gravity

func _ready():
	changeState(IDLE)

func changeState(newState):
	state = newState
	match state:
		IDLE:
			newAnim = "idle"
		HURT:
			newAnim = "hurt"
			velocity.y = -200 * sign(velocity.y)
			velocity.x = -100 * sign(velocity.x)
			life -= 1
			emit_signal("lifeChanged", life)
			yield(get_tree().create_timer(0.5), "timeout")
			changeState(IDLE)
			if life <= 0:
				changeState(DEAD)
		JUMP:
			newAnim = "jump"
		RUN:
			newAnim = "run"
		DEAD:
			emit_signal("dead")
			hide()

func _physics_process(delta):
	velocity.y += gravity * delta
	getInput()
	if newAnim != anim:
		anim = newAnim
		$AnimationPlayer.play(anim)
	velocity = move_and_slide(velocity, Vector2(0,-1))
	if state == JUMP and is_on_floor():
		changeState(IDLE)
	if state == JUMP and velocity.y > 0:
		newAnim = "fall"
	for idx in range(get_slide_count()):
		var collision = get_slide_collision(idx)
		if collision.collider.is_in_group("Enemies"):
			var playerFeet = (position + $Hitbox.shape.extents).y
			if playerFeet < collision.collider.position.y:
				collision.collider.takeDamage()
				velocity.y += -200
			else:
				hurt()

func getInput():
	if state == HURT:
		return
	
	var right = Input.is_action_pressed("Right")
	var left = Input.is_action_pressed("Left")
	var jump = Input.is_action_just_pressed("Jump")
	
	velocity.x = 0
	if right:
		velocity.x += runSpeed
		$Sprite.flip_h = false
	if left:
		velocity.x -= runSpeed
		$Sprite.flip_h = true
	if jump and is_on_floor():
		changeState(JUMP)
		velocity.y = jumpSpeed
	
	if state == IDLE and velocity.x != 0:
		changeState(RUN)
	if state == RUN and velocity.x == 0:
		changeState(IDLE)
	if state in [IDLE, RUN] and !is_on_floor():
		changeState(JUMP)
	

func start(pos):
	life = 3
	emit_signal("lifeChanged", life)
	position = pos
	show()
	changeState(IDLE)

func hurt():
	if state != HURT:
		changeState(HURT)













