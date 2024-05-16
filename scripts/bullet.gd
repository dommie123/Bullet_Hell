extends RigidBody2D

#@export var isMagenta: bool

var damage: int
var pierce: int
var bulletGrace: bool

var cyanBulletTexture : Texture2D
var magentaBulletTexture : Texture2D

enum color {cyan, magenta}#ADDED enumerator used to denote colors throughout the code. Use these when describing a color of enemy or bullet
var bulletColor : color

func _ready():
	damage = 1
	pierce = 1
	bulletGrace = false
	
	cyanBulletTexture = load("res://assets/Cyan Bullet.png")
	magentaBulletTexture = load("res://assets/Magenta Bullet.png")
	
	if bulletColor == color.cyan:
		set_collision_layer_value(7, true)
		set_collision_layer_value(8, false)
		set_collision_mask_value(3, true)
		set_collision_mask_value(4, false)
		$Icon.texture = cyanBulletTexture
		
	elif bulletColor == color.magenta:
		set_collision_layer_value(7, false)
		set_collision_layer_value(8, true)
		set_collision_mask_value(3, false)
		set_collision_mask_value(4, true)
		$Icon.texture = magentaBulletTexture
		

func _process(delta):
	pass


func _on_screen_exited():
	queue_free()


func _on_body_entered(body):
	pierce -= 1
	
	if pierce == 0:
		queue_free()
	else:
		bulletGrace = true


func _on_body_exited(body):
	bulletGrace = false
