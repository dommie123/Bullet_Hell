extends RigidBody2D

signal reflect_bullet
signal player_died
signal deactivate_powerup
signal deactivate_curse

var yIsLocked: bool
var controlsReversed: bool
var initialYPos: float
var lives: int
var currentPowerup: int
var currentCurse: int

enum color {cyan, magenta}#ADDED enumerator used to denote colors throughout the code. Use these when describing a color of enemy, player or bullet
var shipColor : color = color.cyan #what color the ship currently is

const MAX_ROTATION = PI / 6 # 30 degrees in radians

# Called when the node enters the scene tree for the first time.
func _ready():
	yIsLocked = true
	controlsReversed = false
	currentPowerup = 0
	currentCurse = 0
	initialYPos = position.y
	lives = 3

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var mouse_position = get_viewport().get_mouse_position()
	var screen_bounds = get_viewport_rect().size
	
	var playerPosX = -mouse_position.x + screen_bounds.x if controlsReversed else mouse_position.x
	var playerPosY = -mouse_position.y + screen_bounds.y if controlsReversed else mouse_position.y
	
	position.x = clamp(playerPosX, 64, screen_bounds.x - 64)
	
	if not yIsLocked:
		position.y = clamp(playerPosY, screen_bounds.y - 100, screen_bounds.y)
	
	if Input.is_action_pressed("rotate_left") and Input.is_action_pressed("rotate_right"):
		rotate(0)
	elif Input.is_action_pressed("rotate_left") and rotation > -MAX_ROTATION:
		rotate(-(PI / 24))
	elif Input.is_action_pressed("rotate_right") and rotation < MAX_ROTATION:
		rotate(PI / 24)
	if Input.is_action_just_pressed("shift"):
		Shift()


func Shift(): #ADDED funciton that lets the player shift colors (space bar)
	print(shipColor)
	print("SHIFT")
	if shipColor == color.cyan:
		shipColor = color.magenta
		$AnimatedSprite2D.play("PaddleShiftCyanMagenta")
		set_collision_layer_value(1,false)#sets ship and paddle collision cyan to false
		set_collision_layer_value(3,false)
		
		set_collision_layer_value(2,true)#sets ship and paddle collision magenta to true
		set_collision_layer_value(4,true)
		
		set_collision_mask_value(5,false) #sets enemy collision
		set_collision_mask_value(6,true)
		
		set_collision_mask_value(7,false) #sets bullet collision
		set_collision_mask_value(8,true)
	
	elif shipColor == color.magenta:
		shipColor = color.cyan
		$AnimatedSprite2D.play("PaddleShiftMagentaCyan")
		set_collision_layer_value(2,false)#sets ship and paddle collision magenta to false
		set_collision_layer_value(4,false)
		
		set_collision_layer_value(1,true)#sets ship and paddle collision cyan to true
		set_collision_layer_value(3,true)
		
		set_collision_mask_value(5,true) #sets enemy collision
		set_collision_mask_value(6,false)
		
		set_collision_mask_value(7,true) #sets bullet collision
		set_collision_mask_value(8,false)
		
	#TO ADD: Player and paddle animation when shifting colors
	pass

func _on_body_entered(body):
	# TODO reflect ONLY when color is same as bullet
	if "Bullet" in body.name:
		update_bullet(body)


@export var activate_powerup_callable = func(powerup):
	_on_powerup_activate_powerup(powerup)

@export var activate_curse_callable = func(curse):
	_on_powerup_activate_curse(curse)
	
@export var _on_bullet_hit = func():
	reflect_bullet.emit()

func _on_powerup_activate_powerup(powerup):
	currentPowerup = powerup
	
	if not $PowerupTimer.is_stopped():
		$PowerupTimer.stop()
	
	if not $CurseTimer.is_stopped():
		$CurseTimer.stop()
		
	$PowerupTimer.start()
	
	print("Current Powerup: %s" % currentPowerup)
	
	if currentPowerup == 3:
		# TODO increase player ship speed
		pass
	elif currentPowerup == 5:
		yIsLocked = false
	elif currentPowerup == 7:
		lives += 1


func _on_powerup_activate_curse(curse):
	currentCurse = curse
	$CurseTimer.start()
	
	print("Current Curse: %s" % currentCurse)
	
	if currentCurse == 1:
		controlsReversed = true


func reset_stats():
	currentPowerup = 0
	currentCurse = 0
	
	yIsLocked = true
	controlsReversed = false
	position.y = initialYPos
	
	
func update_bullet(bullet):
	if currentPowerup == 1:
		bullet.damage += 1
	elif currentPowerup == 2:
		bullet.pierce += 1
	elif currentPowerup == 4:
##		bullet.scale *= 2 
#		bullet.global_scale(Vector2(2, 2))
##		bullet.get_child(1).set_deferred("scale", Vector2(2, 2))
#		print("Scale: (%s, %s)" % [bullet.scale.x, bullet.scale.y])
		pass
	

func _on_curse_timer_timeout():
	reset_stats()
	deactivate_powerup.emit()
	deactivate_curse.emit()
	print("Stats Reset")


func _on_player_ship_lose_life():
	print("Ouch!")
	lives -= 1
	
	# If the player is out of lives, it's game over.
	if lives == 0:
		print("I'm dead!")
		player_died.emit()
		queue_free()
