extends Sprite

enum {LEFT=0,UP=1,RIGHT=2,DOWN=3}

var edgeArray = [null,null,null,null]

var roomPos = Vector2.ZERO

func _ready():
	pass

func get_unlinked_edge():
	var ret = []
	for idx in edgeArray.size():
		if(edgeArray[idx] == null):
			ret.append([funcref(self,"link_node"),idx])
	return ret
	
func link_node(node_path:NodePath,idx:int):
	print(edgeArray[idx],node_path,['left','up','right','down'][idx])
	edgeArray[idx] = node_path
