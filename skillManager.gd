extends Node2D


signal enroll_skil_to_skill_manager(child)

var fire_sprite_frame = preload("res://skill/FireStat_sprite_frame.tres")

func _ready():
	enroll_children()

func enroll(child,idx,texture):
	get_parent().connect("attack_target", child, "_on_attack_target")
	get_parent().connect("active_skill", child, "_on_active_skill")
	child.id = idx
	get_parent().emit_signal("enroll_skill",idx,funcref(child, "get_skill_state"),funcref(child, "get_skill_cool"),funcref(child, "get_skill_duration"),texture)

func enroll_children():
	print(get_children())
	var children = get_children()
	for idx in children.size():
		var child = children[idx]
		
		var texture = child.texture 
		enroll(child,idx,texture)

func _on_SkillManager_enroll_skil_to_skill_manager(child):
	add_child(child)
	enroll_children()
	
