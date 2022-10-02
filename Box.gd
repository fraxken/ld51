extends KinematicBody2D

class_name Box

var velocity = Vector2.ZERO

func _physics_process(delta):
	move_and_slide(velocity, Vector2.UP)

func move(velocity: Vector2) -> void:
	move_and_slide(velocity, Vector2())
