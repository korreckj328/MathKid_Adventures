tool
extends Area2D

signal splash

func _ready():
	update_shader_aspect_ratio()


func update_shader_aspect_ratio():
	$Sprite.material.set_shader_param("spriteScale", $Sprite.scale)


func _on_Sprite_item_rect_changed():
	update_shader_aspect_ratio()

func _on_Water_body_entered(body):
	emit_signal("splash")
