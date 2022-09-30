extends KinematicBody2D

export (int) var speed = 100
export (int) var jump_speed = -200
export (int) var gravity = 280

var velocity = Vector2.ZERO

func get_input():
	velocity.x = 0
	if Input.is_action_pressed("right"):
		velocity.x += speed
		$Sprite.flip_h=false
	if Input.is_action_pressed("left"):
		velocity.x -= speed
		$Sprite.flip_h=true

func _physics_process(delta):
	get_input()
	#if velocity.x == 0:
	#	$AnimationPlayer.play("Idle")
	#else:
	#	$AnimationPlayer.play("Walk")
	velocity.y += gravity * delta
	velocity = move_and_slide(velocity, Vector2.UP)
	
	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			velocity.y = jump_speed

