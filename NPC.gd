extends KinematicBody2D

var moveSpeed : int = 30
var vel = Vector2()
var facingDir = Vector2()
# onready var rayCast = $RayCast2D

enum State {INITIAL, HAS_GIVEN_QUEST}
var current_state = State.INITIAL

onready var anim = $NPCSprite

# TODO: move this to its own object/script?
var carrying_books = []

var quest

var QuestManager
var GameManager

var object_type = "NPC"

# Called when the node enters the scene tree for the first time.
func _ready():
	$NPCDialogPopupNode.set_as_toplevel(true)
	GameManager = get_node("/root/TopLevel/GameManager")
	QuestManager = get_node("/root/TopLevel/GameManager/QuestManager")
	quest = QuestManager.start_new_quest()
	print(quest)
	set_start_movement()


func show_dialog(text):
	GameManager.focus_on_dialog()
	$NPCDialogPopupNode.show()
	$NPCDialogPopupNode/DialogText.text = text

func hide_dialog():
	$NPCDialogPopupNode.hide()

func talk():
	# show next dialog
	if current_state == State.INITIAL:
		show_dialog(quest["description"])

func set_start_movement():
	set_movement(0,1)
	yield(get_tree().create_timer(2.0), "timeout")
	set_movement(-1,0)
	yield(get_tree().create_timer(1.0), "timeout")
	set_movement(0,0)


func set_movement(x, y):
	vel.x = 0
	vel.y = 0

	if y < 0:
		vel.y -= 1
		facingDir = Vector2(0, -1)
	elif y > 0:
		vel.y += 1
		facingDir = Vector2(0, 1)
	if x < 0:
		vel.x -= 1
		facingDir = Vector2(-1, 0)
	if x > 0:
		vel.x += 1
		facingDir = Vector2(1, 0)
  
	# normalize the velocity to prevent faster diagonal movement
	# vel = vel.normalized()
  
	# move the player
func _physics_process (delta):
	move_and_slide(vel * moveSpeed, Vector2.ZERO)
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

