extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var rng = RandomNumberGenerator.new()
func _ready():
	print(self.get_path())
	rng.randomize()

func get_random_integer(low, high):
	return rng.randi_range(low, high)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
