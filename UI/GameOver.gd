extends Control

var operandOne
var operandTwo
var operator
var correctAnswer
var userAnswer

func _ready():
	operandOne = GameState.GetOperand()
	operandTwo = GameState.GetOperand()
	if operandOne < operandTwo:
		var temp = operandOne
		operandOne = operandTwo
		operandTwo = temp
	operator = GameState.GetOperator()
	match operator:
		0:
			operator = "+"
			correctAnswer = operandOne + operandTwo
		1:
			operator = "-"
			correctAnswer = operandOne - operandTwo
		2:
			operator = "X"
			correctAnswer = operandOne * operandTwo
	$Operand1.text = str(operandOne)
	$Operand2.text = str(operandTwo)
	$Operator.text = operator
	


func _on_GoButton_pressed():
	userAnswer = $Answer.text
	if userAnswer == "":
		return
	
	#finally going to move to the next scene
	var levelNumberInteger = GameState.currentLevel
	var levelNumber = str(levelNumberInteger).pad_zeros(2)
	var scene = "res://Levels/Level%s.tscn" % levelNumber
	get_tree().change_scene(scene)


func _on_ExitButton_pressed():
	get_tree().change_scene("res://UI/TitleScreen.tscn")

