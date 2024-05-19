extends Node2D

signal boss_defeated
signal fire_turrets
signal fire_turrets_2
signal fire_turrets_3

enum STATE {
	MOVING, 
	SHOOTING,
	MOVING_AND_SHOOTING,
	DEAD
}

enum COLOR {
	CYAN,
	MAGENTA
}

var Functions = preload("res://scripts/functions.gd")

@export var currentState: STATE
@export var powerupScene: PackedScene
@export var positionOffset: Vector2

@export var speed: float
@export var moveAmplitude: float
@export var moveShift: float

var currentColor: COLOR # Head color
var lastFramePosition: Vector2
var posDifference: Vector2
var segmentColors
var functions
var segments

var timePassed: float
var health: int
var phase: int
var canFireTurrets: bool

# Called when the node enters the scene tree for the first time.
func _ready():
	currentColor = COLOR.CYAN
	functions = Functions.new()
	segments = get_tree().get_nodes_in_group("Segments")
	segmentColors = [COLOR.CYAN, COLOR.CYAN, COLOR.CYAN]
	
	timePassed = 0
	health = 1000
	phase = 1
	canFireTurrets = true
	
	var mainNode = get_node("/root/Main")
	boss_defeated.connect(mainNode.boss_defeated_callable)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if health <= 0:
		# TODO die in a spectacular fashion
		boss_defeated.emit()
		queue_free()
	
	if health <= 500 and phase == 1:
		speed *= 1.5
		phase = 2
	
	timePassed += speed * delta
	
	if currentState == STATE.MOVING_AND_SHOOTING:
		move()
		
		if canFireTurrets:
			shoot()
	elif currentState == STATE.MOVING:
		move()
	elif currentState == STATE.SHOOTING and canFireTurrets:
		shoot()
			
			
func move():
	lastFramePosition = $Head.position
	$Head.position = calc_head_pos(timePassed)
	posDifference = $Head.position - lastFramePosition
	posDifference = posDifference.normalized()
	$Head.set_deferred("rotation", atan2(-posDifference.y, -posDifference.x))
	
	var index = 1
	for segment in segments:
		lastFramePosition = segment.position
		segment.position = calc_head_pos(timePassed - (index * 30))
		posDifference = segment.position - lastFramePosition
		posDifference = posDifference.normalized()
		segment.set_deferred("rotation", atan2(-posDifference.y, -posDifference.x))
		
		index += 1
		

func shoot():
	fire_turrets.emit(segmentColors[0])
	fire_turrets_2.emit(segmentColors[1])
	fire_turrets_3.emit(segmentColors[2])
	
	canFireTurrets = false
	$BulletTimer.start()
	

func shift_head():
	if currentColor == COLOR.CYAN:
		currentColor = COLOR.MAGENTA
		var headSprite = $Head/AnimatedSprite2D
		var headMaterial = headSprite.material
		headMaterial.set_shader_parameter("glow_color", Color(0.5, 0.0, 0.5, 1.0))
		$Head.set_collision_layer_value(11,false)#sets boss and turret collision cyan to false
		$Head.set_collision_layer_value(13,false)
		
		$Head.set_collision_layer_value(12,true)#sets boss and turret collision magenta to true
		$Head.set_collision_layer_value(14,true)
		
		$Head.set_collision_mask_value(9,false) #sets bullet collision
		$Head.set_collision_mask_value(10,true)
	
	elif currentColor == COLOR.MAGENTA:
		currentColor = COLOR.CYAN
		var segmentSprite = $Head/AnimatedSprite2D
		var segmentMaterial = segmentSprite.material
		segmentMaterial.set_shader_parameter("glow_color", Color(0.0, 0.5, 0.5, 1.0))
		$Head.set_collision_layer_value(12,false) #sets boss and turret collision magenta to false
		$Head.set_collision_layer_value(14,false)
		
		$Head.set_collision_layer_value(11,true) #sets boss and turret collision cyan to true
		$Head.set_collision_layer_value(13,true)
		
		$Head.set_collision_mask_value(9,true) #sets bullet collision
		$Head.set_collision_mask_value(10,false)
		
	$Head/ShiftTimer.set_deferred("wait_time", randi_range(1, 10))
	$Head/ShiftTimer.start()
		

