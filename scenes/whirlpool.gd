extends Sprite

func on_body_entered(body):
	
	#if a player enters the whirlpool, reset the dungeon
	if body.name == "player":
		get_parent().destroy_dungeon();
		get_parent().get_node("TileMap").clear();
		get_parent().make_dungeon();

func _ready():
	$Area2D.connect("body_entered", self, "on_body_entered");