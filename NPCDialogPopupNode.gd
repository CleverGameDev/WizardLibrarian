extends Node2D

var GameManager

onready var offer_book_button: = find_node("OfferBook")
onready var exit_button: = find_node("Exit")

func _ready():
	offer_book_button.connect("pressed", self, "_on_offer_book_pressed")
	exit_button.connect("pressed", self, "_on_exit_dialog_pressed")
	GameManager = get_node("/root/TopLevel/GameManager")

func show():
	self.visible = true
	$Control/VBoxContainer/OfferBook.grab_focus()

func hide():
	self.visible = false

func _on_offer_book_pressed():
	# TODO: 
	# GameManager.focus_on_inventory()
	GameManager.focus_out_of_dialog()
	hide()

func _on_exit_dialog_pressed():
	GameManager.focus_out_of_dialog()
	hide()
