tool
extends Path2D

enum ANIMATION_TYPE {
	LOOP,
	BOUNCE
}

export (int) var speed = 1 setget set_speed
export (ANIMATION_TYPE) var animation_type setget set_animation_type

onready var animationPlayer = $AnimationPlayer
onready var sprite = $PathFollow2D/Enemy/Sprite
onready var spikePlayer = $PathFollow2D/Enemy/SpikePlayer

func _ready():
	spikePlayer.play("Pulse")
	play_updated_animation(animationPlayer)
	
func _process(delta):
	sprite.rotate(rad2deg(0.5))

func set_speed(value):
	speed = value
	var ap = find_node("AnimationPlayer")
	if ap: ap.playback_speed = speed
	
func set_animation_type(value):
	animation_type = value
	var ap = find_node("AnimationPlayer")
	if ap: play_updated_animation(ap)
	
func play_updated_animation(ap):
	match animation_type:
		ANIMATION_TYPE.LOOP: ap.play("MoveAlongPathLoop")
		ANIMATION_TYPE.BOUNCE: ap.play("MoveAlongPathBounce")

func _on_Enemy_body_entered(body):
	Globals.camera.shake(100)
	Globals.controller.teleportPlayerToStartPosition(true, "moving spike")
