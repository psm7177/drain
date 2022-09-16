extends KinematicBody2D

signal setHP(hp)
signal setDrain(drain_energy,drain_threshold,max_drain)
signal attack_target(target)
signal toggleDrain(onoff)
signal active_skill()
signal enroll_skill(number,get_state,get_cool,get_duration,texture)

onready var animation_tree = get_node("AnimationTree")
onready var animation_mode = animation_tree.get("parameters/playback")
#initail properties
export var SPEED = 300
export var ATTACK_COOL = 0.1
export var ATTACK_DAMAGE = 1
export var MAX_HP = 10
export var KNOCK_BACK_FORCE = 300
export var MAX_DRAIN = 10 #sec
export var DRAIN_THRESHOLD = 2

#logical properties
var direction = Vector2.ZERO
var input_attack = false
var input_drain = false
var input_skill = [false,false,false,false]

#current properties
var hp = MAX_HP
var drain_energy = MAX_DRAIN
var attack_cool = 0
var is_playing_attack = false
var is_playing_drain = false

func _ready():
	hp = MAX_HP
	drain_energy = MAX_DRAIN

func get_input():
	direction = Vector2.ZERO
	input_attack = false
	input_drain = false
	input_skill = [false,false,false,false]
	
	if(Input.is_action_pressed("up")):
		direction += Vector2.UP
	if(Input.is_action_pressed("down")):
		direction += Vector2.DOWN
	if(Input.is_action_pressed("left")):
		direction += Vector2.LEFT
	if(Input.is_action_pressed("right")):
		direction += Vector2.RIGHT
	if(Input.is_action_pressed("attack")):
		input_attack = true
	if(Input.is_action_pressed("drain")):
		input_drain = true
	for idx in input_skill.size():
		input_skill[idx] = Input.is_action_pressed(String(idx+1))

func _process(delta):
	get_input()
	if(direction.x > 0):
		$AnimatedSprite.flip_h = false
		$Drain.set_rotation_degrees(0)
	if(direction.x < 0):
		$AnimatedSprite.flip_h = true
		$Drain.set_rotation_degrees(180)
		
	if(input_drain && drain_energy > DRAIN_THRESHOLD):
		animation_mode.travel("Drain")
		is_playing_drain = true
	elif(input_attack && attack_cool <= 0):
		animation_mode.travel("Attack")
		attack_cool = ATTACK_COOL
	elif(direction.length() > 0):
		animation_mode.travel("Walk")
	else:
		animation_mode.travel("Idle")
		
	for idx in input_skill.size():
		if(input_skill[idx]): 
			self.emit_signal("active_skill",idx)
	
	if(!input_drain):
		is_playing_drain = false
		
	attack_cool -= delta
	drain_energy += delta * (-3 if is_playing_drain else 1)
	
	if(drain_energy > MAX_DRAIN):
		drain_energy = MAX_DRAIN
	if(drain_energy < 0):
		drain_energy = 0
		is_playing_drain = false
		
	emit_signal("setDrain",drain_energy,DRAIN_THRESHOLD,MAX_DRAIN)
	emit_signal("toggleDrain",is_playing_drain)

func _physics_process(delta):
	match(animation_mode.get_current_node()):
		"Drain":
			return
		"Attack":
			return
		_:
			move_and_collide(direction.normalized() * SPEED *delta) 

func _on_Area2D_area_entered(area):
	var distance:Vector2 = area.global_position - self.global_position
	var knock_back_force = distance.normalized() * KNOCK_BACK_FORCE
	if(area.is_in_group("Hurtbox")):
		self.emit_signal("attack_target",area)
		area.emit_signal("take_damage", ATTACK_DAMAGE,knock_back_force)

func _on_HurtBox_area_entered(area):
	if(area.is_in_group("Hurtbox")):
		hp -= 1
		emit_signal("setHP",hp)

func _on_Drain_area_entered(area):
	var distance:Vector2 = self.global_position - area.global_position
	var knock_back_force = distance.normalized() * KNOCK_BACK_FORCE
	if(area.is_in_group("Hurtbox")):
		print("take")
		area.emit_signal("take_drain", ATTACK_DAMAGE,knock_back_force)

func _on_Drain_area_exited(area):
	if(area.is_in_group("Hurtbox")):
		print("release")
		area.emit_signal("release_drain")
