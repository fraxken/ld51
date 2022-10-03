extends KinematicBody2D

export (int) var speed = 50
export (int) var max_speed = 150
export (int) var jump_speed = 270
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
	
	dieTimer.set_wait_time(0.2)
	dieTimer.connect("timeout", self, "_die_timeout")

func _input(event):
	if event.is_action_pressed("gravity"):
		gravityTimer.start()
		_reverseGravity()
		
func die():
	_resetGravity()
	$AnimationPlayer.play("Idle")
	hit()
	set_physics_process(false)
	_reset_velocity()
	dieTimer.start()
	
func _reset_velocity():
	velocity = Vector2.ZERO
	direction = Vector2.ZERO

func _die_timeout():
	var nodes = Utils.findNodeDescendantsInGroup(get_node("/root"), "Reset")
	for node in nodes:
		if node.has_method("reset_initial"): node.reset_initial()
		
	Globals.timerBar.start()
	gravityTimer.start(10)
	set_physics_process(true)
		
func dash():
	if Input.is_action_just_pressed("dash") && canDash:
		# TODO: fix velocity ?
		var player_was_moving = velocity.x != 0
		if player_was_moving:
			max_speed *= 10
		
		velocity = direction.normalized() * 1000
		canDash = false
		
		var dash_cooldown = 1
		if player_was_moving:
			var dash_duration = 0.05
			dash_cooldown -= dash_duration
			yield(get_tree().create_timer(dash_duration), "timeout")
			max_speed = 150
			
		yield(get_tree().create_timer(dash_cooldown), "timeout")
		canDash = true

func jump(isOnGround: bool):
	var localJumpSpeed = jump_speed if Globals.reverseGravityEnabled else -jump_speed
	if touchedGroundAtLeastOnce == false && isOnGround:
		touchedGroundAtLeastOnce = true

	if isOnGround or nextToWall():
		if nextToWall() and not is_on_floor() and not is_on_ceiling():
			var jump_power = 300
			var jump_direction = jump_power if nextToLeftWall() else -jump_power
			velocity.x = jump_direction
		velocity.y = localJumpSpeed
		jumpCount = 0
	elif jumpCount < max_jump:
		velocity.y = localJumpSpeed
		
		if not nextToWall():
			jumpCount += 1

func nextToWall():
	return nextToRightWall() or nextToLeftWall()

func nextToRightWall():
	return $RigthWall.is_colliding()

func nextToLeftWall():
	return $LeftWall.is_colliding()

func computeDirection():
	if Input.is_action_pressed("ui_right"):
		direction = Vector2(1, 0)
		velocity.x = min(velocity.x + speed, max_speed)
		$Sprite.flip_h = false
		$AnimationPlayer.play("Walk")
	elif Input.is_action_pressed("ui_left"):
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
	
	if Input.is_action_pressed("ui_select"):
		if $RayCast2D.is_colliding():
			check_box_collision()
		else:
			$RayCast2D.cast_to.x = direction.x * 10
			
	var allowActions = true
	if (!is_on_floor() && Globals.reverseGravityEnabled == false) || (!is_on_ceiling() && Globals.reverseGravityEnabled == true):
		allowActions = false
	
	if nextToWall() and not is_on_floor() and not is_on_ceiling() and not Input.is_action_pressed("jump"):
		var slide_power = 60
		var slide = slide_power if not Globals.reverseGravityEnabled else -slide_power
		velocity.y = slide
	
	if allowActions or touchedGroundAtLeastOnce:
		var isOnGround = is_on_floor() || is_on_ceiling()
		
		if isOnGround:
			dash()
			if friction == true:
				velocity.x = lerp(velocity.x, 0, 0.2)
		else:
			if friction:
				velocity.x = lerp(velocity.x, 0, 0.05)
		
		if Input.is_action_just_pressed("ui_up"):
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
	gravityTimer.stop()
	
	var nodes = Utils.findNodeDescendantsInGroup(get_node("/root"), "Gravity")
	for node in nodes:
		if node.has_method("reset_gravity"): node.reset_gravity()
		
	_reset_velocity()
	Globals.timerBar.stop()
	Globals.reverseGravityEnabled = false
	$Sprite.flip_v = false
	touchedGroundAtLeastOnce = false
	
func _reverseGravity():
	var nodes = Utils.findNodeDescendantsInGroup(get_node("/root"), "Gravity")
	for node in nodes:
		if node.has_method("reverse_gravity"): node.reverse_gravity()
	
	Globals.timerBar.reset()
	Globals.camera.shake(100)
	Globals.reverseGravityEnabled = not Globals.reverseGravityEnabled
	$Sprite.flip_v = not $Sprite.flip_v
	touchedGroundAtLeastOnce = false

func _on_Timer_timeout():
	_reverseGravity()
	
func check_box_collision():
	var collider = $RayCast2D.get_collider()
	if collider.name.find("Box") != -1 && collider.has_method("move"):
		collider.move(velocity)
