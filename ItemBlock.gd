extends KinematicBody2D

signal spawnItem

export var bounceHeight = 32
export var bounceTime = 0.4

var healthUP = preload("res://Items/HealthUP/HealthUP.tscn")

var initialPosition
var bouncing
var empty

onready var moveUp = $MoveUp
onready var moveDown = $MoveDown

func _ready():
	bouncing = false
	empty = false
	moveUp.interpolate_property($Sprite, 'position:y', $Sprite.position.y, $Sprite.position.y - bounceHeight, bounceTime, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	moveUp.interpolate_property($Sprite, 'scale', $Sprite.scale, $Sprite.scale * 1.2, bounceTime, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	moveDown.interpolate_property($Sprite, 'position:y', $Sprite.position.y - bounceHeight, $Sprite.position.y, bounceTime, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	moveDown.interpolate_property($Sprite, 'scale', $Sprite.scale * 1.2, $Sprite.scale, bounceTime, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)

func init(pos):
	position = pos
	initialPosition = pos

func bounceUpward():
	if !bouncing:
		$AudioStreamPlayer2D.play()
		if !empty:
			spawnItem()
			empty = true
		moveUp.start()

func spawnItem():
	var m = get_parent().get_parent()
	var world = get_parent()
	var hUp = healthUP.instance()
	hUp.connect("healthPickup", world, "OnHealthPickup")
	m.add_child(hUp)
	hUp.position = $Position2D.global_position

func _on_MoveUp_tween_completed(_object, _key):
	moveDown.start()

func _on_MoveDown_tween_completed(_object, _key):
	bouncing = false
