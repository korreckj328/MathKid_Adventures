extends Area2D

export (Vector2) var speed
export (int) var fireBallGravity
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
	self.position += speed * delta


func _on_Fireball_body_entered(body):
	if body.is_in_group("Players"):
		body.hurt()
		queue_free()
	else:
		queue_free()
