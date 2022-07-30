extends Node2D


var fire_sprite_frame = preload("res://skill/FireStat_sprite_frame.tres")

func _ready():
	var children = get_children()
	for idx in children.size():
		var child = children[idx]
		get_parent().connect("attack_target", child, "_on_attack_target")
		get_parent().connect("active_skill", child, "_on_active_skill")
		
		var texture = fire_sprite_frame.get_frame("default",0)
		
		get_parent().emit_signal("enroll_skill",idx,funcref(child, "get_skill_state"),funcref(child, "get_skill_cool"),funcref(child, "get_skill_duration"),texture)
		
		 


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
