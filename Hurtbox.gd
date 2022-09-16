extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

signal take_damage(damage,force)
signal take_drain(drain_damage, drain_direction)
signal release_drain()
