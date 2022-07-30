extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	var children = get_children()
	for idx in children.size():
		get_parent().connect("ui_enroll_skill",children[idx],"_on_ui_enroll_skill")
		
