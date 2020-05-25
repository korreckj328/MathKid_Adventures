extends KinematicBody2D

export (Vector2) var speed
export (int) var gravity
export (float) var rotationDegrees

var mapBottom = 2000000



# initialize the speed to the right x direction
func init(facing, bottom):
	speed.x = speed.x * facing
	mapBottom = bottom

func _physics_process(delta):
	if position.y > mapBottom:
		queue_free()
	$Sprite.rotate(deg2rad(rotationDegrees))
	var collision = move_and_collide(speed * delta)
	if collision:
		if collision.collider.is_in_group("Players"):
			collision.collider.hurt()
			queue_free()
		else:
			queue_free()
	
