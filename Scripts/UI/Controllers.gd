extends VBoxContainer

func _input(event):
	if event.is_action_pressed("up"):
		$KeyW.set_frame(1)
	if event.is_action_pressed("down"):
		$KeyS.set_frame(1)
	if event.is_action_pressed("right"):
		$KeyD.set_frame(1)
	if event.is_action_pressed("left"):
		$KeyA.set_frame(1)
	if event.is_action_pressed("jump"):
		$KeySpace.set_frame(1)
	if event.is_action_pressed("dash"):
		$KeyShift.set_frame(1)

	if event.is_action_released("up"):
		$KeyW.set_frame(0)
	if event.is_action_released("down"):
		$KeyS.set_frame(0)
	if event.is_action_released("right"):
		$KeyD.set_frame(0)
	if event.is_action_released("left"):
		$KeyA.set_frame(0)
	if event.is_action_released("jump"):
		$KeySpace.set_frame(0)
	if event.is_action_released("dash"):
		$KeyShift.set_frame(0)
