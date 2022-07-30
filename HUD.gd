extends Control

signal ui_enroll_skill(number,get_state,get_cool,get_duration,texture)

var inital_rect_size = Vector2.ZERO
var inital_rect_size_2 = Vector2.ZERO

var blue_drain_texture = load("res://UI/blue_drain.png")
var green_drain_texture = load("res://UI/green_drain.png")
var yellow_drain_texture = load("res://UI/yellow_drain.png")
var skill_frame = load("res://UI/skill_frame.png")

var state_array = {}
var skill_frame_array = {}

func _ready():
	inital_rect_size = $HP.rect_size
	inital_rect_size_2 = $Drain.rect_size
	
	$Drain.texture = green_drain_texture
	
func _process(delta):
	pass
	for key in state_array.keys():
		var state = state_array[key].call_func()
		
func _on_Player_setHP(hp):
	$HP.rect_size = inital_rect_size - Vector2(3,0) * (10- hp)
	
	if(hp < 0):
		$Label.visible = true

func _on_Player_setDrain(drain_energy,threshold,max_drain):
	$Drain.rect_size = inital_rect_size - Vector2(3,0) * (10- drain_energy)
	$Drain.texture = getDrainTexture(drain_energy,threshold,max_drain) #bad pattern
	
func getDrainTexture(drain_energy,threshold,max_drain):
	if(drain_energy <= threshold):
		return yellow_drain_texture
	if(drain_energy >= max_drain):
		return green_drain_texture
	return blue_drain_texture

func _on_Player_enroll_skill(number, get_state, get_cool, get_duration, texture):
	emit_signal("ui_enroll_skill",number, get_state, get_cool, get_duration, texture)
