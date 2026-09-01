extends Control

var is_complete: bool = false
var has_more: bool = true
var text_tween: Tween

const DEFAULT_BACKGROUND_COLOR := Color(0.92549, 0.796078, 0.619608, 1)
const ACCEPT_BACKGROUND_COLOR := Color(0.78, 0.92, 0.78, 1)
const REJECT_BACKGROUND_COLOR := Color(0.96, 0.78, 0.78, 1)

func _ready():
	#start_print_effect()
	pass # Replace with function body.
	
func start_print_effect():
	#print("start_print_effect")
	self.is_complete = false
	$MarginContainer/MarginContainer/Panel/MarginContainer/RichTextLabel.visible_ratio = 0
	if text_tween != null:
		text_tween.kill()
	text_tween = get_tree().create_tween()
	text_tween.tween_property($MarginContainer/MarginContainer/Panel/MarginContainer/RichTextLabel, "visible_ratio", 1, 2)
	text_tween.tween_callback(self.tween_complete)

func reveal_text() -> void:
	if is_complete:
		return
	if text_tween != null:
		text_tween.kill()
	$MarginContainer/MarginContainer/Panel/MarginContainer/RichTextLabel.visible_ratio = 1
	tween_complete()
	
func _process(delta):
	#print($MarginContainer/MarginContainer/Panel/MarginContainer/RichTextLabel.visible_ratio)
	#print($MarginContainer/MarginContainer/Panel/MarginContainer/RichTextLabel.text)
	pass
	
func set_text(text: String):
	#print("set_text")
	#print(text)
	self.is_complete = false
	$MarginContainer/MarginContainer/Panel/MarginContainer/RichTextLabel.text = text
	set_neutral()
	
func get_text():
	return $MarginContainer/MarginContainer/Panel/MarginContainer/RichTextLabel.text

func set_neutral() -> void:
	set_background_color(DEFAULT_BACKGROUND_COLOR)

func set_feedback(accepted: bool) -> void:
	var feedback_color := ACCEPT_BACKGROUND_COLOR if accepted else REJECT_BACKGROUND_COLOR
	set_background_color(feedback_color)

func set_background_color(color: Color) -> void:
	var panel_style := $MarginContainer/MarginContainer/Panel.get_theme_stylebox("panel").duplicate() as StyleBoxFlat
	panel_style.bg_color = color
	$MarginContainer/MarginContainer/Panel.add_theme_stylebox_override("panel", panel_style)

func tween_complete():
	self.is_complete = true
	$Button.visible = has_more
	$MarginContainer/MarginContainer/Panel/MarginContainer/RichTextLabel.visible_ratio = 1
	#get_parent().get_node("Button").disabled = false
	
func reset(text: String) -> void:
	#print("reset")
	#print(text)
	set_neutral()
	$MarginContainer/MarginContainer/Panel/MarginContainer/RichTextLabel.visible_ratio = 0
	$Button.visible = false
	self.is_complete = false
	$MarginContainer/MarginContainer/Panel/MarginContainer/RichTextLabel.text = text
	start_print_effect()

func clear():
	$MarginContainer/MarginContainer/Panel/MarginContainer/RichTextLabel.visible_ratio = 0
	pass
	
