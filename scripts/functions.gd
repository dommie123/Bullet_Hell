extends Node

var x: float
var y: float

@export var MATH_FUNCTIONS = [
	#func(x):
	#	return sqrt(abs((200 * x) - 100000)),
	#func(x):
	#	return sin(0.004 * sqrt(abs(0.5 * x))),
	#func(x):
	#	return (100 * sin(pow(0.01 * x, 2)) / x) * (5 * cos(x)),
	#func(x):
	#	return -((2 * pow(x, 2) + 200) / (7 * sqrt(x))) - 10,
#	func(x):
#		return 100 * atan(0.04 * x),
#	func(x):
#		return -sqrt(abs((200 * x) - 100000)),
#	func(x):
#		return -sin(4 * sqrt(abs(x))),
#	func(x):
#		return -(100 * sin(pow(0.01 * x, 2)) / x) * (5 * cos(x)),
#	func(x):
#		return ((2 * pow(x, 2) + 200) / (7 * sqrt(x))) - 10,
#	func(x):
#		return -(100 * atan(0.04 * x)),
#	func(x):
#		return 30 * sin(x / 15) + 100
	func(t):
		x = 30 * cos(t / 15) + 100
		x += t * 2.5
		y = 30 * sin(t / 15) + 100
		return Vector2(x, y)
]

@export var ANGULAR_FUNCTIONS = [
	func(t):
		return 3 * sin(t) / 5
]