func shift_segment(segmentIndex: int):
	var segment = segments[segmentIndex]
	var segTimer = segment.get_node("ShiftTimer")
	
	if segmentColors[segmentIndex] == COLOR.CYAN:
		segmentColors[segmentIndex] = COLOR.MAGENTA
		var segmentSprite = segment.get_node("AnimatedSprite2D")
		var segmentMaterial = segmentSprite.material
		segmentMaterial.set_shader_parameter("glow_color", Color(0.5, 0.0, 0.5, 1.0))
		segment.set_collision_layer_value(11,false)#sets boss and turret collision cyan to false
		segment.set_collision_layer_value(13,false)
		
		segment.set_collision_layer_value(12,true)#sets boss and turret collision magenta to true
		segment.set_collision_layer_value(14,true)
		
		segment.set_collision_mask_value(9,false) #sets bullet collision
		segment.set_collision_mask_value(10,true)
	
	elif segmentColors[segmentIndex] == COLOR.MAGENTA:
		segmentColors[segmentIndex] = COLOR.CYAN
		var segmentSprite = segment.get_node("AnimatedSprite2D")
		var segmentMaterial = segmentSprite.material
		segmentMaterial.set_shader_parameter("glow_color", Color(0.0, 0.5, 0.5, 1.0))
		segment.set_collision_layer_value(12,false) #sets boss and turret collision magenta to false
		segment.set_collision_layer_value(14,false)
		
		segment.set_collision_layer_value(11,true) #sets boss and turret collision cyan to true
		segment.set_collision_layer_value(13,true)
		
		segment.set_collision_mask_value(9,true) #sets bullet collision
		segment.set_collision_mask_value(10,false)
		
	segTimer.set_deferred("wait_time", randi_range(1, 10))
	segTimer.start()
	
	
func drop_powerup():
	var powerup = powerupScene.instantiate()
	
	powerup.position = position
	
	add_sibling(powerup)
	

func calc_head_pos(t):
	var result = functions.BOSS_FUNCTIONS[0].call(t, moveAmplitude, moveShift)
	var resultWithOffset = result + positionOffset
	return resultWithOffset


#func calc_segment_pos(t, segmentPos):
#	var result = functions.BOSS_FUNCTIONS[0].call(t, moveAmplitude, moveShift)
#	var resultWithOffset = result + positionOffset + segmentPos
#	return resultWithOffset
#	return segmentPos.lerp($Head.position, timePassed)


func _on_segment_body_entered(body):
	health -= body.damage		# Take small damage
	body.pierce -= 1
	
	if body.pierce == 0:
		body.queue_free()


func _on_turret_body_entered(body):
	health -= body.damage * 5	# Take BEEG damage
	body.pierce -= 1
	
	if body.pierce == 0:
		body.queue_free()


func segment_collision_layer_value(layer, value):
	$Head.set_collision_layer_value(layer, value)
	
	for segment in segments:
		segment.set_collision_layer_value(layer, value)
		
		
func segment_collision_mask_value(layer, value):
	$Head.set_collision_mask_value(layer, value)
	
	for segment in segments:
		segment.set_collision_mask_value(layer, value)


func _on_bullet_timer_timeout():
	canFireTurrets = true


func _on_head_shift_timer_timeout():
	shift_head()


func _on_seg_1_shift_timer_timeout():
	shift_segment(0)


func _on_seg_2_shift_timer_timeout():
	shift_segment(1)


func _on_seg_3_shift_timer_timeout():
	shift_segment(2)
