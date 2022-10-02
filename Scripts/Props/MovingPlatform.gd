extends Node2D

export (Vector2) var move_to = Vector2.ZERO
export (int) var move_time = 3.0
export (int) var speed = 3.0
export (int) var idle_duration = 2.0

onready var platform = $Platform
onready var tween = $MoveTween
onready var default_position = global_position

var follow = Vector2.ZERO
var state = true

func _ready():
	_init_tween()
	
func _init_tween():
	follow = Vector2.ZERO
	tween.interpolate_property(self, "follow", Vector2.ZERO, move_to, move_time, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, idle_duration)
	tween.interpolate_property(self, "follow", move_to, Vector2.ZERO, move_time, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, move_time + idle_duration * 2)
	tween.start()
	
func _physics_process(delta):
	platform.position = platform.position.linear_interpolate(follow, 0.075)
	
func reset_initial():
	tween.reset_all()
	_init_tween()

func reset_gravity():
	if !state: reverse_gravity()
	
func reverse_gravity():
	$Platform/CollisionShape2D.rotate(deg2rad(180))
	state = not state
