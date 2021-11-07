extends Node2D

var GameManager

onready var shelve_button: = find_node("Shelve")
onready var unshelve_button: = find_node("Unshelve")

func _ready():
	shelve_button.connect("pressed", self, "_on_shelve_pressed")
	unshelve_button.connect("pressed", self, "_on_unshelve_pressed")
	GameManager = get_parent()

func show():
	$Control.visible = true
	$Control/VBoxContainer/Shelve.grab_focus()

func hide():
	$Control.visible = false

func _on_shelve_pressed():
	GameManager.focus_out_of_inner_ui()
	GameManager.start_shelve_book()
	hide()

func _on_unshelve_pressed():
	GameManager.focus_out_of_inner_ui()
	GameManager.grab_book()
	hide()
