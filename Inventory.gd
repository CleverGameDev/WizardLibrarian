# What is the wizard carrying? Probably some books.
extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var carried_book_ids = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func pick_up_book_by_id(id):
	carried_book_ids[id] = true

func drop_book_by_id(id):
	carried_book_ids.erase(id)

# func is_carrying_book(id):

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
