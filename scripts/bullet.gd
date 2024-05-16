extends RigidBody2D

@export var isMagenta: bool

var damage: int
var pierce: int
var bulletGrace: bool

func _ready():
	damage = 1
	pierce = 1
	bulletGrace = false
	
	if isMagenta:
		set_collision_layer_value(3, true)
		set_collision_layer_value(2, false)
		

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
