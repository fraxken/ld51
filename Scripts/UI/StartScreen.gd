extends Node2D

func _on_ExitButton_pressed():
	get_tree().quit()


func _on_PlayButton_pressed():
	SceneChanger.next_scene("res://Scenes/Main.tscn")
