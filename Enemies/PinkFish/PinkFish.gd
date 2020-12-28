extends KinematicBody2D

export (int) var speed

var rng = RandomNumberGenerator.new()
var roll
var direction = 1
var velocity = Vector2()

func _ready():
	rng.randomize()
	velocity.y = 0
	$AnimationPlayer.play("Swim")


func _physics_process(delta):
	roll = rng.randi_range(1, 500)
	if roll == 1:
		direction *= -1
	if direction > 0:
		$Sprite.flip_h = true
	else:
		$Sprite.flip_h = false
	velocity.x = direction * speed * delta
	move_and_slide(velocity, Vector2(0,1))
