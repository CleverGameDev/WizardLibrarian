extends StaticBody2D

var object_type = "Bookshelf"

# contains all the book ids in the shelf
var book_ids = []
var sprites = []
var my_index = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	sprites = [$FewBooksSprite, $SomeBooksSprite, $ManyBooksSprite]
	# the zoomed in bookshelf will not inherit position
	# it is a global position
	$ZoomSprite.set_as_toplevel(true)
	$ZoomSprite.position = get_viewport_rect().size / 2

func shelve_book(id):
	print("adding in a book")
	book_ids.append(id)
	print(book_ids.size())
	reset_sprite()

func reset_sprite():
	for sprite in sprites:
		sprite.visible = false

	if book_ids.size() > 5:
		$ManyBooksSprite.visible = true
	elif book_ids.size() > 2:
		$SomeBooksSprite.visible = true
	elif book_ids.size() > 0:
		$FewBooksSprite.visible = true
	elif my_index % 2 == 0:
		$EmptySpriteL.visible = true
	else:
		$EmptySpriteR.visible = true

# show a big bookshelf zoomed in
func zoom_in():
	for sprite in sprites:
		sprite.visible = false
	$ZoomSprite.visible = true

func zoom_out():
	reset_sprite()
	$ZoomSprite.visible = false

func select():
	modulate = Color(2.5,2.5,2.5)

func unselect():
	modulate = Color(1,1,1)
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
