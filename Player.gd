extends KinematicBody2D

var moveSpeed : int = 250
var vel = Vector2()
var facingDir = Vector2()
# onready var rayCast = $RayCast2D

onready var anim = $PlayerSprite

# Called when the node enters the scene tree for the first time.
func _ready():
	print("and player pos:")
	print(position.y)
	print("and player z index:")
	print(z_index)
	pass # Replace with function body.

func _physics_process (delta):
	if Input.is_action_just_pressed("ui_accept"):
		for body in $PickupArea.get_overlapping_bodies():
				print("found body!!!")
				print(body.get_name())
				#body.free()
		#get last collide;

	vel = Vector2()
	# inputs
	if Input.is_action_pressed("ui_up"):
		$PickupArea.position.x = 0
		$PickupArea.position.y = -4
		vel.y -= 1
		facingDir = Vector2(0, -1)
	if Input.is_action_pressed("ui_down"):
		$PickupArea.position.x = 0
		$PickupArea.position.y = 4
		vel.y += 1
		facingDir = Vector2(0, 1)
	if Input.is_action_pressed("ui_left"):
		$PickupArea.position.x = -8
		$PickupArea.position.y = 0
		vel.x -= 1
		facingDir = Vector2(-1, 0)
	if Input.is_action_pressed("ui_right"):
		$PickupArea.position.x = 8
		$PickupArea.position.y = 0
		vel.x += 1
		facingDir = Vector2(1, 0)
  
	# normalize the velocity to prevent faster diagonal movement
	vel = vel.normalized()
  
	# move the player
	move_and_slide(vel * moveSpeed, Vector2.ZERO)
#	for i in get_slide_count():
#		var collision = get_slide_collision(i)
#		print("I collided with ", collision.collider.name)

	manage_animations()



func manage_animations ():
  
	if vel.x > 0:
		play_animation("east")
	elif vel.x < 0:
		play_animation("west")
	elif vel.y < 0:
		play_animation("north")
	elif vel.y > 0:
		play_animation("south")
	elif facingDir.x == 1:
		play_animation("idle_east")
	elif facingDir.x == -1:
		play_animation("idle_west")
	elif facingDir.y == -1:
		play_animation("idle_north")
	elif facingDir.y == 1:
		play_animation("idle_south")

func play_animation (anim_name):
  
	if anim.animation != anim_name:
		anim.play(anim_name)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
