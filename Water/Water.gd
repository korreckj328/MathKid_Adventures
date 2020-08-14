tool
extends Area2D

func _ready():
	update_shader_aspect_ratio()


func update_shader_aspect_ratio():
	$Sprite.material.set_shader_param("spriteScale", $Sprite.scale)


func _on_Sprite_item_rect_changed():
	update_shader_aspect_ratio()
