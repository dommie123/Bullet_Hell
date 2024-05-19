extends RigidBody2D

signal bullet_hit

var speed: float
var damage: int
var pierce: int
var bulletGrace: bool

var cyanBulletTexture : Texture2D 
var magentaBulletTexture : Texture2D

enum color {cyan = 1, magenta = 2}#enumerator used to denote colors throughout the code. Use these when describing a color of enemy or bullet
@export var bulletColor : color

func _ready():
#	speed = 350
	damage = 1
	pierce = 1
	bulletGrace = false
	linear_velocity = linear_velocity.normalized() * speed
	
	cyanBulletTexture = preload("res://assets/Bullets/Cyan Bullet.png")
	magentaBulletTexture = preload("res://assets/Bullets/Magenta Bullet.png")
	
	if bulletColor == color.cyan:
		#print("CYAN")
		set_collision_layer_value(7, true)
		set_collision_layer_value(8, false)
		set_collision_mask_value(3, true)
		set_collision_mask_value(4, false)
		$Icon.texture = cyanBulletTexture
		
	elif bulletColor == color.magenta:
		#print("MAGENTA")
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
	if "Player" in body.name and "Ship" not in body.name:
		linear_velocity = linear_velocity.normalized() * speed
		if bulletColor == color.cyan:
			#print("CYAN REFLECTED")
			set_collision_layer_value(7, false)
			set_collision_layer_value(8, false)
			set_collision_layer_value(9, true)
			
			set_collision_mask_value(3, false)
			set_collision_mask_value(4, false)
			set_collision_mask_value(6, true)
			set_collision_mask_value(12, true)
			set_collision_mask_value(14, true)
			
		elif bulletColor == color.magenta:
			#print("MAGENTA REFLECTED")
			set_collision_layer_value(7, false)
			set_collision_layer_value(8, false)
			set_collision_layer_value(10, true)
			
			set_collision_mask_value(3, false)
			set_collision_mask_value(4, false)
			set_collision_mask_value(5, true)
			set_collision_mask_value(11, true)
			set_collision_mask_value(13, true)
	elif "PlayerShip" in body.name:
		body.bullet_hit_callable.call(body)
		queue_free()
	elif "Enemy" in body.name:
		body.currentState = 3 # STATE.DEAD
		bullet_hit.emit()
		pierce -= 1
	
		if pierce <= 0:
			queue_free()
	elif "Head" in body.name or "Segment" in body.name:
		queue_free()


func _on_kill_timer_timeout():
	queue_free()
