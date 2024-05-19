extends Control

@onready var lifeShader = $TextureRect.material

var isMagenta: bool

# Called when the node enters the scene tree for the first time.
func _ready():
	isMagenta = false
	lifeShader.set_shader_parameter("glow_color", Color(0.0, 0.5, 0.5, 1.0))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("shift"):
		isMagenta = !isMagenta
		
		if not isMagenta:
			lifeShader.set_shader_parameter("glow_color", Color(0.0, 0.5, 0.5, 1.0))
		else:
			lifeShader.set_shader_parameter("glow_color", Color(0.5, 0.0, 0.5, 1.0))
