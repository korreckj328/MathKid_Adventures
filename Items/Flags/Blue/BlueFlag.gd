extends Area2D

signal flagReached

enum {UP, DOWN}

var anim
var newAnim
var state

func _ready():
	changeState(DOWN)

func changeState(newState):
	state = newState
	match state:
		UP:
			newAnim = "UP"
		DOWN:
			newAnim = "DOWN"
	$AnimationPlayer.play(newAnim)

func _on_Timer_timeout():
	emit_signal("flagReached")


func _on_BlueFlag_body_entered(_body):
	if state == DOWN:
		changeState(UP)
		$Timer.start()
