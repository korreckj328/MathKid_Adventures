extends Node

var numberOfLevels = 1
var currentLevel = 1
var rng = RandomNumberGenerator.new()

var gameScene = "res://Main.tscn"
var titleScene = "res://UI/TitleScreen.tscn"
var gameOverScene = "res://UI/GameOver.tscn"

func _ready():
	rng.randomize()

func GetOperand():
	return rng.randi_range(10,99)

func GetOperator():
	return rng.randi_range(0,2)

func restart():
	get_tree().change_scene(gameOverScene)

func nextLevel():
	currentLevel += 1
	if currentLevel > numberOfLevels:
		get_tree().reload_current_scene()







