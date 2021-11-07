extends StaticBody2D


var object_type = "desk"
# is this the point of the game? your reputation.
var reputation = 0
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func get_description():
	var reputation_description = ""
	if reputation >= -2 && reputation < 10:
		reputation_description +=  "On the desk lie a few letters of enquiry. Your bookshop is neither well known, nor does it have any good or bad reputation."
	elif reputation >= 10 && reputation < 20:
		reputation_description +=  "On the desk lie a few letters from thankful customers. Your bookshop is gaining a good reputation!"
	elif reputation < -2 && reputation > -10:
		reputation_description +=  "On the desk lie a few letters complaining about your bookshop. Your shop is getting a negative reputation!"
	reputation_description += "\nReputation: "+ String(reputation)
	return reputation_description

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
