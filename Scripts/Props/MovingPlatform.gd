extends Node2D

export (Vector2) var move_to = Vector2.ZERO
export (int) var move_time = 3.0
export (int) var speed = 3.0
export (int) var idle_duration = 2.0

onready var platform = $Platform
onready var tween = $MoveTween

var follow = Vector2.ZERO

func _ready():
	_init_tween()
	
func _init_tween():
	tween.interpolate_property(self, "follow", Vector2.ZERO, move_to, move_time, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, idle_duration)
	tween.interpolate_property(self, "follow", move_to, Vector2.ZERO, move_time, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, move_time + idle_duration * 2)
	tween.start()
	
func _physics_process(delta):
	platform.position = platform.position.linear_interpolate(follow, 0.075)
