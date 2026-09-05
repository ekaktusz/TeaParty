extends Node2D

var fading: bool = false
var fade_tween: Tween
var _fade_generation := 0

# Called when the node enters the scene tree for the first time.
func _ready():
	fade_in()
	pass # Replace with function body.

func readymeady() -> bool:
	return $Sprite2D.modulate == Color(1, 1, 1, 1)

func _cancel_active_fades() -> void:
	_fade_generation += 1
	if fade_tween != null:
		fade_tween.kill()
		fade_tween = null

func fade_in():
	_cancel_active_fades()
	var generation := _fade_generation
	self.fading = true
	var dbox = get_parent().get_node("DialogBox")
	$Sprite2D.modulate.a = 0
	dbox.modulate.a = 0
	
	var target_color = Color(1, 1, 1, 1)
	
	var tween := get_tree().create_tween()
	fade_tween = tween
	tween.set_parallel(true)
	tween.tween_property($Sprite2D, "modulate", target_color, 2)
	tween.tween_property(dbox, "modulate", target_color, 2)
	tween.set_parallel(false)
	if not SelectedIngredient.is_valid():
		tween.tween_callback(_start_dialog_print_effect.bind(dbox, generation))
	tween.tween_callback(_on_fade_finished.bind(generation))

func fade_out() -> bool:
	_cancel_active_fades()
	var generation := _fade_generation
	var dbox = get_parent().get_node("DialogBox")
	self.fading = true
	var target_color = Color(1, 1, 1, 0)
	var tween := get_tree().create_tween()
	fade_tween = tween
	tween.set_parallel(true)
	tween.tween_property($Sprite2D, "modulate", target_color, 2)
	tween.tween_property(dbox, "modulate", target_color, 2)
	tween.set_parallel(false)
	tween.tween_callback(_on_fade_finished.bind(generation))
	await tween.finished
	return generation == _fade_generation

func _start_dialog_print_effect(dbox: Control, generation: int) -> void:
	if generation != _fade_generation:
		return
	dbox.start_print_effect()

func _on_fade_finished(generation: int) -> void:
	if generation != _fade_generation:
		return
	fading = false
	fade_tween = null

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
	
func load_from_data(customer: CustomerData):
	$Sprite2D.texture = load(customer.customerImage)
	pass
