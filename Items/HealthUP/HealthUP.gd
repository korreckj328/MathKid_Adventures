extends Area2D

signal healthPickup

var onBoard
onready var pickUpTween = $PickupTween
onready var fadeIn = $Fadein

func _ready():
	onBoard = true
	pickUpTween.interpolate_property($Sprite, 'scale', $Sprite.scale, $Sprite.scale * 3, 0.3, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	pickUpTween.interpolate_property($Sprite, 'modulate', Color(1,1,1,1), Color(1,1,1,0), 0.3, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	fadeIn.interpolate_property($Sprite, 'scale', $Sprite.scale / 4, $Sprite.scale, 0.3, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	fadeIn.interpolate_property($Sprite, 'modulate', Color(1,1,1,0), Color(1,1,1,1), 0.3, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	fadeIn.start()

func _on_HealthUP_body_entered(_body):
	if onBoard:
		$Pickup.play()
		emit_signal("healthPickup")
		pickUpTween.start()


func _on_Tween_tween_completed(_object, _key):
	queue_free()
