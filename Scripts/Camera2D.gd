extends Camera2D

export (NodePath) var TargetNodePath = null
export (float) var lerpspeed = 0.05

var targetNode: Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	targetNode = get_node(TargetNodePath)
	self.position = targetNode.position

func _process(_delta):
	self.position = lerp(self.position, targetNode.position, lerpspeed)
