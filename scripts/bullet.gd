extends RigidBody2D

signal bullet_hit

var damage: int
var pierce: int
var isReflected: bool

func _ready():
	damage = 1
	pierce = 1

	isReflected = false
	
	var playerNode = get_node("/root/Main/Player")
	

func _on_screen_exited():
	queue_free()


func _on_body_entered(body):
#	print()
	if "Player" in body.name:
#		set_collision_mask_value(3, true)
		set_collision_layer_value(4, true)
#		set_collision_layer_value(2, false)
#		set_collision_mask_value(1, false)

	elif "Enemy" in body.name:
		body.currentState = 3 # STATE.DEAD
		bullet_hit.emit()
		pierce -= 1
	
		if pierce <= 0:
			queue_free()
