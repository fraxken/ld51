extends Node2D

export (NodePath) var ActionableItemPath = null
export (NodePath) var ActionableItemPathBis = null
export (bool) var state = false
export (int) var move_time = 1.5
export (int) var opening_delay = 0.2
export (Vector2) var move_to = Vector2.DOWN * 96

onready var door = $Static
onready var tween = $MoveTween

var follow = Vector2.ZERO
var targetNode: Node2D
var targetNode2: Node2D

func _ready():
	tween.stop_all()
	targetNode = get_node(ActionableItemPath)
	_connectNode(targetNode)
	if ActionableItemPathBis != null:
		targetNode2 = get_node(ActionableItemPathBis)
		_connectNode(targetNode2)
		
	if state:
		door.position = move_to
		follow = move_to
		
func _connectNode(node: Node2D):
	node.connect("lever_turned", self, "_trigger")
	if node.has_method("register"):
		node.register()
		
func _physics_process(delta):
	door.position = door.position.linear_interpolate(follow, 0.075)

func _trigger(updateState = true):
	if state:
		close()
	else:
		open()
	if updateState:
		state = not state
		
func open():
	tween.stop_all()
	tween.interpolate_property(self, "follow", Vector2.ZERO, move_to, move_time, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, opening_delay)
	tween.start()
	
func close():
	tween.stop_all()
	tween.interpolate_property(self, "follow", move_to, Vector2.ZERO, move_time, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, opening_delay)
	tween.start()

func _on_MoveTween_tween_all_completed():
	targetNode.unlock()
	if targetNode2:
		targetNode2.unlock()
