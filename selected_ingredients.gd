extends Node

var prop1: PropData = null
var prop2: PropData = null
var prop3: PropData = null

func get_names() -> Array:
	var names = []
	if prop1 != null:
		names.append(prop1.propName)
	if prop2 != null:
		names.append(prop2.propName)
	if prop3 != null:
		names.append(prop3.propName)
	return names

func has_three_distinct_entries() -> bool:
	var names = get_names()
	if names.size() != 3:
		return false

	for i in range(names.size()):
		for j in range(i + 1, names.size()):
			if names[i] == names[j]:
				return false
	return true

func is_valid() -> bool:
	return prop1 != null and prop2 != null and prop3 != null

func reset():
	prop1 = null
	prop2 = null
	prop3 = null
