extends Area2D

signal lever_turned()

export (int) var auto_trigger_back_time = 0

onready var timer = $Timer
onready var animPlayer = $AnimationPlayer

var playerOnLever = false
var leverUsable = true
var state: bool = false
var disableAutoTrigger = false

var registered: int = 0
var unlocked: int = 0

func _ready():
	if state:
		animPlayer.play("Open")
	else:
		animPlayer.play("Idle")
	timer.connect("timeout", self, "_on_Timer_timeout")

func _input(event):
	if event.is_action_pressed("use"):
		timer.stop()
		if playerOnLever && leverUsable:
			_trigger_lever()
		
func _renderToCurrentState():
	if state:
		animPlayer.play("Open")
	else:
		animPlayer.play_backwards("Open")
		yield(animPlayer, "animation_finished")
		animPlayer.play("Idle")
		
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
		if !disableAutoTrigger and auto_trigger_back_time > 0:
			timer.set_wait_time(auto_trigger_back_time)
			timer.start()
		disableAutoTrigger = false
		leverUsable = true
		
func reset_initial():
	print("lever reset!")
	timer.stop()
	if state:
		disableAutoTrigger = true
		_trigger_lever()

func _on_Lever_body_entered(body):
	if body.is_in_group("player"):
		playerOnLever = true

func _on_Lever_body_exited(body):
	if body.is_in_group("player"):
		playerOnLever = false

func _on_Timer_timeout():
	_trigger_lever()
	
