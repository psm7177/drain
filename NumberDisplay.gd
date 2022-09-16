extends Sprite


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export var number = 0

var number_texture = preload("res://UI/Numbers 7x10.png")
# Called when the node enters the scene tree for the first time.


func _ready():
	var str_number = String(number)
	print(str_number)
	var image = makeImage(str_number.length())
	for s in str_number.length():
		if str_number[s] == '.':
			var offset = int(str_number[s])
			image.blend_rect(number_texture.get_data(),Rect2(7*10,0,7,10),Vector2(7*s,0))
		else:
			var offset = int(str_number[s])
			image.blend_rect(number_texture.get_data(),Rect2(7*offset,0,7,10),Vector2(7*s,0))
	
	image.unlock()
	var imageTexture = ImageTexture.new()
	imageTexture.create_from_image(image,1)
	texture = imageTexture
	self.modulate = Color("#ff0000")

func makeImage(digits):
	var image = Image.new()
	image.lock()
	image.create(7*digits,10,true,number_texture.get_data().get_format() )
	image.fill(Color(0,0,0,0))	
	return image

func _process(delta):
	modulate.a -= delta
	position += Vector2.UP * delta * 10
	
	if(modulate.a < 0):
		queue_free()
	
