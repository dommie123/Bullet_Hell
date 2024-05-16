extends Node2D

signal level_changed
signal phase_changed

@export var enemySpawnerScene: PackedScene

@export var phase: int

var level: int
var max_enemies: int
var current_enemies: int
var active_enemies: int
var boss_active: bool
var game_started: bool

const Functions = preload("res://scripts/functions.gd")

# Called when the node enters the scene tree for the first time.
func _ready():
	level = 0
	phase = 1
	max_enemies = 20
	current_enemies = 5
	active_enemies = current_enemies
	game_started = false
	boss_active = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
#	print(current_enemies)
	pass

func _on_enemy_enemy_fled():
	if current_enemies < max_enemies:
		current_enemies += 1
	
	enemy_disappear_routine()

# TODO on boss defeated, increase level and set boss active to false.

func _on_enemy_enemy_killed():
	enemy_disappear_routine()

func enemy_disappear_routine():
	active_enemies -= 1
	if active_enemies == 0 and not boss_active:
		active_enemies = current_enemies
		phase += 1
		phase_changed.emit(phase)
		
		if phase == 5:
			boss_active = true
			active_enemies = 0
			
func spawn_enemy_spawner():
	# TODO spawn enemy spawner at somewhat random location just offscreen
	pass
