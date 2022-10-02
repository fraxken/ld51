extends HBoxContainer

func _ready():
	var timer = Timer.new()
	
	timer.set_wait_time(1.0)	
	timer.set_one_shot(false)	
	timer.connect("timeout", self, "progress_bar")
	
	add_child(timer)
	
	timer.start()
	
func progress_bar(): 
	if $TextureProgress.value != 100:
		$TextureProgress.value += 10
	else:
		$TextureProgress.value = 0