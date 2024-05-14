extends Node2D

enum STATE {
	MOVING,
	SHOOTING,
	MOVING_AND_SHOOTING,
	DEAD
}

signal enemy_fled
signal enemy_killed

@export var bullet_scene: PackedScene
@export var currentState: STATE

@export var positionOffset: float

var functions: Functions

var angularVelocity: float
var timePassed: float
var canShoot: bool
var funcIndex: int

const timeMultiplier = 100
const Functions = preload("res://scripts/functions.gd")

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite2D.play("default")
	functions = Functions.new()
	
	angularVelocity = (3 * PI) / 4
	positionOffset = 0
	timePassed = positionOffset
	canShoot = true
	funcIndex = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if currentState == STATE.DEAD:
		enemy_killed.emit()
		queue_free()
	
	timePassed += timeMultiplier * delta
	
	if currentState == STATE.MOVING or currentState == STATE.MOVING_AND_SHOOTING:
		position = calc_pos(timePassed)
	
	$BulletLauncher.rotation = 2 * PI + functions.ANGULAR_FUNCTIONS[0].call(timePassed)
	
	if canShoot and (currentState == STATE.SHOOTING or currentState == STATE.MOVING_AND_SHOOTING):
		shoot()
		canShoot = false
		$BulletTimer.start()
		

func calc_pos(t):
	return functions.MATH_FUNCTIONS[0].call(t)
	
	
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
