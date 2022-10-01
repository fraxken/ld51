extends Button

func _on_GiveUpButton_pressed():
	get_tree().paused = false
	SceneChanger.next_scene("res://Scenes/UI/StartScreen.tscn")
