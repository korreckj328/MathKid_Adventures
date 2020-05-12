extends Node2D



func _ready():
	var levelNumber = str(GameState.currentLevel).pad_zeros(2)
	var path = "res://Levels/Level%s.tscn" % levelNumber
	var map = load(path).instance()
	add_child(map)


