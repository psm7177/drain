extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export var id = 0

var stateRef:FuncRef = null
var coolRef:FuncRef  = null
var durationRef:FuncRef  = null
# Called when the node enters the scene tree for the first time.

func _ready():
	$Tween.interpolate_property($SkillImg, "modulate:a", 1.0, 0.0, 0.3,Tween.TRANS_SINE,Tween.EASE_OUT)
	$Tween.interpolate_property($SkillImg, "modulate:a", 0.0, 1.0, 0.3,Tween.TRANS_SINE, Tween.EASE_OUT_IN,0.3)
	
func blink():	
	$Tween.start()
	
func _process(delta):
	if stateRef != null:
		var state = stateRef.call_func() # ready|cool|active
		if state == "ready":
			$shadow.hide()
		elif state == "cool":
			$shadow.show()
			$Tween.stop_all()
			$SkillImg.modulate.a = 1
			var cool = 1
			if coolRef != null:
				cool = coolRef.call_func()
			$shadow.set_position(Vector2(0,(1-cool)*48))
			$shadow.rect_scale=Vector2(3,cool*3)
		else:
			blink()

func _on_ui_enroll_skill(number,get_state,get_cool,get_duration,texture):
	if number == id:
		get_node("SkillImg").texture = texture
		stateRef = get_state
		coolRef = get_cool
		durationRef = get_duration
		
func _on_ui_remove_skill(number):
	if number == id:
		get_node("SkillImg").texture = null
		stateRef = null
		coolRef = null
		durationRef = null
