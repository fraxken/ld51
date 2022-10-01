extends Area2D

var velocity = Vector2.ZERO
var direction = Vector2.RIGHT
var speed = 60

func _process(delta):
	var velocity = direction * speed
	
	position += velocity * delta
	
func configure(newDirectionValue: Vector2, newSpeed):
	direction = newDirectionValue
	speed = newSpeed
	
func _on_Projectile_body_entered(body):
	if body.has_method("hit"):
		body.hit();
	queue_free()
