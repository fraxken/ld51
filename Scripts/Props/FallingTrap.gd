extends Node2D

export (NodePath) var ActionableItemPath = null
export (int) var move_time = 3.0
export (int) var opening_delay = 0.5
export (Vector2) var move_to = Vector2.DOWN * 96
export (int) var idle_duration = 2.0

onready var fallingTrap = $Static
onready var tween = $MoveTween
onready var collider = $FreeArea/CollisionShape2D

var follow = Vector2.ZERO
var targetNode: Node2D

func _ready():
	targetNode = get_node(ActionableItemPath)
	targetNode.connect("reactiveArea_turned", self, "_open", [], CONNECT_ONESHOT)

func _physics_process(delta):
	fallingTrap.position = fallingTrap.position.linear_interpolate(follow, 0.075)

func _open(state):
	tween.interpolate_property(self, "follow", Vector2.ZERO, move_to, move_time, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, opening_delay)
	tween.interpolate_property(self, "follow", move_to, Vector2.ZERO, move_time, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, move_time + idle_duration * 2)
	tween.start()
	
func _on_FreeArea_body_entered(body):
	if (body.get_name() == "Player2D"):
		print("game over")