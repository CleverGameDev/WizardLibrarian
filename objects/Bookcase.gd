extends StaticBody2D

var object_type = "Bookcase"

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var old_position

const NUM_BOOKSHELVES = 8

var bookshelves = []
# currently selected shelf
var current_shelf_index = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	var bookshelf_scene = preload("res://objects/Bookshelf.tscn")
	for index in range(NUM_BOOKSHELVES):
		var new_bookshelf = bookshelf_scene.instance()
		new_bookshelf.my_index = index
		new_bookshelf.position = Vector2(-5.5 + 11*(index%2),-19.5+floor(index/2)*6)
			
		new_bookshelf.reset_sprite()
		bookshelves.append(new_bookshelf)
		add_child(new_bookshelf)

	pass # Replace with function body.

func grab_current_book():
	return bookshelves[current_shelf_index].grab_current_book()

func can_grab_book():
	return bookshelves[current_shelf_index].num_books() > 0

func num_books_on_current_shelf():
	return bookshelves[current_shelf_index].num_books()

# show a big bookcase zoomed in
func zoom_in():
	old_position = position
	current_shelf_index = 0
	bookshelves[0].select()
	scale = Vector2(8,8)
	z_index = 2
	set_as_toplevel(true)
	position = get_viewport_rect().size / 2

func zoom_out():
	z_index = 0
	bookshelves[current_shelf_index].unselect()
	set_as_toplevel(false)
	position = old_position
	scale = Vector2(2,2)
	#$ZoomedIn.visible = false

func zoom_current_bookshelf():
	zoom_out()
	bookshelves[current_shelf_index].zoom_in()

func zoom_out_bookshelf():
	bookshelves[current_shelf_index].zoom_out()
	zoom_in()

func shelve_book(book_id):
	bookshelves[current_shelf_index].shelve_book(book_id)

func shift_selected_bookcase_index(delta):
	bookshelves[current_shelf_index].unselect()
	current_shelf_index = (current_shelf_index + delta) % NUM_BOOKSHELVES
	bookshelves[current_shelf_index].select()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
