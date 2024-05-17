extends RigidBody2D

signal reflect_bullet
signal player_died

var yIsLocked: bool
var initialYPos: float
var lives: int

enum color {cyan, magenta}#ADDED enumerator used to denote colors throughout the code. Use these when describing a color of enemy, player or bullet
var shipColor : color = color.cyan #what color the ship currently is

const MAX_ROTATION = PI / 6 # 30 degrees in radians

# Called when the node enters the scene tree for the first time.
func _ready():
	yIsLocked = true
	initialYPos = position.y
	lives = 3

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var mouse_position = get_viewport().get_mouse_position()
	var screen_bounds = get_viewport_rect().size
	
	position.x = clamp(mouse_position.x, 64, screen_bounds.x - 64)
	
	if not yIsLocked:
		position.y = clamp(mouse_position.y, screen_bounds.y - 100, screen_bounds.y)
	
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
#	if "Bullet" in body.name:
#		body.isReflected = true
	pass


func _on_powerup_activate_powerup(powerup):
	print_debug("Yay! I got the %f powerup!" % powerup)


func _on_powerup_activate_curse(curse):
	print_debug("Oh no! I've been cursed with %f!" % curse)


func reset_stats():
	var yIsLocked = true
	position.y = initialYPos
	
	
@export var _on_bullet_hit = func():
	reflect_bullet.emit()
