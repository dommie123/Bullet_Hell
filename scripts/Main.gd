extends Node2D

signal level_changed
signal phase_changed

@export var enemySpawnerScene: PackedScene

@export var phase: int

var level: int
var maxEnemiesPerSpawner: int
var currentEnemiesPerSpawner: int
var active_enemies: int
var enemiesFled: int
var currentSpawners: int
var activeSpawners: int
var boss_active: bool
var game_started: bool
var canSpawnEnemySpawner: bool

const Functions = preload("res://scripts/functions.gd")

# Called when the node enters the scene tree for the first time.
func _ready():
	level = 1
	phase = 1
	maxEnemiesPerSpawner = 20
	currentEnemiesPerSpawner = 5
	currentSpawners = 2
	activeSpawners = currentSpawners
	active_enemies = currentEnemiesPerSpawner * currentSpawners
	enemiesFled = 0
	game_started = false
	boss_active = false
	canSpawnEnemySpawner = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if canSpawnEnemySpawner and activeSpawners > 0:
		spawn_enemy_spawner(activeSpawners % 2 > 0)
	pass
		

@export var enemy_fled_callable = func():
	_on_enemy_enemy_fled()
	
@export var enemy_killed_callable = func():
	_on_enemy_enemy_killed()

func _on_enemy_enemy_fled():
	enemiesFled += 1
	
	enemy_disappear_routine()

# TODO on boss defeated, increase level and set boss active to false.

func _on_enemy_enemy_killed():
	enemy_disappear_routine()
	

func enemy_disappear_routine():
	active_enemies -= 1
	
	if active_enemies == 0 and not boss_active:
		var enemiesToAdd = enemiesFled / currentSpawners
		currentEnemiesPerSpawner += enemiesToAdd
		
		if currentEnemiesPerSpawner > maxEnemiesPerSpawner:
			currentEnemiesPerSpawner -= currentEnemiesPerSpawner % maxEnemiesPerSpawner
		
		enemiesFled = 0
		activeSpawners = currentSpawners + 1
		currentSpawners = activeSpawners 
		active_enemies = currentEnemiesPerSpawner * activeSpawners
		
		phase += 1
		phase_changed.emit(phase)
		print("No more enemies! Initiate phase %d!".format(phase))
		
		if phase % 5 == 0:
			boss_active = true
			active_enemies = 0
			activeSpawners = 0
			currentSpawners -= 1
			
			
func spawn_enemy_spawner(spawnToLeft = false):
	var enemySpawner = enemySpawnerScene.instantiate()
	
	if not spawnToLeft:
		enemySpawner.position.x = randf_range(150, 250)
		enemySpawner.position.y = -50
	else:
		enemySpawner.position.x = -50
		enemySpawner.position.y = randf_range(150, 700)
		
	enemySpawner.enemyCount = currentEnemiesPerSpawner
	enemySpawner.funcIndex = phase
	
	add_child(enemySpawner)
	activeSpawners -= 1
	canSpawnEnemySpawner = false
	
	
func _on_enemy_spawner_timer_timeout():
	canSpawnEnemySpawner = true
