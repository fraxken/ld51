extends KinematicBody2D

export (int) var speed = 50
export (int) var max_speed = 150
export (int) var jump_speed = 300
export (int) var max_jump = 1

onready var gravityTimer = $GravityTimer
onready var dieTimer = $DieTimer

var velocity = Vector2.ZERO
var jumpCount: int = 0

var friction = false

# GRAVITY
var touchedGroundAtLeastOnce = false

# DASH
var direction = Vector2.ZERO
var canDash = true

func _ready():
	$Sprite.material.set_shader_param("flash_modifier", 0)
	Globals.playerCanMove = true
	Globals.player = self
	
	# TODO: EDIT THIS LATER TO PUT 10
	gravityTimer.set_wait_time(10)
	gravityTimer.start()
	
	dieTimer.set_wait_time(0.1)
	dieTimer.connect("timeout", self, "_die_timeout")

func _input(event):
	if event.is_action_pressed("gravity"):
		gravityTimer.start()
		_reverseGravity()
		
func die():
	_resetGravity()
	gravityTimer.stop()
	gravityTimer.start(10)
	$AnimationPlayer.play("Idle")
	hit()
	set_physics_process(false)
	dieTimer.start()

func _die_timeout():
	var nodes = Utils.findNodeDescendantsInGroup(get_node("/root"), "Reset")
	for node in nodes:
		if node.has_method("reset_initial"): node.reset_initial()
	set_physics_process(true)
		
func dash():
	if Input.is_action_just_pressed("dash") && canDash:
		# TODO: fix velocity ?
		velocity = direction.normalized() * 1000
		canDash = false
		yield(get_tree().create_timer(1), "timeout")
		canDash = true

func jump(isOnGround: bool):
	var localJumpSpeed = jump_speed if Globals.reverseGravityEnabled else -jump_speed
	if touchedGroundAtLeastOnce == false && isOnGround:
		touchedGroundAtLeastOnce = true

	if isOnGround:
		velocity.y = localJumpSpeed
		jumpCount = 0
	elif jumpCount < max_jump:
		velocity.y = localJumpSpeed
		jumpCount += 1

func computeDirection():
	if Input.is_action_pressed("right"):
		direction = Vector2(1, 0)
		velocity.x = min(velocity.x + speed, max_speed)
		$Sprite.flip_h = false
		$AnimationPlayer.play("Walk")
	elif Input.is_action_pressed("left"):
		direction = Vector2(-1, 0)
		velocity.x = max(velocity.x - speed, -max_speed)
		$Sprite.flip_h = true
		$AnimationPlayer.play("Walk")
	else:
		$AnimationPlayer.play("Idle")
		friction = true

func _physics_process(delta):
	velocity.y += -(Globals.gravity * delta) if Globals.reverseGravityEnabled else (Globals.gravity * delta)
	friction = false
	if Globals.playerCanMove == true:
		computeDirection()
	
	if Input.is_action_pressed("use"):
		if $RayCast2D.is_colliding():
			check_box_collision()
		else:
			$RayCast2D.cast_to.x = direction.x * 10
			
	var allowActions = true
	if (!is_on_floor() && Globals.reverseGravityEnabled == false) || (!is_on_ceiling() && Globals.reverseGravityEnabled == true):
		allowActions = false
	
	if allowActions or touchedGroundAtLeastOnce:
		var isOnGround = is_on_floor() || is_on_ceiling()
		
		if isOnGround:
			dash()
			if friction == true:
				velocity.x = lerp(velocity.x, 0, 0.2)
		else:
			if friction:
				velocity.x = lerp(velocity.x, 0, 0.05)
		
		if Input.is_action_just_pressed("jump"):
			jump(isOnGround)
	
	velocity = move_and_slide(velocity, Vector2.UP)
	for i in get_slide_count():
		var collision = get_slide_collision(i)
		if collision.collider.has_method("collide_with"):
			collision.collider.collide_with(collision, self)
	pass
	
func hit():
	$FlashPlayer.play("Flash")
	Globals.camera.shake(100)

func _resetGravity():
	var nodes = Utils.findNodeDescendantsInGroup(get_node("/root"), "Gravity")
	for node in nodes:
		if node.has_method("reset_gravity"): node.reset_gravity()
		
	Globals.timerBar.reset()
	Globals.reverseGravityEnabled = false
	$Sprite.flip_v = false
	touchedGroundAtLeastOnce = false
	
func _reverseGravity():
	var nodes = Utils.findNodeDescendantsInGroup(get_node("/root"), "Gravity")
	for node in nodes:
		if node.has_method("reverse_gravity"): node.reverse_gravity()
	
	Globals.camera.shake(100)
	Globals.reverseGravityEnabled = not Globals.reverseGravityEnabled
	$Sprite.flip_v = not $Sprite.flip_v
	touchedGroundAtLeastOnce = false

func _on_Timer_timeout():
	print("[Player Script] gravity reversed!")
	_reverseGravity()
	
func check_box_collision():
	var collider = $RayCast2D.get_collider()
	if collider.name.find("Box") != -1:
		collider.move(velocity)
