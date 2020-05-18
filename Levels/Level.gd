extends Node2D

signal scoreChanged
onready var slimes = $Enemies.get_children()
onready var platforms = $Platforms
onready var coins = $Coins
var BronzeCoin = preload("res://Items/Coins/Bronze/BronzeCoin.tscn")
var score


func _ready():
	score = GameState.score
	coins.hide()
	$Male.start($PlayerStart.position)
	setCameraLimits()
	setPlayerLimits()
	spawnCoins()
	$Male.connect("lifeChanged", $CanvasLayer/HUD, "onPlayerLifeChanged")
	connect("scoreChanged", $CanvasLayer/HUD, "onScoreChanged")
	emit_signal("scoreChanged", score)
	var mapSize = $World.get_used_rect()
	var cellSize = $World.cell_size
	var mapTop = (mapSize.position.y + 800)
	var mapBottom = (mapSize.end.y + 5) * cellSize.y
	for slime in slimes:
		slime.SetMapBottom(mapBottom)
	if platforms.get_child_count() != 0:
		for platform in platforms.get_children():
			platform.SetMapTop(mapTop)
			platform.SetMapBottom(mapBottom)
	$Male/GoSound.play()
	$Male/Music.play()

func setCameraLimits():
	var mapSize = $World.get_used_rect()
	var cellSize = $World.cell_size
	$Male/Camera2D.limit_left = (mapSize.position.x + 11) * cellSize.x
	$Male/Camera2D.limit_right = (mapSize.end.x + 10) * cellSize.x
	$Male/Camera2D.limit_top = (mapSize.position.y - 100) * cellSize.y
	$Male/Camera2D.limit_bottom = (mapSize.end.y + 10) * cellSize.y

func setPlayerLimits():
	var mapSize = $World.get_used_rect()
	var cellSize = $World.cell_size
	var mapBottom = (mapSize.end.y + 5) * cellSize.y
	$Male.SetMapBottom(mapBottom)

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
	GameState.score = score
	$Male.PlayCoinSound()
	emit_signal("scoreChanged", score)

func _on_Male_dead():
	GameState.score = 0
	GameState.restart()

func _on_BlueFlag_flagReached():
	var map = GameState.nextLevel()
	get_tree().change_scene(map)

