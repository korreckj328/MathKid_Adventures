extends Area2D

signal pickup

var onBoard

func init(pos):
	position = pos
	onBoard = true

func _on_Item_body_entered(_body):
	if onBoard:
		onBoard = false
		emit_signal("pickup")
		queue_free()




















