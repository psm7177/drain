extends Node2D

signal state_damage(damage)

export var MAX_TICK = 5

var tick = 1
var time = 0
var tickCount = MAX_TICK
var damage = 0.5

func _ready():
	self.connect("state_damage", get_parent(), "_on_state_damage")
	
func _process(delta):
	if(time > self.tick):
		emit_signal("state_damage",damage)
		time = 0
		tickCount -= 1
	time += delta
	if(tickCount == 0):
		queue_free()
