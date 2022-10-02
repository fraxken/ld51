extends KinematicBody2D

export var reset_time: float = 2.0
export var time_before_fall: float = 1.5 

onready var timer = $ResetTimer
onready var animPlayer = $AnimationPlayer
onready var reset_position = global_position

var velocity = Vector2()
var isTriggered = false
var timeoutExecute = false
var state = true

func _ready():
	set_physics_process(false)

func _physics_process(delta):
	velocity.y += -(Globals.gravity * delta) if Globals.reverseGravityEnabled else (Globals.gravity * delta)
	position += velocity * delta
	
func collide_with(collision: KinematicCollision2D, collider: KinematicBody2D):
	if !isTriggered:
		isTriggered = true
		yield(get_tree().create_timer(time_before_fall / 2), "timeout")
		animPlayer.play("Shake")
		yield(get_tree().create_timer(time_before_fall / 2), "timeout")
		velocity = Vector2.ZERO
		set_physics_process(true)
		timer.start(reset_time)

func _on_ResetTimer_timeout():
	if timeoutExecute:
		return
	timeoutExecute = true
	set_physics_process(false)
	yield(get_tree(), "physics_frame")
	var temp = collision_layer
	collision_layer = 0
	global_position = reset_position
	yield(get_tree(), "physics_frame")
	collision_layer = temp
	isTriggered = false
	timeoutExecute = false
	
func reset_initial():
	_on_ResetTimer_timeout()
	
func reset_gravity():
	if !state: reverse_gravity()
	
func reverse_gravity():
	$CollisionShape2D.rotate(deg2rad(180))
	state = not state
	
