extends Area2D

export var direction = 0

func _ready():
	pass # Replace with function body.

func _on_Portal_body_entered(body):
	if body.name == 'Player':
		var room_path = get_node('../').edgeArray[direction]
		if room_path != null:
			var room = get_node(room_path)
			room.spawn_player(body)
