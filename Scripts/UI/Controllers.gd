extends VBoxContainer

func _input(event):
	if event.is_action_pressed("up"):
		$KeyW.play("default")
	if event.is_action_pressed("down"):
		$KeyS.play("default")
	if event.is_action_pressed("right"):
		$KeyD.play("default")
	if event.is_action_pressed("left"):
		$KeyA.play("default")
	if event.is_action_pressed("jump"):
		$KeySpace.play("default")
	if event.is_action_pressed("dash"):
		$KeyShift.play("default")

func _on_KeyA_animation_finished():
	$KeyA.stop()

func _on_KeyS_animation_finished():
	$KeyS.stop()

func _on_KeyW_animation_finished():
	$KeyW.stop()

func _on_KeyD_animation_finished():
	$KeyD.stop()

func _on_KeyShift_animation_finished():
	$KeyShift.stop()

func _on_KeySpace_animation_finished():
	$KeySpace.stop()
