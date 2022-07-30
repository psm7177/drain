extends Sprite

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var initial_position = Vector2.ZERO

var progress = 0.7

func _ready():
	position = initial_position
	$AnimationPlayer.play("New Anim")
	
func _process(delta):
	progress -= delta
	position = lerp(Vector2.ZERO,initial_position,progress/0.7)
	if(progress <= 0):
		queue_free()
