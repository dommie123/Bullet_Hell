extends RigidBody2D

var is_reflected = false

func _ready():
	pass

func _process(delta):
	pass


func _on_screen_exited():
	queue_free()
