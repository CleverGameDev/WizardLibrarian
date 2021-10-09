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
	var bookshelf_scene = preload("res://Bookshelf.tscn")
	for index in range(NUM_BOOKSHELVES):
		var new_bookshelf = bookshelf_scene.instance()
		new_bookshelf.my_index = index
		new_bookshelf.position = Vector2(-5.5 + 10*(index%2),-19.5+floor(index/2)*6)
#		if index == 0:#
#			new_bookshelf.position = Vector2(-5.5,-19.5)#
#		elif index == 1:
#			new_bookshelf.position = Vector2(5.5, -19.5)
#		elif index == 2:
#			new_bookshelf.position = Vector2(-5.5, -13.5)
#		elif index == 3:
#			new_bookshelf.position = Vector2(5.5, -13.5)
#		elif index == 4:
#			new_bookshelf.position = Vector2(-5.5, -7.5)
#		elif index == 5:
#			new_bookshelf.position = Vector2(5.5, -7.5)
#		elif index == 6:
#			new_bookshelf.position = Vector2(-5.5, -1.5)
#		elif index == 7:
#			new_bookshelf.position = Vector2(5.5, -1.5)
			
		new_bookshelf.reset_sprite()
		# TODO: set bookshelf position
		bookshelves.append(new_bookshelf)
		print(new_bookshelf.position.x)
		add_child(new_bookshelf)

	pass # Replace with function body.

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
	scale = Vector2(1,1)
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
