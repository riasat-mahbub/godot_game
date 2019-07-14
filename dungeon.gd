extends Node2D

#asset imports
var room = preload("res://assets/room.tscn");
onready var Map = get_parent().get_node("TileMap");

#important rooms
var start_room;
var end_room;

#array of room positions
var room_pos = [];

#variable storing all nodes
var path

#cull percentage
const CULL = 0.5

#Tile and room constants
const TILE_SIZE = 32; #(in px)
const ROOM_NO = 20;

#room dimensions(in tile size)
const MAX_SIZE = 20
const MIN_SIZE = 5

#spread
const HSPREAD = 2000;
const VSPREAD = 2000;

#function to make rooms
func make_rooms():
	for i in ROOM_NO:
		var width = MIN_SIZE + randi() % (MAX_SIZE-MIN_SIZE+1);
		var height = MIN_SIZE + randi() % (MAX_SIZE-MIN_SIZE+1);
		var r = room.instance();
		var pos = Vector2();
		pos.x = rand_range(-HSPREAD, HSPREAD);
		pos.y = rand_range(-VSPREAD, VSPREAD);
		r.make_room(pos, Vector2(width,height) * TILE_SIZE );
		
		add_child(r);

#func to find the starting room
func find_start_room():
	var min_x = INF;
	
	for room in get_children():
		if room.position.x < min_x:
			min_x = room.position.x;
			start_room = room;


#func to find the last room
func find_end_room():
	var max_x = -INF;
	
	for room in get_children():
		if room.position.x > max_x:
			max_x = room.position.x;
			end_room = room;

#func to make a map of room
func make_map():
	
	#clear previous map
	Map.clear();
	
	#find start and end rooms
	find_start_room();
	find_end_room();
	
	#find whole area
	var full_rect = Rect2();
	for room in get_children():
		var r = Rect2(room.position-room.size, room.get_node("CollisionShape2D").shape.extents*2);
		full_rect = full_rect.merge(r);
	
	#positions
	var topLeft = Map.world_to_map(full_rect.position);
	var bottomRight = Map.world_to_map(full_rect.end);
	
	#set walls all around
	for x in range(topLeft.x, bottomRight.x):
		for y in range(topLeft.y, bottomRight.y):
			Map.set_cell(x,y,0);
	
	#array for string already made corridors
	var cor = [];
	
	#carving the rooms
	for room in get_children():
		var sz = (room.size/ TILE_SIZE).floor();
		var pos = Map.world_to_map(room.position);
		var tl = (room.position/ TILE_SIZE).floor()- sz;
		
		for x in range(2, sz.x*2 -1):
			for y in range(2, sz.y*2 -1):
				Map.set_cell(tl.x+x, tl.y+y, 1);
			#carve the corridors

		var p = path.get_closest_point(Vector3(room.position.x,
                                    room.position.y, 0));
		for c in path.get_point_connections(p):
			if not c in cor:
				var start = Map.world_to_map(Vector2(path.get_point_position(p).x, path.get_point_position(p).y));
				var end   = Map.world_to_map(Vector2(path.get_point_position(c).x, path.get_point_position(c).y));
				carve_cor(start,end);
			cor.append(p);
	
	#delete all collisionshapes
	for room in get_children():
		room.get_node("CollisionShape2D").queue_free();

#func to create corridors bewteen 2 points

func carve_cor(pos1, pos2):
	#check if cor is left or right
	var x_dif = -sign(pos1.x-pos2.x);
	
	#check if cor is up or down
	var y_dif = -sign(pos1.y-pos2.y);
	
	#if both points are on the same x axis, take a random dir
	if x_dif == 0:
		x_dif = pow(-1.0, randi() % 2);
	
	#if both points are on same y axis, take a random dir
	if y_dif == 0:
		y_dif = pow(-1.0, randi() % 2);
	
	#choose if we from x to y or y to x
	var x_y = pos1;
	var y_x = pos2;
	
	#randomly interchange descions
	if (randi() % 2 == 1):
		x_y = pos2;
		y_x = pos1;
	
	#carve all the corridors in x axis
	for i in range(pos1.x, pos2.x, x_dif):
		Map.set_cell(i, x_y.y, 1);
		Map.set_cell(i, x_y.y+y_dif, 1);
		
	#carve all the corridors in y axis
	for j in range(pos1.y, pos2.y, y_dif):
		Map.set_cell(y_x.x, j, 1);
		Map.set_cell(y_x.x+x_dif, j, 1);
	




#primms algo
func primm():
	var p = AStar.new();
	p.add_point(p.get_available_point_id(), room_pos.pop_front());
	
	while room_pos:
		
		var min_dis = INF;
		var min_point = null;
		var cur_point = null;
		
		for i in p.get_points():
			i = p.get_point_position(i);
			for j in room_pos:
				
				if i.distance_to(j) < min_dis:
					min_dis = i.distance_to(j);
					min_point = j;
					cur_point = i;
		
		var n_id = p.get_available_point_id();
		p.add_point(n_id, min_point);
		p.connect_points(p.get_closest_point(cur_point), n_id);
		
		room_pos.erase(min_point);
	
	return p;



func cull_rooms():
	for room in get_children():
		if randf() < CULL:
			room.queue_free();
		else:
			room.mode = RigidBody2D.MODE_STATIC;
			room_pos.append(Vector3(room.position.x, room.position.y, 0));


func _ready():
	pass