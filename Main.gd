extends Node2D

const maximumLevelNumber = 1
const startingLevel = 1

func _ready():
	var levelNumberInteger = GameState.currentLevel
	if levelNumberInteger > maximumLevelNumber:
		levelNumberInteger = startingLevel
		GameState.currentLevel = startingLevel
	var levelNumber = str(levelNumberInteger).pad_zeros(2)
	var path = "res://Levels/Level%s.tscn" % levelNumber
	var map = load(path).instance()
	add_child(map)


