extends Node2D

@export var enemyScene: PackedScene
@export var spawnOffset: Vector2

@export var enemyCount: int
@export var funcIndex: int

var canSpawnEnemy: bool
var enemiesSpawned: int
var currentCurse: int

# Called when the node enters the scene tree for the first time.
func _ready():
	canSpawnEnemy = false
	enemiesSpawned = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if canSpawnEnemy and enemyCount > 0:
		spawn_enemy("Enemy %s" % (enemiesSpawned + 1))


func _on_spawn_timer_timeout():
	canSpawnEnemy = true

	
func spawn_enemy(_name):
	var enemy = enemyScene.instantiate()
	var xYInverted = false
	if position.y < 0:
		xYInverted = true
	
	enemy.name = _name
	enemy.positionOffset = spawnOffset
	enemy.currentState = 3 # STATE.MOVING_AND_SHOOTING
	enemy.funcIndex = funcIndex
	enemy.xYInverted = xYInverted
	enemy = curse_enemy(enemy)
	
	add_child(enemy)
	
	enemiesSpawned += 1
	enemyCount -= 1
	canSpawnEnemy = false


func curse_enemy(enemy):
	if currentCurse == 2:
		enemy.timeMultiplier = 200
	elif currentCurse == 3:
		enemy.get_node("AnimatedSprite2D").visible = false
	elif currentCurse == 4:
		enemy.bulletLaunchSpeedMultiplier = 2
	
	return enemy
