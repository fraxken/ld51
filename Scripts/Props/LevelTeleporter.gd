extends Area2D

export (String) var target_scene
export (bool) var state = true

onready var animPlayer = $AnimationPlayer

var playerEntered = false
var usedOnce = false

func _ready():
	animPlayer.play_backwards("Open")
	
func _input(event):
	if event.is_action_pressed("ui_skip") && target_scene:
		_next_level()
		
	if !state:
		return
		
	if playerEntered && event.is_action_pressed("ui_select") && usedOnce == false:
		usedOnce = true
		if !target_scene:
			print("no scene configured!")
			return
		_next_level()

func _next_level():
	Globals.playerCanMove = false
	Globals.player._resetGravity()
	SceneChanger.next_scene(target_scene)
	
func _on_LevelTeleporter_body_entered(body):
	if state && body.is_in_group("player"):
		playerEntered = true
		animPlayer.play("Open")

func _on_LevelTeleporter_body_exited(body):
	if state && body.is_in_group("player"):
		playerEntered = false
		animPlayer.play_backwards("Open")
