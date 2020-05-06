extends Node2D

signal scoreChanged

onready var coins = $Coins
var BronzeCoin = preload("res://Items/Coins/Bronze/BronzeCoin.tscn")
var score


func _ready():
	score = 0
	coins.hide()
	$Male.start($PlayerStart.position)
	setCameraLimits()
	spawnCoins()


func setCameraLimits():
	var mapSize = $World.get_used_rect()
	var cellSize = $World.cell_size
	$Male/Camera2D.limit_left = (mapSize.position.x - 5) * cellSize.x
	$Male/Camera2D.limit_right = (mapSize.end.x + 5) * cellSize.x
	$Male/Camera2D.limit_top = (mapSize.position.y - 5) * cellSize.y
	$Male/Camera2D.limit_bottom = (mapSize.end.y + 5) * cellSize.y

func spawnCoins():
	for cell in coins.get_used_cells():
		var id = coins.get_cellv(cell)
		var type = coins.tile_set.tile_get_name(id)
		match type:
			"coinBronze.png 0":
				var c = BronzeCoin.instance()
				var pos = coins.map_to_world(cell)
				c.init(pos + coins.cell_size / 2)
				add_child(c)
				c.connect("pickup", self, "onCoinPickup")

func onCoinPickup():
	score += 1
	emit_signal("scoreChanged")
			






