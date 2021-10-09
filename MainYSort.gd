# This class does everything
extends YSort

# determines if left/right/up/down moves the player, 
# or currently selected shelf/book
enum Focus {PLAYER_FOCUS, BOOKCASE_FOCUS, BOOKSHELF_FOCUS}
var current_focus = Focus.PLAYER_FOCUS

var current_bookcase
var current_bookshelf

func _ready():
	print(self.get_path())
	instantiate_objects()
	pass

# puts books on the ground and a bookcase
func instantiate_objects():
	for pos in [[500,300], [480,250], [520,230]]:
		add_child($BookManager.instantiate_new_book_at(pos))
	var bookcase_scene = preload("res://Bookcase.tscn")
	var bookcase1 = bookcase_scene.instance()
	bookcase1.position.x = 550
	bookcase1.position.y = 350
	add_child(bookcase1)

# convenience function to see if we are in the main map.
# used in GUI
func is_player_focus():
	return current_focus == Focus.PLAYER_FOCUS

func view_bookcase(body):
	current_focus = Focus.BOOKCASE_FOCUS
	$BookcasePopupNode.visible = true
	body.zoom_in()
	current_bookcase = body


func _input(event)->void:
	if event.is_action_pressed("ui_cancel"):
		if is_player_focus():
			return
		# focus back one level -- shelf to bookcase, bookcase to main world
		if current_focus == Focus.BOOKSHELF_FOCUS:
			$BookcasePopupNode.visible = true
			current_bookcase.zoom_out_bookshelf()
		elif current_focus == Focus.BOOKCASE_FOCUS:
			$BookcasePopupNode.visible = false
			current_bookcase.zoom_out()
		current_focus -= 1
		get_tree().set_input_as_handled()
	elif event.is_action_pressed("ui_accept"):
		if current_focus == Focus.BOOKCASE_FOCUS:
			current_focus = Focus.BOOKSHELF_FOCUS
			current_bookcase.zoom_current_bookshelf()
			get_tree().set_input_as_handled()
		elif current_focus == Focus.BOOKSHELF_FOCUS:
			var book_id = $Player.carrying_books.pop_front()
			if book_id:
				current_bookcase.shelve_book(book_id)
				get_tree().set_input_as_handled()
	# selecting a shelf on the bookcase
	elif current_focus == Focus.BOOKCASE_FOCUS && event.is_action_pressed("ui_left"):
		current_bookcase.shift_selected_bookcase_index(-1)
		get_tree().set_input_as_handled()
	elif current_focus == Focus.BOOKCASE_FOCUS && event.is_action_pressed("ui_right"):
		current_bookcase.shift_selected_bookcase_index(1)
		get_tree().set_input_as_handled()
	elif current_focus == Focus.BOOKCASE_FOCUS && event.is_action_pressed("ui_up"):
		current_bookcase.shift_selected_bookcase_index(-2)
		get_tree().set_input_as_handled()
	elif current_focus == Focus.BOOKCASE_FOCUS && event.is_action_pressed("ui_down"):
		current_bookcase.shift_selected_bookcase_index(2)
		get_tree().set_input_as_handled()
