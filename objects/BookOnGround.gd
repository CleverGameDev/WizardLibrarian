extends StaticBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var booksDictionary

func load_json_file(path):
	var file = File.new()
	file.open(path, file.READ)
	var text = file.get_as_text()
	var result_json = JSON.parse(text)
	if result_json.error != OK:
		print("[load_json_file] Error loading JSON file '" + str(path) + "'.")
		print("\tError: ", result_json.error)
		print("\tError Line: ", result_json.error_line)
		print("\tError String: ", result_json.error_string)
		return null
	var obj = result_json.result
	return obj


# Called when the node enters the scene tree for the first time.
func _ready():
	booksDictionary = load_json_file("res://data/books.json")
	print(booksDictionary["books"][0])
	# $Sprite.self_modulate = Color(0, 0, 1)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
