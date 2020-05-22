extends Area2D

signal healthPickup

func _ready():
	pass

func _on_HealthUP_body_entered(_body):
	emit_signal("healthPickup")
	queue_free()
