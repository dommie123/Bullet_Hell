extends RigidBody2D

signal reflect_bullet

var yIsLocked = true

const MAX_ROTATION = PI / 6 # 30 degrees in radians

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var mouse_position = get_viewport().get_mouse_position()
	var screen_bounds = get_viewport_rect().size
	
	position.x = clamp(mouse_position.x, 64, screen_bounds.x - 64)
	
	if not yIsLocked:
		position.y = clamp(mouse_position.y, screen_bounds.y - 100, screen_bounds.y)
	
	if Input.is_action_pressed("rotate_left") and Input.is_action_pressed("rotate_right"):
		rotate(0)
	elif Input.is_action_pressed("rotate_left") and rotation > -MAX_ROTATION:
		rotate(-(PI / 24))
	elif Input.is_action_pressed("rotate_right") and rotation < MAX_ROTATION:
		rotate(PI / 24)


func _on_body_entered(body):
	# TODO reflect ONLY when color is same as bullet
	reflect_bullet.emit()
	print_debug("Hit!")
