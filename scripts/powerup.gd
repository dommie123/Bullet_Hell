extends Node2D

enum POWER_UP_TYPE {
	MORE_DAMAGE = 1,
	EXTRA_PIERCE = 2,
	EXTRA_MOVE_SPEED = 3,
	REFLECTED_SHOT_SIZE = 4,
	UNLOCK_Y_MOVEMENT = 5,
	SMALL_PLAYER_HITBOX = 6,
	EXTRA_HIT = 7,
}

enum POWER_DOWN_TYPE {
	REVERSE_CONTROLS = 1,
	ENEMY_SPEED = 2,
	ENEMY_INVISIBILITY = 3,
	SCREEN_FLIP = 4,
	ENEMY_SHOT_SPEED = 5
}

signal activate_powerup
signal activate_curse

var currentPowerup: POWER_UP_TYPE
var currentCurse: POWER_DOWN_TYPE

var fallSpeed: float


# Called when the node enters the scene tree for the first time.
func _ready():
	fallSpeed = 100
	
	var rngPowerup = randi_range(1, 7)
	var rngCurse = randi_range(1, 5)
	
	currentPowerup = rngPowerup
	currentCurse = rngCurse


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Make the powerup "fall slowly"
	position.y += fallSpeed * delta


func _on_area_2d_area_entered(area):
	activate_powerup.emit(currentPowerup)
	
	$Area2D.visible = false
	$AnimatedSprite2D.visible = false
	
	$CurseTimer.start()


func _on_curse_timer_timeout():
	activate_curse.emit(currentCurse)
	queue_free()
