extends Node2D

var player = preload("res://Scenes/Player.tscn").instance()

func _ready():
	player.position = $StartPosition.position
	self.add_child(player)
