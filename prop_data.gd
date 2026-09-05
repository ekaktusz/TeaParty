class_name PropData extends Resource

@export var prop_name: String = ""
@export var prop_icon_path: String = ""
@export var prop_card_path: String = ""

var propName: String:
	get:
		return prop_name
	set(value):
		prop_name = value

var propIconPath: String:
	get:
		return prop_icon_path
	set(value):
		prop_icon_path = value

var propCardPath: String:
	get:
		return prop_card_path
	set(value):
		prop_card_path = value

func _init(in_name: String = "", icon_path: String = "", card_path: String = ""):
	prop_name = in_name
	prop_icon_path = icon_path
	prop_card_path = card_path
