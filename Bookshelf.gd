extends StaticBody2D

var object_type = "Bookshelf"

# contains all the books in the shelf
# book objects live under $ZoomedShelf/Books
var books = []
var sprites = []
var zoomed_sprites = []
var my_index = 0
var recently_unshelved = false

# Called when the node enters the scene tree for the first time.
func _ready():
	sprites = [$FewBooksSprite, $SomeBooksSprite, $ManyBooksSprite, $EmptySpriteL, $EmptySpriteR]
	zoomed_sprites = [$ZoomedShelf/ZoomedShelfWoodFew,$ZoomedShelf/ZoomedShelfWoodSome, $ZoomedShelf/ZoomedShelfWoodMany, $ZoomedShelf/ZoomedShelfWoodLots]
	# the zoomed in bookshelf will not inherit position
	# it is a global position
	#$ZoomedShelf.set_as_toplevel(true)
	#$ZoomedShelf.position = get_viewport_rect().size / 2

# TODO
func unshelve_book(id):
	recently_unshelved = true
	pass

func shelve_book(id):
	var BookManager = get_node("/root/TopLevel/GameManager/BookManager")
	var book = BookManager.get_book_by_id(id)
	books.append(book)
	var book_scene = preload("res://BookOnShelf.tscn")
	var new_book = book_scene.instance()
	$ZoomedShelf/Books.add_child(new_book)
	redraw_zoomed_books()
	reset_sprite()

func redraw_zoomed_books():
	var i = -books.size()/2
	for book in $ZoomedShelf/Books.get_children():
		
		var size = (book.get_children()[0].region_rect.size)
		print(size)
		book.position = Vector2(i*8*size.x, -8*(size.y/2))
		i += 1
	pass

func reset_sprite():
	for sprite in sprites:
		sprite.visible = false

	if books.size() > 5:
		$ManyBooksSprite.visible = true
	elif books.size() > 2:
		$SomeBooksSprite.visible = true
	elif books.size() > 0:
		$FewBooksSprite.visible = true
	elif my_index % 2 == 0:
		$EmptySpriteL.visible = true
	else:
		$EmptySpriteR.visible = true

# show a big bookshelf zoomed in
func zoom_in():
	recently_unshelved = false
	for sprite in sprites:
		sprite.visible = false
	$ZoomedShelf.visible = true
	$ZoomedShelf/Books.visible = true
	for sprite in zoomed_sprites:
		sprite.visible = false
	if books.size() > 15:
		$ZoomedShelf/ZoomedShelfWoodLots.visible = true
	elif books.size() > 10:
		$ZoomedShelf/ZoomedShelfWoodMany.visible = true
	elif books.size() > 5:
		$ZoomedShelf/ZoomedShelfWoodSome.visible = true
	else:
		$ZoomedShelf/ZoomedShelfWoodFew.visible = true
	

func zoom_out():
	if recently_unshelved:
		redraw_zoomed_books()
	recently_unshelved = false
	reset_sprite()
	$ZoomedShelf.visible = false
	$ZoomedShelf/Books.visible = false

func select():
	modulate = Color(2.2,2.2,2.2)

func unselect():
	modulate = Color(1,1,1)
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
