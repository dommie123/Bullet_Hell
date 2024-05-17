extends RigidBody2D

signal bullet_hit

var speed: float
var damage: int
var pierce: int
var bulletGrace: bool

var cyanBulletTexture : Texture2D
var magentaBulletTexture : Texture2D

enum color {cyan, magenta}#ADDED enumerator used to denote colors throughout the code. Use these when describing a color of enemy or bullet
var bulletColor : color

func _ready():
#	speed = 350
	damage = 1
	pierce = 1
	bulletGrace = false
	linear_velocity = linear_velocity.normalized() * speed
	
	cyanBulletTexture = load("res://assets/Bullets/Cyan Bullet.png")
	magentaBulletTexture = load("res://assets/Bullets/Magenta Bullet.png")
	
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
	
	var playerNode = get_node("/root/Main/Player")
		

func _process(delta):
	pass
	

func _on_screen_exited():
	queue_free()


func _on_body_entered(body):
#	print()
	if "Player" in body.name:
		linear_velocity = linear_velocity.normalized() * speed
#		set_collision_mask_value(3, true)
		set_collision_layer_value(9, true)
#		set_collision_layer_value(2, false)
#		set_collision_mask_value(1, false)

	elif "Enemy" in body.name:
		body.currentState = 3 # STATE.DEAD
		bullet_hit.emit()
		pierce -= 1
	
		if pierce <= 0:
			queue_free()
