extends KinematicBody2D

export (Vector2) var velocity

var mapTop
var gravityBump = -750
var initialVelocity

func _ready():
	initialVelocity = velocity

func _physics_process(delta):
	var collision = move_and_collide(velocity * delta)
	if collision:
		if collision.collider.name in ["Male", "Female"] || collision.collider.name.match("BlueSlim*"):
			if velocity.y < 0:
				velocity.y -= gravityBump
			if velocity.y > 0:
				velocity.y = initialVelocity.y
		else:
			velocity = velocity * -1
			if velocity.y < 0:
				if velocity.y < initialVelocity.y:
					velocity.y = initialVelocity.y * -1
			elif velocity.y > 0:
				if velocity.y < initialVelocity.y:
					velocity.y = initialVelocity.y
	if position.y < mapTop:
		velocity.y = velocity.y * -1

func SetMapTop(value):
	mapTop = value
