extends Button

signal game_resume()

func _on_ResumeButton_pressed():
	if get_tree().paused == true: 
		emit_signal("game_resume")
