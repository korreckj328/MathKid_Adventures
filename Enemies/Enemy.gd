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
			velocity.y = -100
	else:
		if $CastRight.is_colliding():
			velocity.x = facing * speed
		else:
			facing = facing * -1
			velocity.x = facing * speed
			velocity.y = -100
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
	

func _ready():
	newAnim = "Move"

func takeDamage():
	$AnimationPlayer.play("Squished")
	$CollisionShape2D.disabled = true
	set_physics_process(false)


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "Squished":
		queue_free()
