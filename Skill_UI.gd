extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


var skill_box = preload("res://skillBox.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	for idx in range(0,4):
		var box = skill_box.instance()
		box.id = idx
		add_child(box)
		box.set_position(Vector2(50*idx,1))
		
	var children = get_children()
	for idx in children.size():
		get_parent().connect("ui_enroll_skill",children[idx],"_on_ui_enroll_skill")
		
