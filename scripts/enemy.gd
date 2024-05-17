extends Node2D

enum STATE {
	MOVING = 1,
	SHOOTING = 2,
	MOVING_AND_SHOOTING = 3,
	DEAD = 4
}

enum TYPE {
	AIMBOT = 0,
	TROJAN = 1,
	HAXOR = 2,
	WORM = 3,
	MEGABYTE = 4,
	GIGABYTE = 5
}

signal enemy_fled
signal enemy_killed

@export var bullet_scene: PackedScene
@export var currentState: STATE
@export var currentType: TYPE
@export var positionOffset: Vector2

@export var xYInverted: bool
@export var funcIndex: int

var functions: Functions
var utils: Utils

var angularVelocity: float
var timePassed: float
var canShoot: bool
var spawnGrace: bool # Keeps the enemy from being destroyed while spawning offscreen

const timeMultiplier = 100
const Functions = preload("res://scripts/functions.gd")
const Utils = preload("res://scripts/utils.gd")

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite2D.play("default")
	functions = Functions.new()
	utils = Utils.new()
	
	angularVelocity = (3 * PI) / 4
	timePassed = 0
	canShoot = true
	spawnGrace = true
	
	if currentType == TYPE.AIMBOT:
		$BulletTimer.wait_time *= 30
		
	var mainNode = get_node("/root/Main")
	
	enemy_fled.connect(mainNode.enemy_fled_callable)
	enemy_killed.connect(mainNode.enemy_killed_callable)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if currentState == STATE.DEAD:
		enemy_killed.emit()
		queue_free()
	
	timePassed += timeMultiplier * delta
	
	if (currentState == STATE.MOVING or currentState == STATE.MOVING_AND_SHOOTING):
		position = calc_pos(timePassed)
	
	if currentType == TYPE.AIMBOT or currentType == TYPE.MEGABYTE or currentType == TYPE.GIGABYTE:
		var playerPos = get_node("/root/Main/Player").position
		$BulletLauncher.look_at(playerPos)
	else:
		$BulletLauncher.rotation = 2 * PI + functions.ANGULAR_FUNCTIONS[0].call(timePassed)
	
	if canShoot and (currentState == STATE.SHOOTING or currentState == STATE.MOVING_AND_SHOOTING):
		shoot()
		canShoot = false
		$BulletTimer.start()
		

func calc_pos(t):
	var result = functions.MATH_FUNCTIONS[funcIndex].call(t)
	var resultWithOffset = result + positionOffset
	return utils.invert_vector.call(resultWithOffset) if xYInverted else resultWithOffset
	
	
func shoot():
	if currentType == TYPE.TROJAN:
		assert(false, "Trojan enemies cannot shoot the player!")
		
	var bullet = bullet_scene.instantiate()
	
	bullet.position = position
	var direction = $BulletLauncher.rotation
	
	# Choose the velocity for the bullet
	var velocity = Vector2(350, 0)
	bullet.linear_velocity = velocity.rotated(direction)
	
	add_sibling(bullet)
	

func _on_visible_on_screen_notifier_2d_screen_exited():
	if not spawnGrace:
		enemy_fled.emit()
		queue_free()
	

func _on_timer_timeout():
	canShoot = true


func _on_visible_on_screen_notifier_2d_screen_entered():
	spawnGrace = false


func _on_area_2d_body_entered(body):
	currentState = STATE.DEAD
