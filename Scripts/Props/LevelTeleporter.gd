extends Area2D

export (String) var target_scene

var playerEntered = false
var usedOnce = false
	
func _input(event):
	if playerEntered && event.is_action_pressed("use") && usedOnce == false:
		usedOnce = true
		if !target_scene:
			print("no scene configured!")
			return
		Globals.playerCanMove = false
		Globals.player._resetGravity()
		SceneChanger.next_scene(target_scene)

func _on_LevelTeleporter_body_entered(body):
	if body.is_in_group("player"):
		playerEntered = true

func _on_LevelTeleporter_body_exited(body):
	if body.is_in_group("player"):
		playerEntered = false
