extends Node2D


var carrying_books = []
var BookManager
# examine, shelving, or offer_to_NPC
enum Mode {NONE, EXAMINE, SHELVING, OFFER_TO_NPC}
var current_mode = Mode.NONE
var current_book_index = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	BookManager = get_parent().get_node("BookManager")
	pass # Replace with function body.

func redraw_inventory():
	var text_node_to_clone = $InventoryText
	for child in $VBoxContainer.get_children():
		child.free()
	for book_id in carrying_books:
		var inventory_book_label = text_node_to_clone.duplicate()
		inventory_book_label.text = "- " + BookManager.get_book_by_id(book_id)["title"]
		$VBoxContainer.add_child(inventory_book_label)

func add_book_to_inventory(book_id):
	carrying_books.append(book_id)
	redraw_inventory()

func pop_first_book():
	var first_book = carrying_books.pop_front()
	redraw_inventory()
	return first_book

func focus_out_of_self():
	current_mode = Mode.NONE
	$SelectionNode.visible = false
	$CurrentBookLabel.text = ""
	pass

func get_and_remove_selected_book_id():
	if current_book_index >= len(carrying_books):
		return null
	var book_id = carrying_books[current_book_index]
	carrying_books.remove(current_book_index)
	redraw_inventory()
	return book_id

func focus_on_self(mode):
	current_mode = mode
	$SelectionNode.visible = true
	$SelectionNode.position.y += 50
	if len(carrying_books) > 0:
		current_book_index = 0
		set_selection_node_to_index(current_book_index)
	redraw_book_label()

func redraw_book_label():
	if current_book_index < $VBoxContainer.get_child_count():
		var book = BookManager.get_book_by_id(carrying_books[current_book_index])
		$CurrentBookLabel.text = book.description
	else:
		$CurrentBookLabel.text = ""

func set_selection_node_to_index(index):
	if index > len(carrying_books):
		return
	var y_pos = $VBoxContainer.get_children()[index].rect_position.y
	$SelectionNode.position.y = y_pos + 33

func shift_selected_item(delta):
	current_book_index += delta
	current_book_index = current_book_index % len(carrying_books)
	set_selection_node_to_index(current_book_index)
	redraw_book_label()
