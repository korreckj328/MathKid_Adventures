extends KinematicBody2D

enum {IDLE, HURT, JUMP, RUN, DEAD}

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
		JUMP:
			newAnim = "jump"
		RUN:
			newAnim = "run"
		DEAD:
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
	














