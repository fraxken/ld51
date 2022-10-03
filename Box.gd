extends KinematicBody2D

class_name Box

onready var original_position = global_position
onready var animPlayer = $AnimationPlayer

var velocity = Vector2.ZERO

func _ready():
	animPlayer.play("Idle")

func reset_initial():
	position = original_position

func _physics_process(delta):
	move_and_slide(velocity, Vector2.UP)

func move(velocity: Vector2) -> void:
	move_and_slide(velocity, Vector2())
