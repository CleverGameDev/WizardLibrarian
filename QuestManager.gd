# Allows us to find quest information. 
# Keeps data about which quest already has been used.
extends Node

# contains all quests defined in res://data/quests.json
var all_quests
# allow us to easily look up a quest by id
var id_to_quest_index
# what has been done already
var used_ids = {}
# allow us to easily grab an unused quest
var unused_ids = {}

var Utilities

func load_json_file(path):
	var file = File.new()
	file.open(path, file.READ)
	var text = file.get_as_text()
	var result_json = JSON.parse(text)
	if result_json.error != OK:
		print("[load_json_file] Error loading JSON file '" + str(path) + "'.")
		print("\tError: ", result_json.error)
		print("\tError Line: ", result_json.error_line)
		print("\tError String: ", result_json.error_string)
		return null
	var obj = result_json.result
	return obj

func start_new_quest():
	if unused_ids.size() == 0:
		print("out of quests!!!!")
	# TODO: use utilities rand
	var new_id = unused_ids.keys()[ randi() % unused_ids.size() ]
	used_ids[new_id] = true
	unused_ids.erase(new_id)
	var new_quest = get_quest_by_id(new_id)
	return new_quest

func finish_quest(book_id):
	# TODO: reputation gain/loss?
	return 0

# Called when the node enters the scene tree for the first time.
func _ready():
	Utilities = get_node("/root/TopLevel/GameManager/Utilities")

	all_quests = load_json_file("res://data/quests.json")["quests"]

	id_to_quest_index = {}
	var index = 0
	for quest in all_quests:
		id_to_quest_index[quest["id"]] = index
		unused_ids[quest["id"]] = true
		index += 1

func get_quest_by_id(quest_id):
	var index = id_to_quest_index[quest_id]
	return all_quests[index]
