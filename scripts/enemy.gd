extends Node2D

enum STATE {
	MOVING,
	SHOOTING,
	DEAD
}

signal enemy_fled

@export var bullet_scene: PackedScene

var angularVelocity = (3 * PI) / 4
var timePassed = 0
var currentState = STATE.MOVING
var canShoot = true
var functions

const timeMultiplier = 100
const Functions = preload("res://scripts/functions.gd")

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite2D.play("default")
	functions = Functions.new()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	timePassed += timeMultiplier * delta
	
#	position.x += speed * delta
#	position.y = calc_y(position.x)
	position = calc_pos(timePassed)
	
	$BulletLauncher.rotation = 2 * PI + functions.ANGULAR_FUNCTIONS[0].call(timePassed)
	
	if canShoot:
		shoot()
		canShoot = false
		$BulletTimer.start()
		

func calc_pos(t):
#	return functions.MATH_FUNCTIONS[0].call(t)
	return Vector2(100, 100)
	
	
func shoot():
	var bullet = bullet_scene.instantiate()
	
	bullet.position = position
	var direction = $BulletLauncher.rotation
	
	# Choose the velocity for the bullet
	var velocity = Vector2(0, 350.0)
	bullet.linear_velocity = velocity.rotated(direction)
	
	add_sibling(bullet)
	

func _on_visible_on_screen_notifier_2d_screen_exited():
	enemy_fled.emit()
	queue_free()
	

func _on_timer_timeout():
	canShoot = true
