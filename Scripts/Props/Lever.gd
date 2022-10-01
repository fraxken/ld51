extends Area2D

signal lever_turned(state)

export (bool) var state = false
export (int) var delay = 1.0
export (int) var auto_trigger_back_time = 0

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
		timer.stop()
		if playerOnLever && leverUsable:
			_trigger_lever()
		
func _renderToCurrentState():
	var newCurrentState = "enabled" if state else "disabled"
	var color = COLORS[newCurrentState]
	$Sprite.color = color
		
func _trigger_lever():
	state = not state
	_renderToCurrentState()
	leverUsable = false
	# timer.start()
	emit_signal("lever_turned", state)
		
func unlock():
	if auto_trigger_back_time > 0:
		print("start timer: ", auto_trigger_back_time)
		timer.set_wait_time(auto_trigger_back_time)
		timer.start()
	leverUsable = true

func _on_Lever_body_entered(body):
	playerOnLever = true

func _on_Lever_body_exited(body):
	playerOnLever = false

func _on_Timer_timeout():
	print("timer timeout")
	_trigger_lever()
	
