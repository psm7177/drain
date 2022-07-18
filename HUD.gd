extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var inital_rect_size = Vector2.ZERO
# Called when the node enters the scene tree for the first time.
func _ready():
	inital_rect_size = $HP.rect_size


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Player_setHP(hp):
	$HP.rect_size = inital_rect_size - Vector2(3,0) * (10- hp)
	
	if(hp < 0):
		$Label.visible = true
