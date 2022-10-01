extends Node2D

export (int) var move_time = 3.0
export (int) var opening_delay = 2.0
export (Vector2) var move_to = Vector2.DOWN * 96

onready var door = $Static
onready var tween = $MoveTween

var follow = Vector2.ZERO

func _ready():
	_init_tween()
	
func _init_tween():
	tween.interpolate_property(self, "follow", Vector2.ZERO, move_to, move_time, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, opening_delay)
	#tween.interpolate_property(self, "follow", move_to, Vector2.ZERO, move_time, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, move_time + idle_duration * 2)
	
func _physics_process(delta):
	door.position = door.position.linear_interpolate(follow, 0.075)

func _open():
	print("open door!")
	tween.start()

func _on_Lever_lever_turned(state):
	print("lever activated!")
	_open()
