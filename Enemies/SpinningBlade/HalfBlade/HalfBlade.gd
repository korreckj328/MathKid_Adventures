extends KinematicBody2D

export (int) var speed
export (int) var gravity

var velocity = Vector2()
var facing = 1
var anim
var newAnim
var mapBottom = 2000000

func SetMapBottom(value):
	mapBottom = value

func _physics_process(delta):
	$Sprite.flip_h = velocity.x > 0
	if $Sprite.flip_h:
		$CPUParticles2D2Left.visible = true
		$CPUParticles2DRight.visible = false
	else:
		$CPUParticles2D2Left.visible = false
		$CPUParticles2DRight.visible = true
	if anim != newAnim:
		anim = newAnim
		$AnimationPlayer.play(anim)
	
	velocity.y += gravity * delta
	if facing == -1:
		if $CastLeft.is_colliding():
			velocity.x = facing * speed
		else:
			facing = facing * -1
			velocity.x = facing * speed
	else:
		if $CastRight.is_colliding():
			velocity.x = facing * speed
		else:
			facing = facing * -1
			velocity.x = facing * speed
	velocity = move_and_slide(velocity,Vector2(0,-1))
	for idx in range(get_slide_count()):
		var collision = get_slide_collision(idx)
		if collision.collider.name in ["Male", "Female"]:
			collision.collider.hurt()
		if collision.normal.x != 0:
			facing = sign(collision.normal.x)
	if position.y > mapBottom:
		queue_free()
	

func _ready():
	newAnim = "Spin"

func takeDamage():
	$CollisionShape2D.disabled = true
	$Timer.start()


func _on_Timer_timeout():
	$CollisionShape2D.disabled = false
