extends Node2D

var rng = RandomNumberGenerator.new()

export var skill_range = 100
export var skill_radius = 1.0/6.0*PI
var timer = 0
var particle = preload("res://skill/Drain/DrainParticle.tscn")
var onoff = false
# Called when the node enters the scene tree for the first time.

func _ready():
	rng.randomize()
	var height = skill_range * sin(skill_radius/2)
	$CollisionShape2D.shape.extents = Vector2(skill_range/2+10,height)
	$CollisionShape2D.position = Vector2(skill_range-20,0)
	
func _process(delta):
	timer += delta
	if(onoff && timer > 0.2):
		create_circular_sector_particle(particle)
		create_circular_sector_particle(particle)
		timer = 0
	
func create_circular_sector_particle(obj):
	var instance = particle.instance()
	var radian = rng.randf_range(-skill_radius/2,skill_radius/2)
	var distnace = rng.randf_range(skill_range-20,skill_range)
	instance.initial_position = Vector2.RIGHT.rotated(radian) * distnace
	instance.rotation = radian
	add_child(instance)
	
func _on_Player_toggleDrain(onoff):
	self.onoff = onoff
	$CollisionShape2D.disabled = !onoff
	if(!onoff):	
		for particle in get_tree().get_nodes_in_group("Particle"):
			particle.queue_free()
	
