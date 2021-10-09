extends YSort


func _ready():
	instantiateObjects()
	pass

# puts books on the ground and a bookcase
func instantiateObjects():
	var bookScene = preload("res://BookOnGround.tscn")
	var book1 = bookScene.instance()
	var bookShelfScene= preload("res://Bookshelf.tscn")
	var bookshelf1 = bookShelfScene.instance()
	bookshelf1.position.x = 550
	bookshelf1.position.y = 300
	var ySort = get_parent()
	print("y sort is")
	print(ySort)
	add_child(book1)
	add_child(bookshelf1)
	print("bookshelf y:")
	print(bookshelf1.position.y)
	print("bookshelf z index:")
	print(bookshelf1.z_index)

