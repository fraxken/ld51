extends Area2D

func _on_Spike_body_entered(body):
	Globals.controller.teleportPlayerToStartPosition(true)
