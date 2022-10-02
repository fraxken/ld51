extends Node2D

export (int) var time_between_projectile = 3
export (Vector2) var projectile_direction = Vector2.RIGHT
export (int) var projectile_speed = 120

onready var timer = $ProjectileTimer

var projectileScene = preload("res://Scenes/SFX/Projectile.tscn")

func _ready():
	timer.set_wait_time(time_between_projectile)

func _on_ProjectileTimer_timeout():
	var instance = projectileScene.instance()
	var localDirection = projectile_direction.normalized()
	
	if localDirection == Vector2.UP || localDirection == Vector2.DOWN:
		instance.rotate(deg2rad(90))
	if localDirection == Vector2.LEFT:
		instance.rotate(deg2rad(180))
	instance.configure(localDirection, projectile_speed)
	instance.position += localDirection * 4
	
	self.add_child(instance)
