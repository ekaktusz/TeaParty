extends Control

var text: String = "asdasdasdasd"

func _ready():
	var tween = get_tree().create_tween()
	
	tween.tween_property($Panel/MarginContainer/RichTextLabel, "visible_ratio", 1, 3)
	
	pass # Replace with function body.

func _process(delta):
	pass


func _on_button_make_tea_pressed():
	SceneTransition.change_scene_to_file("res://scenes/teamaking_scene.tscn")
	pass # Replace with function body.
