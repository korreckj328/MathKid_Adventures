extends "res://Items/Item.gd"

signal flagReached

enum {UP, DOWN}

var anim
var newAnim
var state

func _ready():
	changeState(DOWN)

func _on_body_entered(body):
	if state == DOWN:
		changeState(UP)
		emit_signal("flagReached")

func changeState(newState):
	state = newState
	match state:
		UP:
			newAnim = "dualImage"
		DOWN:
			newAnim = "singleImage"

func _physics_process(_delta):
	if anim != newAnim:
		anim = newAnim
	$AnimationPlayer.play(anim)
















