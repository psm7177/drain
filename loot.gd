extends Node2D

# Called when the node enters the scene tree for the first time.


func _ready():
	pass # Replace with function body.

func _on_Monster_dead():
	var children = get_children();
	for child in children:
		self.remove_child(child)
		get_root().add_child(child)

func get_root():
	return get_tree().root.get_child(0)
