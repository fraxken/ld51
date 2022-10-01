extends KinematicBody2D

export (int) var speed = 150
export (int) var max_speed = 200
export (int) var jump_speed = 200
export (int) var gravity = 350
export (int) var max_jump = 1

onready var gravityTimer = get_node("Timer")

var velocity = Vector2.ZERO
var jumpCount: int = 0
var reverseGravityEnabled = false
var touchedOnce = false

func _ready():
	gravityTimer.set_wait_time(10)
	gravityTimer.start()

func _input(event):
	if event.is_action_pressed("use"):
		gravityTimer.start()
		_reverseGravity()
		
func get_input():
	velocity.x = 0
	if Input.is_action_pressed("right"):
		velocity.x += speed
		$Sprite.flip_h = false
	if Input.is_action_pressed("left"):
		velocity.x -= speed
		$Sprite.flip_h = true

func _physics_process(delta):
	get_input()
	if velocity.x == 0:
		$AnimationPlayer.play("Idle")
	else:
		$AnimationPlayer.play("Walk")
		
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
