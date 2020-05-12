extends Node

var numberOfLevels = 1
var currentLevel = 1

var gameScene = "res://Main.tscn"
var titleScene = "res://UI/TitleScreen.tscn"

func restart():
	get_tree().change_scene(titleScene)

func nextLevel():
	currentLevel += 1
	if currentLevel >= numberOfLevels:
		get_tree().reload_current_scene()







