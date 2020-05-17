extends KinematicBody2D

export (Vector2) var velocity

var mapTop
var gravityBump = 750
var initialVelocity
var mapBottom

func _ready():
	initialVelocity = velocity

func _physics_process(delta):
	if position.y < mapTop || position.y > mapBottom:
		velocity = velocity.bounce(Vector2(0, -1))
	var collision = move_and_collide(velocity * delta)
	if collision:
		if collision.collider.is_in_group("Characters"):
			position = position + (velocity * delta)
		else:
			velocity = velocity.bounce(collision.normal)

func SetMapBottom(value):
	mapBottom = value

func SetMapTop(value):
	mapTop = value
