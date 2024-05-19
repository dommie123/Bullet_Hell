extends Node2D

@export var bgmName: String
@export var sfxName: String

var bgmIndex: int
var sfxIndex: int

func _ready():
	bgmIndex = AudioServer.get_bus_index(bgmName)
	sfxIndex = AudioServer.get_bus_index(sfxName)
	
	var bgmVolume = AudioServer.get_bus_volume_db(bgmIndex)
	var sfxVolume = AudioServer.get_bus_volume_db(sfxIndex)
	
	$OptionsCanvas/OptionsInterface/BGMVolSlider.set_value_no_signal(db_to_linear(bgmVolume))
	$OptionsCanvas/OptionsInterface/SFXVolSlider.set_value_no_signal(db_to_linear(sfxVolume))

func _on_start_button_pressed():
	get_tree().change_scene_to_file("res://nodes/main.tscn")


func _on_quit_button_pressed():
	get_tree().quit()


func _on_options_button_pressed():
	$TitleCanvas.visible = false
	$OptionsCanvas.visible = true


func _on_back_button_pressed():
	$TitleCanvas.visible = true
	$OptionsCanvas.visible = false


func _on_bgm_vol_slider_value_changed(value):
	AudioServer.set_bus_volume_db(bgmIndex, linear_to_db(value))


func _on_sfx_vol_slider_value_changed(value):
	AudioServer.set_bus_volume_db(sfxIndex, linear_to_db(value))
