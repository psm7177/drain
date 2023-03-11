extends Sprite

enum {LEFT=0,UP=1,RIGHT=2,DOWN=3}

var edgeArray = [null,null,null,null]

var roomPos = Vector2.ZERO
var weight = 0
var is_boss = false
var is_home = false

func _ready():
	pass
	
func spawn_player(player:Object):
	player.position = self.position

func get_unlinked_edge():
	var ret = []
	for idx in edgeArray.size():
		if(edgeArray[idx] == null):
			ret.append([funcref(self,"link_node"),idx])
	return ret
	
func link_node(node_path:NodePath,idx:int):
	edgeArray[idx] = node_path
