extends Node2D

var player = preload("res://Scenes/Player.tscn").instance()

func _ready():
	Globals.controller = self
	teleportPlayerToStartPosition(false)
	self.add_child(player)

func teleportPlayerToStartPosition(die: bool, kind = "none"):
	var startPos = get_node("StartPosition")
	if startPos:
		player.position = startPos.position
		if die:
			print("player killed by: ", kind)
			player.die()
