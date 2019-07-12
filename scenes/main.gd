extends Node2D


#func to make a dungeon
func make_dungeon():
	randomize();
	$dungeon.make_rooms();
	yield(get_tree().create_timer(1.5), 'timeout');
	$dungeon.cull_rooms();
	
	yield(get_tree(), 'idle_frame');
	$dungeon.path = $dungeon.primm();
	$dungeon.make_map();
	$player.position = $dungeon.start_room.position;
	$player.stuck = true;
	
	#delete the loading screen
	$loading_screen.queue_free();


func _ready():
	#make loading screen fill the viewport
	$loading_screen.scale= get_viewport_rect().size;
	
	make_dungeon();

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
