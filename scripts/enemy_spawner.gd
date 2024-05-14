extends Node2D

@export var enemyScene: PackedScene
@export var spawnOffset: Vector2

@export var enemyCount: int

var canSpawnEnemy: bool
var enemiesSpawned: int

# Called when the node enters the scene tree for the first time.
func _ready():
	canSpawnEnemy = false
	enemiesSpawned = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if canSpawnEnemy and enemyCount > 0:
		print_debug("Spawning enemy...")
		spawnEnemy("Enemy %d".format(enemiesSpawned + 1))


func _on_spawn_timer_timeout():
	canSpawnEnemy = true
	
func spawnEnemy(_name):
	var enemy = enemyScene.instantiate()
	
	enemy.name = _name
	enemy.positionOffset = spawnOffset
	enemy.currentState = 3 # STATE.MOVING_AND_SHOOTING
	
	add_child(enemy)
	
	enemiesSpawned += 1
	enemyCount -= 1
	canSpawnEnemy = false


func _on_kill_timer_timeout():
	queue_free()
