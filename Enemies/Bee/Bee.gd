extends KinematicBody2D

export (int) var speed
export (int) var gravity

var velocity = Vector2()
var facing = 1
var anim
var newAnim
var mapBottom = 2000000
var initialPosition
var isSet = true
var isInLoS = false

func SetMapBottom(value):
	mapBottom = value

func _ready():
	newAnim = "Flying"
	initialPosition = get_global_position()

func _physics_process(delta):
	$Sprite.flip_h = velocity.x > 0
	if anim != newAnim:
		anim = newAnim
		$AnimationPlayer.play(anim)
	
	var currentPosition = get_global_position()
	if !isSet:
		if currentPosition.y > initialPosition.y:
			velocity.y += gravity * delta
		elif currentPosition.y < initialPosition.y:
			velocity.y = 0
			position.y = initialPosition.y
			if $AttackTimer.is_stopped():
				$AttackTimer.start()
	
	if isInLoS:
		if isSet:
			velocity.y += 750
			isSet = false
	
	if facing == -1:
		if $CastLeft.is_colliding() == false:
			velocity.x = facing * speed
		else:
			facing = facing * -1
			velocity.x = facing * speed
	else:
		if $CastRight.is_colliding() == false:
			velocity.x = facing * speed
		else:
			facing = facing * -1
			velocity.x = facing * speed
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





func _on_Area2D_body_entered(body):
	isInLoS = true
	var xDirection = get_global_position().x - body.get_global_position().x
	if xDirection > 0:
		if facing != -1:
			facing *= -1
	else:
		if facing != 1:
			facing = 1
	velocity.x = facing * speed

func takeDamage():
	queue_free()

func _on_Area2D_body_exited(body):
	isInLoS = false
	var xDirection = get_global_position().x - body.get_global_position().x
	if xDirection > 0:
		if facing != -1:
			facing *= -1
	else:
		if facing != 1:
			facing = 1
	velocity.x = facing * speed







func _on_AttackTimer_timeout():
	isSet = true
