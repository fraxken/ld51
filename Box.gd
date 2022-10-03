extends KinematicBody2D

class_name Box

onready var original_position = global_position
onready var animPlayer = $AnimationPlayer
onready var timer = $Timer

var velocity = Vector2.ZERO

func _ready():
	animPlayer.play("Idle")

func reset_initial():
	position = original_position
	
func reset_animation():
	animPlayer.play("Idle")

func _physics_process(delta):
	timer.connect("timeout", self, "reset_animation")
	move_and_slide(velocity, Vector2.UP)

func move(velocity: Vector2) -> void:
	timer.start()
	animPlayer.play("Take")
	move_and_slide(velocity, Vector2())
