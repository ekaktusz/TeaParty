extends Node2D

var fading: bool = false
var sprite_tween: Tween
var dialog_tween: Tween

# Called when the node enters the scene tree for the first time.
func _ready():
	fade_in()
	pass # Replace with function body.

func readymeady() -> bool:
	return $Sprite2D.modulate == Color(1, 1, 1, 1)

func _cancel_active_fades() -> void:
	if sprite_tween != null:
		sprite_tween.kill()
		sprite_tween = null
	if dialog_tween != null:
		dialog_tween.kill()
		dialog_tween = null

func fade_in():
	_cancel_active_fades()
	self.fading = true
	var dbox = get_parent().get_node("DialogBox")
	$Sprite2D.modulate.a = 0
	dbox.modulate.a = 0
	
	var target_color = Color(1, 1, 1, 1)
	
	sprite_tween = get_tree().create_tween()
	sprite_tween.tween_property($Sprite2D, "modulate", target_color, 2)
	sprite_tween.tween_callback(self.fade_complete)
	
	dialog_tween = get_tree().create_tween()
	dialog_tween.tween_property(dbox, "modulate", target_color, 2)
	if not SelectedIngredient.is_valid():
		dialog_tween.tween_callback(dbox.start_print_effect)

func fade_out():
	_cancel_active_fades()
	var dbox = get_parent().get_node("DialogBox")
	self.fading = true
	var target_color = Color(1, 1, 1, 0)
	sprite_tween = get_tree().create_tween()
	sprite_tween.tween_property($Sprite2D, "modulate", target_color, 2)
	sprite_tween.tween_callback(self.fade_complete)
	
	dialog_tween = get_tree().create_tween()
	dialog_tween.tween_property(dbox, "modulate", target_color, 2)
	dialog_tween.tween_callback(dbox.clear)
	
func fade_complete():
	self.fading = false
	if sprite_tween != null and sprite_tween.is_running():
		return
	if dialog_tween != null and dialog_tween.is_running():
		return
	if sprite_tween != null:
		sprite_tween = null
	if dialog_tween != null:
		dialog_tween = null
	
func fade_completed():
	self.fading = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
	
func load_from_data(customer: CustomerData):
	$Sprite2D.texture = load(customer.customerImage)
	pass
