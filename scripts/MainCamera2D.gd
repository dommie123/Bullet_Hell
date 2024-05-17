extends Camera2D

@export var activate_curse_callable = func(curse):
	_on_activate_curse(curse)

# Called when the node enters the scene tree for the first time.
func _ready():
	rotate(PI)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_activate_curse(curse):
	rotate(PI)
	

func _on_player_deactivate_curse():
	rotate(PI)
