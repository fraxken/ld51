extends HBoxContainer

var timer = null
var inPause = false

func _ready():
	Globals.timerBar = self
	var timer = Timer.new()
	timer.connect("timeout", self, "progress_bar")
	
	timer.set_wait_time(0.1)	
	timer.set_one_shot(false)	
	
	add_child(timer)
	
	timer.start()
	
func reset():
	$TextureProgress.value = 0
	
func stop():
	if timer != null:
		timer.stop()
	inPause = true
	$TextureProgress.value = 0
	
func start():
	if timer != null:
		timer.start()
	inPause = false
	
func progress_bar(): 
	if inPause:
		return
	if $TextureProgress.value != 100:
		$TextureProgress.value += 1
	else:
		$TextureProgress.value = 0
