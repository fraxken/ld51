extends Area2D

signal lever_turned(state)

export (int) var delay = 2.0

onready var timer = $Timer

var playerOnLever = false
var leverEnabled = false
var leverUsable = true

const COLORS: Dictionary = {
	"enabled": Color(0, 1, 0, 1),
	"disabled": Color(1, 0, 0, 1) 
}

func _ready():
	timer.set_wait_time(delay)
	timer.connect("timeout", self, "_on_Timer_timeout")

func _input(event):
	if event.is_action_pressed("use"):
		_trigger_lever()
		
func _trigger_lever():
	if playerOnLever && leverUsable:
		var state = "disabled" if leverEnabled else "enabled"
		var color = COLORS[state]
		
		$Sprite.color = color
		leverEnabled = not leverEnabled
		leverUsable = false
		timer.start()
		emit_signal("lever_turned", leverEnabled)

func _on_Lever_body_entered(body):
	playerOnLever = true

func _on_Lever_body_exited(body):
	playerOnLever = false

func _on_Timer_timeout():
	leverUsable = true
	
