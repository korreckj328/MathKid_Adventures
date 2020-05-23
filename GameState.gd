extends Node

var startingLevel = 1
var numberOfLevels = 3
var currentLevel = 1
var score
var rng = RandomNumberGenerator.new()

var gameScene = "res://Main.tscn"
var titleScene = "res://UI/TitleScreen.tscn"
var gameOverScene = "res://UI/GameOver.tscn"

func _ready():
	score = 0
	rng.randomize()

func GetOperand():
	return rng.randi_range(10,99)

func GetMultiplicationOperand():
	return rng.randi_range(0,9)

func GetOperator():
	return rng.randi_range(0,2)

func restart():
	get_tree().change_scene(gameOverScene)

func nextLevel():
	currentLevel += 1
	if currentLevel > numberOfLevels:
		currentLevel = startingLevel
	var levelNumber = str(currentLevel).pad_zeros(2)
	var scene = "res://Levels/Level%s.tscn" % levelNumber
	return scene

func getScore():
	return score

func setScore(value):
	score = value

func resetScore():
	score = 0






