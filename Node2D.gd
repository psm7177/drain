extends Node2D


var fire_frame:SpriteFrames = preload("res://skill/FireStat_sprite_frame.tres");

func _ready():
	var children = get_children()
	for idx in children.size():
		var child = children[idx]
		get_parent().connect("attack_target", child, "_on_attack_target")
		get_parent().connect("active_skill", child, "_on_active_skill")
		fire_frame.get_frame("default")
		get_parent().emit_signal("enroll_skill",idx,child.get_skill_state,texture)
		
		 


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
