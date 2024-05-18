extends Area2D

@export var bulletScene: PackedScene

var playerNode: Node2D

var bulletSpeed: float

# Called when the node enters the scene tree for the first time.
func _ready():
	playerNode = get_node("/root/Main/Player")
	bulletSpeed = 350

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if playerNode:
		$BulletLauncher.look_at(playerNode.position)

func _on_de_bugger_fire_turrets(color):
	var bullet = bulletScene.instantiate()
	var segment = get_node("/root/Main/DeBugger/Segment")
	
	bullet.bulletColor = color #TEMPORARY. ALL BULLETS SHOT ARE CYAN RIGHT NOW
	
	bullet.set_global_position(global_position)
	var direction = $BulletLauncher.global_rotation
	
	bullet.speed = bulletSpeed
	
	# Choose the velocity for the bullet
	var velocity = Vector2(1, 0)
	bullet.linear_velocity = velocity.rotated(direction)
	
	get_node("/root/Main/DeBugger").add_sibling(bullet)


func _on_de_bugger_fire_turrets_2(color):
	var bullet = bulletScene.instantiate()
	var segment = get_node("/root/Main/DeBugger/Segment2")
	bullet.bulletColor = color #TEMPORARY. ALL BULLETS SHOT ARE CYAN RIGHT NOW
	
	bullet.set_global_position(global_position)
	var direction = $BulletLauncher.global_rotation
	
	bullet.speed = bulletSpeed
	
	# Choose the velocity for the bullet
	var velocity = Vector2(1, 0)
	bullet.linear_velocity = velocity.rotated(direction)
	
	get_node("/root/Main/DeBugger").add_sibling(bullet)
	
func _on_de_bugger_fire_turrets_3(color):
	var bullet = bulletScene.instantiate()
	var segment = get_node("/root/Main/DeBugger/Segment3")
	bullet.bulletColor = color #TEMPORARY. ALL BULLETS SHOT ARE CYAN RIGHT NOW
	
	bullet.set_global_position(global_position)
	var direction = $BulletLauncher.global_rotation
	
	bullet.speed = bulletSpeed
	
	# Choose the velocity for the bullet
	var velocity = Vector2(1, 0)
	bullet.linear_velocity = velocity.rotated(direction)
	
	get_node("/root/Main/DeBugger").add_sibling(bullet)
