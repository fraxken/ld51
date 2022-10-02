extends Area2D

signal reactiveArea_turned(state)

export (bool) var state = false
export (int) var delay = 1.0

onready var timer = $Timer

func _ready():
	timer.set_wait_time(delay)
	timer.connect("timeout", self, "_on_Timer_timeout")

func _trigger_reactiveArea():
	timer.start()
	emit_signal("reactiveArea_turned", state)

func _on_ReactiveArea_body_entered(body):
	_trigger_reactiveArea()
