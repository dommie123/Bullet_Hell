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

enum color {cyan,magenta} #ADDED enumerator used to denote colors throughout the code. Use these when describing a color of enemy or bullet

signal enemy_fled
signal enemy_killed

@export var bullet_scene: PackedScene
@export var powerupScene: PackedScene
@export var currentState: STATE
@export var currentType: TYPE
@export var positionOffset: Vector2

@export var xYInverted: bool
@export var funcIndex: int
@export var bulletLaunchSpeedMultiplier: int

@onready var shader_material = $AnimatedSprite2D.material

var functions: Functions
var utils: Utils

var lastFramePos : Vector2 #where we were in space last frame
var posDifference : Vector2 #the difference between last frame and the next calculated frame
var angularVelocity: float
var timePassed: float
var canShoot: bool
var spawnGrace: bool # Keeps the enemy from being destroyed while spawning offscreen
var bulletLaunchSpeed: int

var timeMultiplier: int
const Functions = preload("res://scripts/functions.gd")
const Utils = preload("res://scripts/utils.gd")

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite2D.play("Gigabyte")
	functions = Functions.new()
	utils = Utils.new()
	
	timeMultiplier = 75
	angularVelocity = (3 * PI) / 4
	timePassed = 0
	canShoot = true
	spawnGrace = true
	bulletLaunchSpeed = 350 * bulletLaunchSpeedMultiplier
	
	if currentType == TYPE.AIMBOT:
		$BulletTimer.wait_time *= 30
		
	var mainNode = get_node("/root/Main")
	
	enemy_fled.connect(mainNode.enemy_fled_callable)
	enemy_killed.connect(mainNode.enemy_killed_callable)
	
#	if shader_material is ShaderMaterial:#TO FIX
#		if currentColor == COLOR.CYAN:
#			shader_material.set_shader_parameter("glow_color", Color(0.0, 0.5, 0.5, 1.0))
#		elif currentColor == COLOR.MAGENTA:
#			shader_material.set_shader_parameter("glow_color", Color(0.5, 0.0, 0.5, 1.0))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if currentState == STATE.DEAD:
		const pwrDropChance = 50
		var pwrDropRoll = randi_range(1, pwrDropChance)
		
		if pwrDropRoll % pwrDropChance == 0:
			spawn_powerup()
			
		enemy_killed.emit()
		queue_free()
	
	timePassed += timeMultiplier * delta
	
	if (currentState == STATE.MOVING or currentState == STATE.MOVING_AND_SHOOTING):
		lastFramePos = position
		position = calc_pos(timePassed)
		posDifference = position - lastFramePos
	
	if currentType == TYPE.AIMBOT or currentType == TYPE.MEGABYTE or currentType == TYPE.GIGABYTE:
		var player = get_node("/root/Main/Player")
		
		if player:
			var playerPos = get_node("/root/Main/Player").position
			$BulletLauncher.look_at(playerPos)
		else:
			currentState = STATE.MOVING
	else:
		$BulletLauncher.rotation = 2 * PI + functions.ANGULAR_FUNCTIONS[0].call(timePassed)
	
	if canShoot and (currentState == STATE.SHOOTING or currentState == STATE.MOVING_AND_SHOOTING):
		shoot()
		canShoot = false
		$BulletTimer.start()
	
	#ANIMATION STUFF
	if posDifference.x < (-5) or posDifference.x > (5):
		$AnimatedSprite2D.set_frame(3)
	elif posDifference.x < (-4) or posDifference.x > (4):
		$AnimatedSprite2D.set_frame(2)
	elif posDifference.x < (-3) or posDifference.x > (3):
		$AnimatedSprite2D.set_frame(1)
	elif posDifference.x < (-1) or posDifference.x > (1):
		$AnimatedSprite2D.set_frame(0)
	else:
		$AnimatedSprite2D.set_frame(0)
		
	if posDifference.x <= 0:
		$AnimatedSprite2D.flip_v = false
	else:
		$AnimatedSprite2D.flip_v = true

func calc_pos(t):
	var result = functions.MATH_FUNCTIONS[funcIndex].call(t)
	var resultWithOffset = result + positionOffset
	return utils.invert_vector.call(resultWithOffset) if xYInverted else resultWithOffset
	
	
func shoot():
	if currentType == TYPE.TROJAN:
		assert(false, "Trojan enemies cannot shoot the player!")
		
	var bullet = bullet_scene.instantiate()
	bullet.bulletColor = color.cyan #TEMPORARY. ALL BULLETS SHOT ARE CYAN RIGHT NOW
	
	bullet.position = position
	var direction = $BulletLauncher.rotation
	
	bullet.speed = bulletLaunchSpeed
	
	# Choose the velocity for the bullet
	var velocity = Vector2(1, 0)
	bullet.linear_velocity = velocity.rotated(direction)
	
	add_sibling(bullet)
	
	
func spawn_powerup():
	var powerup = powerupScene.instantiate()
	
	powerup.position = position
	
	add_sibling(powerup)

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
	
