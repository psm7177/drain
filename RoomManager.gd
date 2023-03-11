extends Node2D

export var count = 5

const RoomScene = preload("res://Room/Room.tscn")
var roomArray = []
var roomInGraph = []

enum {LEFT=0,UP=1,RIGHT=2,DOWN=3}

var allocatedArray = []

var directionArray = [Vector2.LEFT ,Vector2.UP,Vector2.RIGHT,Vector2.DOWN]
var gapArray = [Vector2.LEFT ,Vector2.UP,Vector2.RIGHT,Vector2.DOWN]

var startNode:Room = null
func _ready():
	randomize()
	var gap = 200
	var expend_x = 1024 + gap
	var expend_y = 600 + gap
	for idx in gapArray.size():
		gapArray[idx].x *= expend_x
		gapArray[idx].y *= expend_y
		
	for i in range(count):
		var room = RoomScene.instance()
		roomArray.append(room)
		add_child(room)
		
	var node = roomArray.pop_back()
	var home_node = node
	var boss_node = null
	while node != null:
		var unlink_edges = []
		for vertex in roomInGraph:
			var edges = funcref(vertex,"get_unlinked_edge").call_func()
			for e in edges:
				if !allocatedArray.has(vertex.roomPos+directionArray[e[1]]):
					unlink_edges.append([vertex,e])
		
		if unlink_edges.size() > 0:
			var element  = unlink_edges[randi() % unlink_edges.size()]
			var vertex = element[0]
			var link_func = element[1][0]
			var direction = element[1][1]
			funcref(node,"link_node").call_funcv([vertex.get_path(),(direction +2 )% 4])
			link_func.call_funcv([node.get_path(),direction])
			node.roomPos = vertex.roomPos + directionArray[direction]
			node.position = vertex.position + gapArray[direction]
			
		boss_node = node
		allocatedArray.append(node.roomPos)
		roomInGraph.append(node)
		node = roomArray.pop_back()
	
	assert(boss_node, "ERROR: Room must have a boss room.");
	
	home_node.is_home = true
	boss_node.is_boss = true
	
	home_node.spawn_player(get_node("/root/main/Player"))
