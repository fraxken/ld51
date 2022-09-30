extends Control

func _input(event):
	if event.is_action_pressed("pause"):
		var state = not get_tree().paused
		get_tree().paused = state
		visible = state
