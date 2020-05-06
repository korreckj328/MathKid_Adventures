extends Area2D

signal pickup

func init(pos):
	position = pos

func _on_Item_body_entered(_body):
	emit_signal("pickup")
	queue_free()




















