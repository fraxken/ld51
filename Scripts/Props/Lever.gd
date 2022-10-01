extends Area2D

signal lever_turned(state)

export (bool) var state = false
export (int) var delay = 1.0

onready var timer = $Timer

var playerOnLever = false
var leverUsable = true

const COLORS: Dictionary = {
	"enabled": Color(0, 1, 0, 1),
	"disabled": Color(1, 0, 0, 1) 
}

func _ready():
	_renderToCurrentState()
	timer.set_wait_time(delay)
	timer.connect("timeout", self, "_on_Timer_timeout")

func _input(event):
	if event.is_action_pressed("use"):
		_trigger_lever()
		
func _renderToCurrentState():
	var newCurrentState = "enabled" if state else "disabled"
	var color = COLORS[newCurrentState]
	$Sprite.color = color
		
func _trigger_lever():
	if playerOnLever && leverUsable:
		state = not state
		_renderToCurrentState()
		leverUsable = false
		timer.start()
		emit_signal("lever_turned", state)

func _on_Lever_body_entered(body):
	playerOnLever = true

func _on_Lever_body_exited(body):
	playerOnLever = false

func _on_Timer_timeout():
	leverUsable = true
	
