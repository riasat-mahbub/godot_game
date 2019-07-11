extends RigidBody2D

#size
var size;

#function to make a room with position and size
func make_room(pos, sz):
	position = pos;
	size = sz;
	var shape = RectangleShape2D.new();
	shape.extents = size;
	shape.custom_solver_bias = .75;
	$CollisionShape2D.shape = shape;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
