extends Node
class_name SelectedIngredients

var prop1: PropData = null
var prop2: PropData = null
var prop3: PropData = null

func is_valid() -> bool:
	return prop1 != null and prop2 != null and prop3 != null
