extends Node

var x: float
var y: float

@export var MATH_FUNCTIONS = [
	func(t):
		x = 45 * cos(t / 15) + 100
		x += t * 2.5
		y = 45 * sin(t / 15) + 100
		return Vector2(x, y),
	func(t):
		x = (30 + (t / 3)) * cos(t / 20) + 100
		x += t * 2.5
		y = (30 + (t / 3)) * sin(t / 20) + 100
		return Vector2(x, y),
	func(t):
		x = (15 / (t / 3)) * cos(t / 15) + 100
		x += t * 2.5
		y = (-30 + t) * sin(t / 15) + 100
		return Vector2(x, y),
	func(t):
		x = 45 * cos(t / 15) + 100
		x += t * 2.5
		y = 45 * sin(t / 15) + 100
		y += sin(t * 2.5)
		return Vector2(x, y),
	func(t):
		x = (t / 2) * sin(t / 40) + 100
		x += t
		y = 2 * (t / 3) * sin(t / 20) + 300
		y -= t
		return Vector2(x, y),
	func(t):
		x = (15 / (t / 3)) * cos(t / 15) + 100
		x += t * 1.5
		y = 90 * sin(t / 15) - 50
		y += t
		return Vector2(x, y),
	func(t):
		# Note: Below commented code results in a Figure 8 movement pattern
#		x = 45 * cos(t / 30) + 100
#		y = 45 * sin(t / 15) + 100
		x = 30 * cos(t / 45) + 100
		t -= x * 2
		y = 45 * sinh(t / 45) + 100
		return Vector2(x, y),
	func(t):
		x = (2 * t) * cos(t / 50) + 300
		y = (30 + (t / 3)) * tanh(t / 60) - 100
		x += t + y
		y += t
		return Vector2(x, y),
	func(t):
		x = 30 * cosh(log(t / 15))
		x += t * 1.5
		y = 180 * sin(log((t * x) / 30)) - 100
		return Vector2(x, y),
	func(t):
		x = 60 * cosh(log(t / 15)) + 100
		y -= t * 2.5
		y = 180 * sin(log((t * x) / 30)) - 300
		return Vector2(x, -y),
	func(t):
		x = (15 / (t / 3)) * cos(t / 15) + 100
		x += t * 1.5
		y = 90 * sin(t / 15) - 250
		y += t
		return Vector2(x, -y),
	func(t):
		x = (t / 2) * sin(t / 20) + 100
		x += t
		y = 2 * (t / 3) * sin(t / 10) + 100
		y -= t
		return Vector2(x, -y),
	func(t):
		# Note: Below commented code results in a Figure 8 movement pattern
#		x = 45 * cos(t / 30) + 100
#		y = 45 * sin(t / 15) + 100
		x = 30 * cos(t / 45) + 100
		t -= x * 2
		y = 45 * sinh(t / 45) - 100
		return Vector2(x, -y),
	func(t):
		x = (2 * t) * cos(t / 50) + 500
		y = (30 + (t / 3)) * tanh(t / 60) - 400
		x += t + y
		y += t
		return Vector2(x, -y),
	func(t):
		x = (15 / (t / 2)) * cos(t / 5) + 100
		x += t * 2.5
		y = (-30 + t) * sin(t / 10) + 100
		return Vector2(x, y)
]

@export var ANGULAR_FUNCTIONS = [
	# Hax0r First Launcher Pattern
	func(t):
		return 3 * cos(t) / 5,
	#Hax0r Second Launcher Pattern
	func(t):
		return 3 * -cos(t) / 5,
]
