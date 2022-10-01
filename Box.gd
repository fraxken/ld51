extends KinematicBody2D

class_name Box

func move(velocity: Vector2) -> void:
	move_and_slide(velocity, Vector2())
