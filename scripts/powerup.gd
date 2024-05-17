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
	ENEMY_SHOT_SPEED = 4
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
	var rngCurse = randi_range(1, 4)
	
	currentPowerup = rngPowerup
	currentCurse = rngCurse
	
	var playerNode = get_node("/root/Main/Player")
	var mainNode = get_node("/root/Main")
#	var cameraNode = get_node("/root/Main/Camera2D")
	
	activate_powerup.connect(playerNode.activate_powerup_callable)	
	activate_curse.connect(playerNode.activate_curse_callable)
	activate_powerup.connect(mainNode.activate_powerup_callable)	
	activate_curse.connect(mainNode.activate_curse_callable)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Make the powerup "fall slowly"
	position.y += fallSpeed * delta


func _on_curse_timer_timeout():
	activate_curse.emit(currentCurse)
	queue_free()


func _on_area_2d_body_entered(body):
	activate_powerup.emit(currentPowerup)
	
	$Area2D/CollisionShape2D.set_deferred("disabled", true)
	$AnimatedSprite2D.visible = false
	
	$CurseTimer.start()
