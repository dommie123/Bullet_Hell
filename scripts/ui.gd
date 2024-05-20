extends Control

signal toggle_game_paused
signal new_game_started
signal return_to_main_menu

@export var lifeCountScene: PackedScene
@export var bgmName: String
@export var sfxName: String

@onready var SFX_comfirm = $SFX_UI_comfirm

const Constants = preload("res://scripts/consts.gd")

var mainNode: Node2D
var playerNode: Node2D
var pwrIcons
var curseIcons

var lives: int
var level: int
var score: int
var currentPowerup: int
var currentCurse: int
var bgmIndex: int
var sfxIndex: int
var isPaused: bool

# Called when the node enters the scene tree for the first time.
func _ready():
	mainNode = get_node("/root/Main")
	playerNode = get_node("/root/Main/Player")
	pwrIcons = Constants.new().POWERUP_ICONS
	curseIcons = Constants.new().CURSE_ICONS
	
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
		
	bgmIndex = AudioServer.get_bus_index(bgmName)
	sfxIndex = AudioServer.get_bus_index(sfxName)
	
	var bgmVolume = AudioServer.get_bus_volume_db(bgmIndex)
	var sfxVolume = AudioServer.get_bus_volume_db(sfxIndex)
	
	$CanvasLayer/OptionsInterface/BGMVolSlider.set_value_no_signal(db_to_linear(bgmVolume))
	$CanvasLayer/OptionsInterface/SFXVolSlider.set_value_no_signal(db_to_linear(sfxVolume))


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
	SFX_comfirm.play()
	toggle_game_paused.emit(false)


func _on_main_menu_button_pressed():
	SFX_comfirm.play()
	return_to_main_menu.emit()


func _on_pause_button_pressed():
	SFX_comfirm.play()
	toggle_game_paused.emit(true)


func _on_play_again_button_pressed():
	SFX_comfirm.play()
	new_game_started.emit()


func _on_player_update_curse(curse):
	$CanvasLayer/CurseContainer/CurseIcon.visible = true
	$CanvasLayer/CurseContainer/CurseIcon.set_deferred("texture", curseIcons[curse - 1])


func _on_player_update_powerup(powerup):
	$CanvasLayer/PowerupContainer/PowerupIcon.visible = true
	$CanvasLayer/PowerupContainer/PowerupIcon.set_deferred("texture", pwrIcons[powerup - 1])


func _on_player_deactivate_curse():
	$CanvasLayer/CurseContainer/CurseIcon.visible = false


func _on_player_deactivate_powerup():
	$CanvasLayer/PowerupContainer/PowerupIcon.visible = false


func _on_options_button_pressed():
	SFX_comfirm.play()
	$CanvasLayer/OptionsInterface.visible = true
	$CanvasLayer/PauseMenu.visible = false


func _on_back_button_pressed():
	SFX_comfirm.play()
	$CanvasLayer/OptionsInterface.visible = false
	$CanvasLayer/PauseMenu.visible = true
	
	
func _on_bgm_vol_slider_value_changed(value):
	AudioServer.set_bus_volume_db(bgmIndex, linear_to_db(value))


func _on_sfx_vol_slider_value_changed(value):
	AudioServer.set_bus_volume_db(sfxIndex, linear_to_db(value))
