extends "res://Items/Item.gd"

onready var tween = $Tween

func _on_Item_body_entered(_body):
	# space for specific actions
	if onBoard:
		onBoard = false
		emit_signal("pickup")
		tween.start()

func _ready():
	tween.interpolate_property($Sprite, 'scale', $Sprite.scale, $Sprite.scale * 2, 0.3, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	tween.interpolate_property($Sprite, 'modulate', Color(1,1,1,1), Color(1,1,1,0), 0.3, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)


func _on_Tween_tween_completed(_object, _key):
	queue_free()
