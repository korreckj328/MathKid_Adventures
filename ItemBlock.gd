extends KinematicBody2D

export (int) var bumpVelocity
export (int) var gravity

var healthUP = preload("res://Items/HealthUP/HealthUP.tscn")

enum {IDLE, BOUNCE}

signal spawnItem

var velocity = Vector2()
var initialPosition
var state
var performBounce

func _ready():
	velocity = Vector2(0,0)
	state = IDLE
	performBounce = false

func init(pos):
	position = pos
	initialPosition = pos

func bounceUpward():
	if state == IDLE:
		state = BOUNCE
		performBounce = true

func _physics_process(delta):
	if state == BOUNCE:
		if performBounce:
			velocity.y -= bumpVelocity
			performBounce = false
			spawnItem()
		velocity.y += gravity
		var collision = move_and_collide(velocity * delta)
		if position.y >= initialPosition.y:
			velocity = Vector2(0,0)
			position = initialPosition
			state = IDLE

func spawnItem():
	var m = get_parent().get_parent()
	var world = get_parent()
	var hUp = healthUP.instance()
	hUp.connect("healthPickup", world, "OnHealthPickup")
	m.add_child(hUp)
	hUp.position = $Position2D.global_position














