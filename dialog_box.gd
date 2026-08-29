extends Control

var is_complete: bool = false
var has_more: bool = true

func _ready():
	#start_print_effect()
	pass # Replace with function body.
	
func start_print_effect():
	#print("start_print_effect")
	self.is_complete = false
	$MarginContainer/MarginContainer/Panel/MarginContainer/RichTextLabel.visible_ratio = 0
	var tween = get_tree().create_tween()
	tween.tween_property($MarginContainer/MarginContainer/Panel/MarginContainer/RichTextLabel, "visible_ratio", 1, 2)
	tween.tween_callback(self.tween_complete)
	
func _process(delta):
	#print($MarginContainer/MarginContainer/Panel/MarginContainer/RichTextLabel.visible_ratio)
	#print($MarginContainer/MarginContainer/Panel/MarginContainer/RichTextLabel.text)
	pass
	
func set_text(text: String):
	#print("set_text")
	#print(text)
	self.is_complete = false
	$MarginContainer/MarginContainer/Panel/MarginContainer/RichTextLabel.text = text
	
func get_text():
	return $MarginContainer/MarginContainer/Panel/MarginContainer/RichTextLabel.text

func tween_complete():
	self.is_complete = true
	$Button.visible = has_more
	$MarginContainer/MarginContainer/Panel/MarginContainer/RichTextLabel.visible_ratio = 1
	#get_parent().get_node("Button").disabled = false
	
func reset(text: String) -> void:
	#print("reset")
	#print(text)
	$MarginContainer/MarginContainer/Panel/MarginContainer/RichTextLabel.visible_ratio = 0
	$Button.visible = false
	self.is_complete = false
	$MarginContainer/MarginContainer/Panel/MarginContainer/RichTextLabel.text = text
	start_print_effect()

func clear():
	$MarginContainer/MarginContainer/Panel/MarginContainer/RichTextLabel.visible_ratio = 0
	pass
	
