extends MarginContainer

onready var lifeCounter = [$HBoxContainer/LifeCounter/L1,
							$HBoxContainer/LifeCounter/L2,
							$HBoxContainer/LifeCounter/L3]

func onPlayerLifeChanged(value):
	for heart in range(lifeCounter.size()):
		lifeCounter[heart].visible = value > heart

func onScoreChanged(value):
	$HBoxContainer/ScoreLabel.text = str(value)



func _ready():
	pass
