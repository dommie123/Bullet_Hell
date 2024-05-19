extends Node2D

signal level_changed
signal phase_changed
signal update_score

@export var enemySpawnerScene: PackedScene
@export var bossScene: PackedScene

@export var phase: int

var level: int
var maxEnemiesPerSpawner: int
var currentEnemiesPerSpawner: int
var active_enemies: int
var enemiesFled: int
var currentSpawners: int
var activeSpawners: int
var currentPowerup: int
var currentCurse: int
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
	currentPowerup = 0
	currentCurse = 0
	game_started = false
	boss_active = false
	canSpawnEnemySpawner = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# If there's more than 0 bullets on-screen, wait until there are 0 bullets.
	var bullets = get_tree().get_nodes_in_group("Bullets")
	if bullets.size() > 0 and boss_active:
		return
	
	if boss_active and not get_node("/root/Main/DeBugger"):
		spawn_boss()
	elif canSpawnEnemySpawner and activeSpawners > 0 and not boss_active:
		spawn_enemy_spawner(activeSpawners % 2 > 0)

		

@export var enemy_fled_callable = func():
	_on_enemy_enemy_fled()
	
@export var enemy_killed_callable = func():
	_on_enemy_enemy_killed()
	
@export var activate_powerup_callable = func(powerup):
	_on_powerup_activate_powerup(powerup)

@export var activate_curse_callable = func(curse):
	_on_powerup_activate_curse(curse)
	
@export var boss_defeated_callable = func():
	_on_boss_defeated()

func _on_enemy_enemy_fled():
	enemiesFled += 1
	
	enemy_disappear_routine()

# TODO on boss defeated, increase level and set boss active to false.
func _on_boss_defeated():
	boss_active = false
	update_score.emit(10000)
	
	active_enemies += 1
	enemy_disappear_routine()

func _on_enemy_enemy_killed():
	update_score.emit(100)
	
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
		enemySpawner.position.y = randf_range(150, 500)
		
	enemySpawner.enemyCount = currentEnemiesPerSpawner
	enemySpawner.funcIndex = phase
	enemySpawner.currentCurse = currentCurse
	
	add_child(enemySpawner)
	activeSpawners -= 1
	canSpawnEnemySpawner = false
	
	
func _on_enemy_spawner_timer_timeout():
	canSpawnEnemySpawner = true
	

func _on_powerup_activate_powerup(powerup):
	currentPowerup = powerup
	$PlayerShip.update_powerup(powerup)


func _on_powerup_activate_curse(curse):
	currentCurse = curse
	
	var enemySpawners = get_tree().get_nodes_in_group("EnemySpawners")
	var enemies = get_tree().get_nodes_in_group("Enemies")
	
	for spawner in enemySpawners:
		spawner.set_deferred("currentCurse", curse)
	
	for enemy in enemies:
		enemy.set_deferred("currentCurse", curse)
		

func _on_player_deactivate_curse():
	currentCurse = 0
	
	var enemySpawners = get_tree().get_nodes_in_group("EnemySpawners")
	var enemies = get_tree().get_nodes_in_group("Enemies")
	
	for spawner in enemySpawners:
		spawner.set_deferred("currentCurse", 0)
	
	for enemy in enemies:
		enemy.set_deferred("currentCurse", 0)
#

func _on_player_deactivate_powerup():
	currentPowerup = 0
	$PlayerShip.update_powerup()


func spawn_boss():
	var boss = bossScene.instantiate()
	var middleOfViewport = get_viewport_rect().size.x / 2
	
	boss.position = Vector2(middleOfViewport / 2, 100)
	
	add_child(boss)


func _on_ui_toggle_game_paused(paused):
	$UI/CanvasLayer/PauseMenu.set_deferred("visible", paused)
	get_tree().paused = paused


func new_game():
	if get_tree().paused:
		get_tree().paused = false
		
	get_tree().reload_current_scene()


func _on_ui_new_game_started():
	new_game()


func _on_player_player_died():
	$UI/CanvasLayer/GameOverPanel.set_deferred("visible", true)
	get_tree().paused = true
