extends Node2D

var attributes

var object_type = "Book"

# Called when the node enters the scene tree for the first time.
func _ready():
	# $Sprite.self_modulate = Color(0, 0, 1)
	pass # Replace with function body.

func assign_attributes(new_attributes):
	attributes = new_attributes
