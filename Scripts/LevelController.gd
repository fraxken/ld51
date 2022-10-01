extends Node2D

var player = preload("res://Scenes/Player.tscn").instance()

func _ready():
	Globals.controller = self
	teleportPlayerToStartPosition(false)
	self.add_child(player)

func teleportPlayerToStartPosition(die: bool):
	player.position = $StartPosition.position
	if die:
		player.die()
