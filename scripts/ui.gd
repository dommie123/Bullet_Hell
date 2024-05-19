extends Control

signal toggle_game_paused
signal new_game_started
signal return_to_main_menu

@export var lifeCountScene: PackedScene

var mainNode: Node2D
var playerNode: Node2D

var lives: int
var level: int
var score: int
var currentPowerup: int
var currentCurse: int
var isPaused: bool

# Called when the node enters the scene tree for the first time.
func _ready():
	mainNode = get_node("/root/Main")
	playerNode = get_node("/root/Main/Player")
	
	if not mainNode or not playerNode:
		assert(false, "Isolated Scene not supported! Please run this in the Main Scene!")
	
	lives = playerNode.lives
	level = mainNode.level
	currentPowerup = playerNode.currentPowerup
	currentCurse = playerNode.currentCurse
	
	score = 0
	isPaused = false
	
	var i = 0
	while i < lives:
		var lifeNode = lifeCountScene.instantiate()
		var initLifeCountPos = Vector2(0, 0)
		
		lifeNode.add_to_group("Life Counters")
		lifeNode.position = Vector2(initLifeCountPos.x + (50 * i), initLifeCountPos.y)
		
		add_child(lifeNode)
		i += 1


func _on_main_level_changed():
	level += 1
	$CanvasLayer/LevelCounter.set_deferred("text", "Lv %s" % level)


func _on_player_ship_lose_life():
	var lifeNodes = get_tree().get_nodes_in_group("Life Counters")
	lifeNodes[lives - 1].queue_free()
	lives -= 1


func _on_main_update_score(points):
	score += points
	$CanvasLayer/ScoreCounter.set_deferred("text", "Score: %s" % score)
	$CanvasLayer/GameOverPanel/FinalScoreLabel.set_deferred("text", "Score: %s" % score)


func _on_resume_button_pressed():
	toggle_game_paused.emit(false)


func _on_main_menu_button_pressed():
	return_to_main_menu.emit()


func _on_pause_button_pressed():
	toggle_game_paused.emit(true)


func _on_play_again_button_pressed():
	new_game_started.emit()
