extends Node2D

var fireState = preload("res://State/FireState.tscn");
export var sprite_frame = preload("res://skill/FireStat_sprite_frame.tres")
var texture = null

export var SKILL_COOL = 4
export var SKILL_DURAION = 2

var skill_cool = 0
var skill_duration = 0

var id = -1

func _ready():
	texture = sprite_frame.get_frame("default",0)
	
func _process(delta):
	if skill_duration >= 0:
		skill_duration -= delta
		return
	if skill_cool >= 0:
		skill_cool -= delta	
	
func _on_attack_target(target):
	if skill_duration >= 0:
		target.get_parent().add_child(fireState.instance())

func _on_active_skill(number):
	if id	== number:
		if skill_cool <= 0:
			skill_duration = SKILL_DURAION
			skill_cool = SKILL_COOL

func get_skill_state():
	if(skill_duration > 0):
		return "active"
	if(skill_cool > 0):
		return "cool"
	return "ready"
	
func get_skill_cool():
	return skill_cool / SKILL_COOL

func get_skill_duration():
	return skill_duration / SKILL_DURAION
