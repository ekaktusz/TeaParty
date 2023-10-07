extends Control

var is_complete: bool = false
var has_more: bool = true
var tween

func _ready():
	#start_print_effect()
	pass # Replace with function body.
	
func start_print_effect():
	self.is_complete = false
	tween = get_tree().create_tween()
	tween.tween_property($MarginContainer/MarginContainer/Panel/MarginContainer/RichTextLabel, "visible_ratio", 1, 3)
	tween.tween_callback(self.tween_complete)
	
func _process(delta):
	pass
	
func set_text(text: String):
	$MarginContainer/MarginContainer/Panel/MarginContainer/RichTextLabel.text = text
	$Button.visible = has_more

func tween_complete():
	self.is_complete = true
	$MarginContainer/MarginContainer/Panel/MarginContainer/RichTextLabel.visible_ratio = 1
	$Button.visible = has_more
	
func reset(text: String) -> void:
	$MarginContainer/MarginContainer/Panel/MarginContainer/RichTextLabel.visible_ratio = 0
	$Button.visible = false
	$MarginContainer/MarginContainer/Panel/MarginContainer/RichTextLabel.text = text
	start_print_effect()
	
	
	
