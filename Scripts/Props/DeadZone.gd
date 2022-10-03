extends Area2D

var playerExited = false

func _ready():
	pass # Replace with function body.

func _on_DeadZone_body_exited(body):
	if body.is_in_group("player") && playerExited == false:
		playerExited = true
		print("player exited area!")
		Globals.controller.teleportPlayerToStartPosition(true, "deadzone")

func _on_DeadZone_body_entered(body):
	if body.is_in_group("player") && playerExited == true:
		playerExited = false
