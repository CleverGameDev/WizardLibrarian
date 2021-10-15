# Allows us to find book information. 
# Keeps data about which book already has been used.
extends Node

# contains all books defined in res://data/books.json
var all_books
# allow us to easily look up a book by id
var id_to_book_index
# what has been shelved already
var used_ids = {}
# allow us to easily grab an unused book
var unused_ids = {}

var books_on_floor = {}

var BookScene
var Utilities

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

# put a new book on the floor
func instantiate_new_book_at(pos):
	if unused_ids.size() == 0:
		print("out of books!!!!")
	var new_book = BookScene.instance()
	# TODO: use utilities rand
	var new_id = unused_ids.keys()[ randi() % unused_ids.size() ]
	used_ids[new_id] = true
	unused_ids.erase(new_id)
	var book_attributes = get_book_by_id(new_id)
	new_book.assign_attributes(book_attributes)
	new_book.set_sprite(Utilities.get_random_integer(1,3))
	new_book.position.x = pos[0]
	new_book.position.y = pos[1]
	books_on_floor[new_id] = true
	return new_book


# Called when the node enters the scene tree for the first time.
func _ready():
	BookScene = preload("res://BookOnGround.tscn")
	Utilities = get_node("/root/TopLevel/GameManager/Utilities")

	all_books = load_json_file("res://data/books.json")["books"]

	id_to_book_index = {}
	var index = 0
	for book in all_books:
		id_to_book_index[book["id"]] = index
		unused_ids[book["id"]] = true
		index += 1

func get_book_by_id(book_id):
	var index = id_to_book_index[book_id]
	return all_books[index]

# func mark_book_as_used(book_id):
