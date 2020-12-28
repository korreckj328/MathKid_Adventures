extends KinematicBody2D

var velocity

func _ready():
	$AnimationPlayer.play("Spin")


func _physics_process(delta):
	velocity = Vector2(0,0)
	velocity = move_and_slide(velocity, Vector2(0,1))
	
	for idx in range(get_slide_count()):
		var collision = get_slide_collision(idx)
		if collision.collider.name in ["Male", "Female"]:
			collision.collider.hurt()

func takeDamage():
	$CollisionShape2D.disabled = true
	$Timer.start()


func _on_Timer_timeout():
	$CollisionShape2D.disabled = false

