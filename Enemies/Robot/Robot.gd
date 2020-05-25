extends KinematicBody2D

var fireBall = preload("res://Projectiles/Fireball/Fireball.tscn")

export (int) var speed
export (int) var gravity

var velocity = Vector2()
var facing = 1
var readyToFire
var anim
var newAnim
var mapBottom = 2000000

func SetMapBottom(value):
	mapBottom = value

func _ready():
	newAnim = "Run"
	readyToFire = true

func flip():
	if $Sprite.flip_h == true:
		$Sprite.flip_h = false
	else:
		$Sprite.flip_h = true

func _physics_process(delta):
	$Sprite.flip_h = velocity.x < 0
	if anim != newAnim:
		anim = newAnim
		$AnimationPlayer.play(anim)
	
	velocity.y += gravity * delta
	
	if anim == "Attack":
		velocity.x = 0
	else:
		if facing == -1:
			if $LineOfFireLeft.is_colliding() && readyToFire: 
				velocity.x = 0
				newAnim = "Attack"
				flip()
				readyToFire = false
				var world = get_parent()
				var f = fireBall.instance()
				f.init(facing, mapBottom)
				world.add_child(f)
				f.position = $SpawnLeft.global_position
				$ShotTimer.start()
			else:
				if $CastLeft.is_colliding():
					velocity.x = facing * speed
				else:
					facing = facing * -1
					velocity.x = facing * speed
					velocity.y = -100
		else:
			if $LineOfFireRight.is_colliding() && readyToFire:
				velocity.x = 0
				newAnim = "Attack"
				readyToFire = false
				var world = get_parent()
				var f = fireBall.instance()
				f.init(facing, mapBottom)
				world.add_child(f)
				f.position = $SpawnLeft.global_position
				$ShotTimer.start()
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

func takeDamage():
	newAnim = "Hit"
	anim = newAnim
	$AnimationPlayer.play(anim)
	$CollisionShape2D.disabled = true
	set_physics_process(false)


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "Hit":
		queue_free()
	elif anim_name == "Attack":
		newAnim = "Run"
		flip()


func _on_ShotTimer_timeout():
	readyToFire = true
