extends StaticBody2D

var object_type = "Bookshelf"

var sprites = []
var zoomed_sprites = []
var my_index = 0
var recently_unshelved = false
var selected_book_index = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	sprites = [$FewBooksSprite, $SomeBooksSprite, $ManyBooksSprite, $EmptySpriteL, $EmptySpriteR]
	zoomed_sprites = [$ZoomedShelf/ZoomedShelfWoodFew,$ZoomedShelf/ZoomedShelfWoodSome, $ZoomedShelf/ZoomedShelfWoodMany, $ZoomedShelf/ZoomedShelfWoodLots]
	# the zoomed in bookshelf will not inherit position
	# it is a global position
	#$ZoomedShelf.set_as_toplevel(true)
	#$ZoomedShelf.position = get_viewport_rect().size / 2

func shelve_book(id):
	var BookManager = get_node("/root/TopLevel/GameManager/BookManager")
	var book_attributes = BookManager.get_book_by_id(id)
	var book_scene = preload("res://objects/BookOnShelf.tscn")
	var new_book = book_scene.instance()
	new_book.assign_attributes(book_attributes)
	$ZoomedShelf/Books.add_child(new_book)
	zoom_in()

func redraw_zoomed_books(move_positions):
	var num_books = $ZoomedShelf/Books.get_child_count()

	var i = -num_books/2
	var index = 0
	print("going through books")
	for book in $ZoomedShelf/Books.get_children():
		if index == selected_book_index:
			book.select()
		else:
			book.unselect()
		var size = (book.get_children()[0].region_rect.size)
		book.position = Vector2(i*8*size.x, -8*(size.y/2))
		i += 1
		index += 1
	redraw_book_label()

func reset_sprite():
	var num_books = $ZoomedShelf/Books.get_child_count()

	for sprite in sprites:
		sprite.visible = false

	if num_books > 5:
		$ManyBooksSprite.visible = true
	elif num_books > 2:
		$SomeBooksSprite.visible = true
	elif num_books > 0:
		$FewBooksSprite.visible = true
	elif num_books % 2 == 0:
		$EmptySpriteL.visible = true
	else:
		$EmptySpriteR.visible = true

# show a big bookshelf zoomed in
func zoom_in():
	var num_books = $ZoomedShelf/Books.get_child_count()
	selected_book_index = floor(num_books/2)
	recently_unshelved = false
	for sprite in sprites:
		sprite.visible = false
	$ZoomedShelf.visible = true
	$ZoomedShelf/Books.visible = true
	for sprite in zoomed_sprites:
		sprite.visible = false
	if num_books > 15:
		$ZoomedShelf/ZoomedShelfWoodLots.visible = true
	elif num_books > 10:
		$ZoomedShelf/ZoomedShelfWoodMany.visible = true
	elif num_books > 5:
		$ZoomedShelf/ZoomedShelfWoodSome.visible = true
	else:
		$ZoomedShelf/ZoomedShelfWoodFew.visible = true
	redraw_zoomed_books(true)
	
func redraw_book_label():
	if selected_book_index < $ZoomedShelf/Books.get_child_count():
		var description = $ZoomedShelf/Books.get_children()[selected_book_index].attributes["description"]
		$ZoomedShelf/CurrentBookLabel.text = description
	else:
		$ZoomedShelf/CurrentBookLabel.text = ""

func zoom_out():
	if recently_unshelved:
		redraw_zoomed_books(true)
	recently_unshelved = false
	reset_sprite()
	$ZoomedShelf.visible = false
	$ZoomedShelf/Books.visible = false

func select():
	modulate = Color(2.2,2.2,2.2)

func unselect():
	modulate = Color(1,1,1)

func num_books():
	return $ZoomedShelf/Books.get_child_count()

func grab_current_book():
	var book_child = $ZoomedShelf/Books.get_children()[selected_book_index]
	var book_id = book_child.attributes["id"]
	$ZoomedShelf/Books.remove_child(book_child)
	if selected_book_index >= $ZoomedShelf/Books.get_child_count():
		shift_selected_book_index(-1)
	recently_unshelved = true
	redraw_zoomed_books(false)
	return book_id

func shift_selected_book_index(delta):
	var num_books = $ZoomedShelf/Books.get_child_count()
	if num_books == 0:
		return
	selected_book_index = int(selected_book_index) % num_books
	selected_book_index = (selected_book_index + delta) % num_books
	redraw_zoomed_books(false)

func _input(event)->void:
	if !$ZoomedShelf.visible || $ZoomedShelf/Books.get_children().size() == 0:
		return
	# selecting a book on the shelf
	if event.is_action_pressed("ui_left"):
		shift_selected_book_index(-1)
		get_tree().set_input_as_handled()
	elif event.is_action_pressed("ui_right"):
		shift_selected_book_index(1)
		get_tree().set_input_as_handled()

