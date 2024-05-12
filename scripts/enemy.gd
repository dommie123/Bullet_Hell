extends Node2D

enum STATE {
	MOVING,
	SHOOTING,
	DEAD
}

signal enemy_fled

@export var bullet_scene: PackedScene
var speed = 250
var angularVelocity = (3 * PI) / 4
var timePassed = 0
var currentState = STATE.MOVING

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite2D.play("default")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	timePassed += delta
	
	position.x += speed * delta
	position.y = calc_y(position.x)
	
	$BulletLauncher.rotate(angularVelocity * delta)
	
	if (fmod(timePassed, 0.2) <= 0.01):
		shoot()

func calc_y(x):
	return sqrt(abs((200 * x) - 100000))
	
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
