extends Area2D

func _on_Area2D_body_entered(body: PhysicsBody2D) -> void:
	print("hello world!")
	print(body)
	#queue_free()
