extends Control

var is_complete: bool = false
var has_more: bool = true

func _ready():
	start_print_effect()
	
	pass # Replace with function body.
	
func start_print_effect():
	var tween = get_tree().create_tween()
	tween.tween_property($MarginContainer/MarginContainer/Panel/MarginContainer/RichTextLabel, "visible_ratio", 1, 3)
	tween.tween_callback(self.tween_complete)
	
func _process(delta):
	pass

func _on_button_make_tea_pressed():
	SceneTransition.change_scene_to_file("res://scenes/teamaking_scene.tscn")
	pass # Replace with function body.

func tween_complete():
	is_complete = true
	if has_more:
		$Button.visible = true
	
func reset(text: String) -> void:
	$MarginContainer/MarginContainer/Panel/MarginContainer/RichTextLabel.visible_ratio = 0
	$Button.visible = false
	$MarginContainer/MarginContainer/Panel/MarginContainer/RichTextLabel.text = text
	start_print_effect()
	
	
