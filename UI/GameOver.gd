extends Control

enum Operators {ADD, SUBTRACT, MULTIPLY}

var operandOne
var operandTwo
var operator
var correctAnswer
var userAnswer

func _ready():
	$GoButton.disabled = true
	$TryAgainButton.disabled = true
	$GoButton.visible = false
	$TryAgainButton.visible = false
	SetQuestion()
	$Answer.grab_focus()

func SetQuestion():
	operandOne = GameState.GetOperand()
	
	
	operator = GameState.GetOperator()
	match operator:
		Operators.ADD:
			operator = "+"
			operandTwo = GameState.GetOperand()
			correctAnswer = operandOne + operandTwo
		Operators.SUBTRACT:
			operator = "-"
			operandTwo = GameState.GetOperand()
			if operandOne < operandTwo:
				var temp = operandOne
				operandOne = operandTwo
				operandTwo = temp
			correctAnswer = operandOne - operandTwo
		Operators.MULTIPLY:
			operator = "x"
			operandTwo = GameState.GetMultiplicationOperand()
			correctAnswer = operandOne * operandTwo
	
	$Operand1.text = str(operandOne)
	$Operand2.text = str(operandTwo)
	$Operator.text = operator
	$Answer.clear()


func _on_CheckButton_pressed():
	userAnswer = $Answer.text
	
	if userAnswer == "":
		return
	
	for character in userAnswer:
		if character in ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]:
			pass
		else:
			$Message.text = "I'm sorry the answer\nmust be a number"
			$Answer.clear()
			return
	
	if userAnswer != str(correctAnswer):
		$Incorrect.play()
		$Message.text = "I'm sorry the answer\nis"
		$Answer.text = str(correctAnswer)
		$Answer.editable = false
		$CheckButton.disabled = true
		$CheckButton.visible = false
		$TryAgainButton.disabled = false
		$TryAgainButton.visible = true
		return
	
	$Correct.play()
	$Message.text = "Correct!"
	$Answer.editable = false
	$CheckButton.disabled = true
	$CheckButton.visible = false
	$GoButton.disabled = false
	$GoButton.visible = true
	


func _on_ExitButton_pressed():
	get_tree().change_scene("res://UI/TitleScreen.tscn")



func _on_TryAgainButton_pressed():
	$Message.text = "Here's another question"
	SetQuestion()
	$Answer.editable = true
	$CheckButton.disabled = false
	$CheckButton.visible = true
	$TryAgainButton.disabled = true
	$TryAgainButton.visible = false
	$Answer.grab_focus()

func _on_GoButton_pressed():
	var levelNumberInteger = GameState.currentLevel
	var levelNumber = str(levelNumberInteger).pad_zeros(2)
	var scene = "res://Levels/Level%s.tscn" % levelNumber
	get_tree().change_scene(scene)
