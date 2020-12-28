extends KinematicBody2D

export (int) var speed
export (int) var gravity

var rng = RandomNumberGenerator.new()
var roll
var velocity = Vector2()
var initial_position
var ready_to_jump = true
var my_gravity

func _ready():
	rng.randomize()
	velocity.y = 0
	$AnimationPlayer.play("Base")
	initial_position = self.global_position
	my_gravity = gravity
	$Sprite.flip_v = false
	$Sprite.flip_h = true


func _physics_process(delta):
	if ready_to_jump:
		roll = rng.randi_range(-500, 500)
		velocity.y = -(speed + roll)
		ready_to_jump = false
		my_gravity = gravity
	velocity.y += my_gravity
	if self.global_position.y > initial_position.y:
		self.global_position = initial_position
		velocity.y = 0
		my_gravity = 0
		roll = rng.randi_range(1, 5)
		if $Timer.time_left == 0:
			$Timer.start(roll)
	if velocity.y > 0:
		$Sprite.flip_v = true
		$Sprite.flip_h = false
	else:
		$Sprite.flip_v = false
		$Sprite.flip_h = true
	velocity = move_and_slide(velocity, Vector2(0,1))
	
	for idx in range(get_slide_count()):
		var collision = get_slide_collision(idx)
		if collision.collider.name in ["Male", "Female"]:
			collision.collider.hurt()

func takeDamage():
	velocity.y = 150
	$CollisionShape2D.disabled = true

func _on_Timer_timeout():
	ready_to_jump = true

func playSplash():
	$SplashSound.play()


func _on_HitTimer_timeout():
	$CollisionShape2D.disabled = false
