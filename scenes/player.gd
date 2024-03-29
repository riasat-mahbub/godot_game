extends KinematicBody2D

#dungeon
onready var dungeon = get_parent().get_node("dungeon");

#check if stuck
var stuck = true;

#speed
const SPEED = 20;

#size of player
const SIZE = 32;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.



func _process(delta):
	#velocity
	var velocity = Vector2();
	
	#mouse direction
	var m_dir = get_global_mouse_position() - global_position;
	
	
	if Input.is_action_pressed("ui_up"):
		velocity.y+=1;
	if Input.is_action_pressed("ui_down"):
		velocity.y-=1;
	if Input.is_action_pressed("ui_left"):
		velocity.x+=1;
	if Input.is_action_pressed("ui_right"):
		velocity.x-=1;
	
	velocity *= (SPEED*SIZE);
	
	#move player using keys
	var collider = move_and_collide(velocity*delta); 
	
	#set player rotation using the mouse
	rotation = m_dir.angle();
	
	if collider and stuck:
		position.x += SIZE;
		position.y += SIZE;
	else:
		stuck = false;
