extends Node2D

func _ready():
	pass 

func _on_Monster_dead(player:Node2D):
	var children = get_children();
	for child in children:
		self.remove_child(child)
		player.get_node("SkillManager").emit_signal("enroll_skil_to_skill_manager",child)

func get_root():
	return get_tree().root.get_child(0)

