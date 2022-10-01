extends Node2D

export (NodePath) var ActionableItemPath = null
export (bool) var state = false
export (int) var move_time = 1.5
export (int) var opening_delay = 0.2
export (Vector2) var move_to = Vector2.DOWN * 96

onready var door = $Static
onready var tween = $MoveTween

var follow = Vector2.ZERO
var targetNode: Node2D

func _ready():
	set_physics_process(false)
	if state:
		door.position = move_to
	targetNode = get_node(ActionableItemPath)
	targetNode.connect("lever_turned", self, "_trigger")

func _physics_process(delta):
	door.position = door.position.linear_interpolate(follow, 0.075)

func _trigger(leverState):
	tween.stop_all()
	set_physics_process(true)
	
	if leverState:
		tween.interpolate_property(self, "follow", Vector2.ZERO, move_to, move_time, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, opening_delay)
		tween.start()
	else:
		tween.interpolate_property(self, "follow", move_to, Vector2.ZERO, move_time, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, opening_delay)
		tween.start()

func _on_MoveTween_tween_all_completed():
	targetNode.unlock()
	yield(get_tree().create_timer(move_time / 2), "timeout")
	set_physics_process(false)
