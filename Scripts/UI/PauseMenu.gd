extends Control

onready var set_tree = get_tree()
func _input(event):
	if event.is_action_pressed("pause"):
		var state = not get_tree().paused
		get_tree().paused = state
		visible = state


func _on_ResumeButton_game_resume():
	get_tree().paused = false
	visible = false
