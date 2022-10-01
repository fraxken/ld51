extends KinematicBody2D

export (int) var speed = 150
export (int) var acceleration = 2.5
export (int) var jump_speed = 225
export (int) var gravity = 350
export (int) var max_jump = 1

onready var gravityTimer = get_node("Timer")

var velocity = Vector2.ZERO
var jumpCount: int = 0
var reverseGravityEnabled = false
var touchedOnce = false

func _ready():
	# TODO: EDIT THIS LATER TO PUT 10
	gravityTimer.set_wait_time(60)
	gravityTimer.start()

func _input(event):
	if event.is_action_pressed("gravity"):
		gravityTimer.start()
		_reverseGravity()
		
func get_input():
	if Input.is_action_pressed("right"):
		velocity.x = min(velocity.x + acceleration, speed)
		$Sprite.flip_h = false
		$AnimationPlayer.play("Walk")
	elif Input.is_action_pressed("left"):
		velocity.x = max(velocity.x - acceleration, -speed)
		$Sprite.flip_h = true
		$AnimationPlayer.play("Walk")
	else:
		velocity.x = lerp(velocity.x, 0, 0.1)
		$AnimationPlayer.play("Idle")

func _physics_process(delta):
	get_input()
		
	if reverseGravityEnabled == true:
		velocity.y -= gravity * delta
	else:
		velocity.y += gravity * delta
	velocity = move_and_slide(velocity, Vector2.UP)
	
	var allowJump = true
	if !is_on_floor() && reverseGravityEnabled == false:
		allowJump = false
	elif !is_on_ceiling() && reverseGravityEnabled == true:
		allowJump = false
	
	if (allowJump || touchedOnce) && Input.is_action_just_pressed("jump"):
		var localJumpSpeed = jump_speed if reverseGravityEnabled else -jump_speed
		var touchFloorOrCeiling = is_on_floor() || is_on_ceiling()
		if touchedOnce == false && touchFloorOrCeiling:
			touchedOnce = true

		if touchFloorOrCeiling:
			velocity.y = localJumpSpeed
			jumpCount = 0
		elif jumpCount < max_jump:
			velocity.y = localJumpSpeed
			jumpCount += 1

func _reverseGravity():
	reverseGravityEnabled = not reverseGravityEnabled
	$Sprite.flip_v = not $Sprite.flip_v
	touchedOnce = false

func _on_Timer_timeout():
	print("[Player Script] gravity reversed!")
	_reverseGravity()
