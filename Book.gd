extends StaticBody2D

var attributes

var object_type = "Book"

# Called when the node enters the scene tree for the first time.
func _ready():
	# $Sprite.self_modulate = Color(0, 0, 1)
	pass # Replace with function body.

func assign_attributes(new_attributes):
	attributes = new_attributes

# if we want to have the book visible
func set_sprite(sprite_index):
	var sprite
	if sprite_index == 1:
		sprite = $ClosedSprite
	elif sprite_index == 2:
		sprite = $OpenSprite
	else:
		sprite = $OpenFaceDownSprite
	sprite.visible = true
	$BookCollisionShape.visible = true
	$BookCollisionShape.shape.extents = sprite.region_rect.size
