extends KinematicBody2D

signal setHP(hp)

onready var animation_tree = get_node("AnimationTree")
onready var animation_mode = animation_tree.get("parameters/playback")
#initail properties
export var SPEED = 300
export var ATTACK_COOL = 0.1
export var ATTACK_DAMAGE = 1
export var MAX_HP = 10
export var KNOCK_BACK_FORCE = 300

#logical properties
var direction = Vector2.ZERO
var input_attack = false
var is_playing_attack = false

#current properties
var hp = MAX_HP
var attack_cool = 0

func _ready():
	pass # Replace with function body.

func get_input():
	direction = Vector2.ZERO
	input_attack = false
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

func _process(delta):
	get_input()
	if(direction.x > 0):
		$AnimatedSprite.flip_h = false
	if(direction.x < 0):
		$AnimatedSprite.flip_h = true
	$AnimatedSprite
	if(input_attack && attack_cool <= 0):
		animation_mode.travel("Attack")
		attack_cool = ATTACK_COOL
	elif(direction.length() > 0):
		animation_mode.travel("Walk")
	else:
		animation_mode.travel("Idle")
	attack_cool -= delta	

func _physics_process(delta):
	move_and_collide(direction.normalized() * SPEED *delta) 

func _on_Area2D_area_entered(area):
	var distance:Vector2 = area.global_position - self.global_position
	var knock_back_force = distance.normalized() * KNOCK_BACK_FORCE
	if(area.is_in_group("Hurtbox")):
		area.emit_signal("take_damage", ATTACK_DAMAGE,knock_back_force)


func _on_HurtBox_area_entered(area):
	if(area.is_in_group("Hurtbox")):
		hp -= 1
		emit_signal("setHP",hp)
			
