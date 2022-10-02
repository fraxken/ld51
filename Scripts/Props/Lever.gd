extends Area2D

signal lever_turned()

export (int) var auto_trigger_back_time = 0

onready var timer = $Timer

var playerOnLever = false
var leverUsable = true
var state: bool = false

var registered: int = 0
var unlocked: int = 0

const COLORS: Dictionary = {
	"enabled": Color(0, 1, 0, 1),
	"disabled": Color(1, 0, 0, 1) 
}

func _ready():
	_renderToCurrentState()
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
	unlocked = registered
	emit_signal("lever_turned")
		
func register():
	registered += 1
	
func unlock():
	unlocked -= 1
	if unlocked == 0:
		if auto_trigger_back_time > 0:
			timer.set_wait_time(auto_trigger_back_time)
			timer.start()
		leverUsable = true

func _on_Lever_body_entered(body):
	playerOnLever = true

func _on_Lever_body_exited(body):
	playerOnLever = false

func _on_Timer_timeout():
	_trigger_lever()
	
