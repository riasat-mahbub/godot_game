extends Node2D

var current_level;

#func to make a dungeon
func make_dungeon():
	
	#start random seeding
	randomize();
	
	#make the loading screen visible
	$loading_screen.visible = true;
	
	#make some rooms
	$dungeon.make_rooms();
	
	#after some time delete some rooms
	yield(get_tree().create_timer(1.5), 'timeout');
	$dungeon.cull_rooms();
	
	#add an extra frame 
	yield(get_tree(), 'idle_frame');
	
	#make an mst with the room
	$dungeon.path = $dungeon.primm();
	
	#use the data to make a tilemap
	$dungeon.make_map();
	
	#spawn player
	$player.position = $dungeon.start_room.position;
	$player.stuck = true;
	
	#spawn whirlpool
	$whirlpool.position = $dungeon.end_room.position;
	
	#make loading screen invisible
	$loading_screen.visible = false;

#func to destroy a dungeon
func destroy_dungeon():
	for room in $dungeon.get_children():
		room.queue_free();


func _ready():
	#always start at level 1
	current_level = 1;
	
	#make loading screen fill the viewport
	$loading_screen.scale= get_viewport_rect().size;
	
	make_dungeon();

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
