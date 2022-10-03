extends Control

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		var state = not get_tree().paused
		get_tree().paused = state
		visible = state

func _on_ResumeButton_pressed():
	get_tree().paused = false
	visible = false

func _on_RestartButton_pressed():
	get_tree().paused = false
	SceneChanger.next_scene("res://Scenes/UI/StartScreen.tscn")

func _on_ExitButton_pressed():
	get_tree().quit()
