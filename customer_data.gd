class_name CustomerData extends Resource

@export var customer_name: String = ""
@export var customer_starter_message: String = ""
@export var customer_current_level: int = 0
@export var customer_order_dialogs: Array = []
@export var customer_order_rejection_dialogs: Array = []
@export var customer_order_accept_dialogs: Array = []
@export var customer_image: String = ""
@export var intro_finished: bool = false
@export var correct_items: Array = []

var customerName: String:
	get:
		return customer_name
	set(value):
		customer_name = value

var customerStarterMessage: String:
	get:
		return customer_starter_message
	set(value):
		customer_starter_message = value

var customerCurrentLevel: int:
	get:
		return customer_current_level
	set(value):
		customer_current_level = value

var customerOrderDialogs:
	get:
		return customer_order_dialogs
	set(value):
		customer_order_dialogs = value

var customerOrderRejectionDialogs:
	get:
		return customer_order_rejection_dialogs
	set(value):
		customer_order_rejection_dialogs = value

var customerOrderAcceptDialogs:
	get:
		return customer_order_accept_dialogs
	set(value):
		customer_order_accept_dialogs = value

var customerImage: String:
	get:
		return customer_image
	set(value):
		customer_image = value

var introFinished: bool:
	get:
		return intro_finished
	set(value):
		intro_finished = value

var correctItems:
	get:
		return correct_items
	set(value):
		correct_items = value

func _init(name: String = "", starter: String = "", order_dialogs: Array = [], rejection_dialogs: Array = [], accept_dialogs: Array = [], image_path: String = "", items: Array = []):
	customer_name = name
	customer_starter_message = starter
	customer_current_level = 0
	intro_finished = false
	customer_order_dialogs = order_dialogs
	customer_order_rejection_dialogs = rejection_dialogs
	customer_order_accept_dialogs = accept_dialogs
	customer_image = image_path
	correct_items = items

func reset():
	customer_current_level = 0
	intro_finished = false

func get_current_order_dialog():
	return customer_order_dialogs[customer_current_level]

func get_current_accept_dialog():
	return customer_order_accept_dialogs[customer_current_level]

func get_current_reject_dialog():
	return customer_order_rejection_dialogs[customer_current_level]

