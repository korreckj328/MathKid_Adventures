extends Node2D

signal scoreChanged
onready var slimes = $Enemies.get_children()
onready var platforms = $Platforms
onready var coins = $Coins
var BronzeCoin = preload("res://Items/Coins/Bronze/BronzeCoin.tscn")
var itemBlock = preload("res://Items/ItemBlock/ItemBlock.tscn")
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
	var backgroundPosition = $ParallaxBackground/BackLayer/Sprite.global_position
	var backgroundScale = $ParallaxBackground/BackLayer/Sprite.transform.get_scale()
	
	
	var backgroundSize = $ParallaxBackground/BackLayer/Sprite.get_rect().size * backgroundScale
	var backgroundRect = Rect2(backgroundPosition, backgroundSize)
	
	$Male/Camera2D.limit_left = (mapSize.position.x + 11) * cellSize.x
	$Male/Camera2D.limit_right = (mapSize.end.x + 10) * cellSize.x
	$Male/Camera2D.limit_top = backgroundRect.position.y
	$Male/Camera2D.limit_bottom = backgroundRect.end.y - 100
	
	print(backgroundRect.position.y)
	print(backgroundRect.end.y)

func setPlayerLimits():
	var mapSize = $World.get_used_rect()
	var cellSize = $World.cell_size
	var mapBottom = (mapSize.end.y + 5) * cellSize.y
	$Male.SetMapBottom(mapBottom)

func spawnCoins():
	for cell in coins.get_used_cells():
		var id = coins.get_cellv(cell)
		var type = coins.tile_set.tile_get_name(id)
		# print(type)
		match type:
			"coinBronze.png 0":
				var c = BronzeCoin.instance()
				var pos = coins.map_to_world(cell)
				c.init(pos + coins.cell_size / 2)
				add_child(c)
				c.connect("pickup", self, "onCoinPickup")
			"boxItem.png 8":
				var b = itemBlock.instance()
				var pos = coins.map_to_world(cell)
				b.init(pos + coins.cell_size / 2)
				add_child(b)
				b.connect("spawnItem", self, "spawnPowerup")

func spawnPowerup():
	pass

func OnHealthPickup():
	$Male.heal()

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

