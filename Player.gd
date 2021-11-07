extends KinematicBody2D

var moveSpeed : int = 250
var vel = Vector2()
var facingDir = Vector2()
# onready var rayCast = $RayCast2D

onready var anim = $PlayerSprite

# TODO: move this to its own object/script?
var carrying_books = []

var GameManager
var BookManager
var InventoryManager

var object_type = "Player"

# Called when the node enters the scene tree for the first time.
func _ready():
	GameManager = get_parent()
	BookManager = get_parent().get_node("BookManager")
	InventoryManager = get_parent().get_node("InventoryManager")

func set_description(text):
	get_parent().get_node("DescriptionNode/CurrentDescription").text = text

func interact_with_nearby_objects():
	for body in $PickupArea.get_overlapping_bodies():
		if ("object_type" in body && body.object_type == "Bookcase"):
			GameManager.view_bookcase(body)
			return
		elif ("object_type" in body && body.object_type == "Book"):
			InventoryManager.add_book_to_inventory(body.attributes["id"])
			body.free()
			return
		elif ("object_type" in body && body.object_type == "NPC"):
			body.talk()
			return
		elif ("object_type" in body && body.object_type == "desk"):
			set_description(body.get_description())

func view_nearby_objects():
	for body in $PickupArea.get_overlapping_bodies():
		if ("object_type" in body && body.object_type == "Bookcase"):
			set_description(body.description)
			return
		elif ("object_type" in body && body.object_type == "Book"):
			set_description(body.attributes["description"])
			return
		elif ("object_type" in body && body.object_type == "desk"):
			set_description(body.get_description())
			return
		else:
			set_description("")


func _input(event)->void:
	if event.is_action_pressed("ui_accept"):
		if GameManager.is_player_focus():
			interact_with_nearby_objects()
			get_tree().set_input_as_handled()

func _physics_process (delta):
	vel = Vector2()
	view_nearby_objects()
	# inputs
	if (GameManager.is_player_focus()):
		move_player()

func move_player():
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
