extends KinematicBody2D

signal dead()

var rng = RandomNumberGenerator.new()
var number_display =  preload("res://UI/NumberDisplay.tscn");
#initial propperties
export var NEAR_DISTANCE = 100
export var ATTACK_RANGE = 20
export var MAX_HP = 2 
export var SPEED = 300

#logical properties
var player:KinematicBody2D = null
var is_playing_animation = false
var idle_direction = Vector2.ZERO
var knock_back = 0.0
var nuck_back_force = Vector2.ZERO
var drain_direction = Vector2.ZERO
var drain_damage = 0.0

#current properties
var hp = MAX_HP
var is_drain = false

func _ready():
	hp = MAX_HP
	rng.randomize()
	player = get_node("../Player")
	
func _process(delta):
	if(is_dead()):
		$AnimatedSprite.play("Die")
		if($Hurtbox):
			$Hurtbox.queue_free()
		if($CollisionShape2D):
			$CollisionShape2D.queue_free()
		if($Loot):
			emit_signal("dead")
		if(is_drain):
			emit_signal("dead",player)
		return
	if(is_drain):
		$AnimatedSprite.play("Attacked")
		hp -= delta * drain_damage
	if(is_playing_animation):	
		return
	is_playing_animation = true
	if(is_in_attack_range(player)):
		$AnimatedSprite.play("Attack")
	elif(is_near(player)):
		$AnimatedSprite.play("Jump")
	else:
		var radian = rng.randf_range(0,2*PI)
		idle_direction = Vector2.UP.rotated(radian)
		$AnimatedSprite.play("Idle")

func _physics_process(delta):
	if($AnimatedSprite.animation == "Jump"):
		move_and_slide(get_direction(player) * SPEED * delta)
	if($AnimatedSprite.animation == "Idle"):
		move_and_slide(idle_direction * SPEED * delta)
	
	if(knock_back > 0):
		var nuck_back_velocity = lerp(Vector2.ZERO, nuck_back_force, knock_back / 0.2)
		move_and_slide(nuck_back_velocity)
		knock_back -= delta
	elif(is_drain):
		move_and_slide(drain_direction)

func _on_AnimatedSprite_animation_finished():
	is_playing_animation = false
	if($AnimatedSprite.animation == "Die"):
		queue_free()

func is_dead():
	return hp <= 0
	
func is_near(obj:Node2D):
	return get_distance(obj) <= NEAR_DISTANCE

func is_in_attack_range(obj:Node2D):
	return get_distance(obj) <= ATTACK_RANGE

func get_distance(obj:Node2D):
	return (self.position-obj.position).length()

func get_direction(obj:Node2D):
	return (obj.position-self.position).normalized()

func _on_Hurtbox_take_damage(damage,force):
	$AnimatedSprite.play("Attacked")
	knock_back = 0.2
	nuck_back_force = force
	hp -= damage
	disyplay_number(damage)

func _on_state_damage(damage):
	hp -= damage
	disyplay_number(damage)

func _on_Hurtbox_take_drain(damage, drain_direction):
	$AnimatedSprite.play("Attacked")	
	knock_back = 0.2
	drain_direction = drain_direction
	drain_damage = damage
	is_drain = true

func _on_Hurtbox_release_drain():
	is_drain = false

func disyplay_number(number):
	var display = number_display.instance()
	display.number = number
	add_child(display)
	display.position = Vector2(0,-30)
